use chashmap::CHashMap;
use chat::Error;
use futures_util::{SinkExt, StreamExt};
use std::sync::Arc;
use tokio::sync::mpsc;
use warp::http::StatusCode;
use warp::ws::{Message, Ws};
use warp::{Filter, Reply};

pub type UserState = Arc<CHashMap<String, chat::User>>;

fn message_all_users(msg: Message, users: &UserState) {
    let users = (**users).clone();
    for (_, user) in users.into_iter() {
        if let Err(e) = user.message_chan.send(msg.clone()) {
            log::error!("User message channel is closed: {}", e)
        }
    }
}

#[tokio::main]
async fn main() {
    pretty_env_logger::init();

    let users = UserState::default();

    let chatsock = warp::path("api")
        .and(warp::ws())
        .and(warp::path::param())
        .and(warp::any().map(move || users.clone()))
        .map(|ws: Ws, username: String, users: UserState| {
            if users.get(&username).is_some() {
                return warp::reply::with_status(warp::reply(), StatusCode::CONFLICT)
                    .into_response();
            }
            ws.on_upgrade(|ws| async move {
                let (message_tx, mut message_rx) = mpsc::unbounded_channel::<Message>();
                let (mut user_ws_tx, mut user_ws_rx) = ws.split();

                let user = chat::User {
                    message_chan: message_tx.clone(),
                };

                if let Some(user) = users.insert(username.clone(), user.clone()) {
                    let _ = user_ws_tx
                        .send(Error::new("Username taken").message())
                        .await;
                    let _ = user_ws_tx.close().await;
                    users.insert(username.clone(), user);
                }

                let response_json = serde_json::to_string(&chat::LoginResponse {
                    username: username.clone(),
                })
                .unwrap();

                let _ = user_ws_tx.send(Message::text(response_json)).await;

                tokio::spawn(async move {
                    while let Some(msg) = message_rx.recv().await {
                        user_ws_tx
                            .send(msg)
                            .await
                            .unwrap_or_else(|e| log::info!("WebSocket error: {}", e))
                    }
                });

                while let Some(msg) = user_ws_rx.next().await {
                    match msg {
                        Ok(msg) => {
                            match serde_json::from_slice::<chat::Message>(msg.as_bytes()) {
                                Ok(mut msg) => {
                                    msg.username = username.clone();
                                    // Need to re-serialize message because of token
                                    message_all_users(
                                        Message::text(serde_json::to_string(&msg).unwrap()),
                                        &users,
                                    )
                                }
                                Err(e) => {
                                    let _ = message_tx.send(
                                        Error::new(format!("Invalid json format: {}", e)).message(),
                                    );
                                }
                            }
                        }
                        Err(e) => log::info!("WebSocket error: {}", e),
                    }
                }

                users.remove(&username);
            })
            .into_response()
        });

    warp::serve(warp::get().and(warp::fs::dir("ui/build/web").or(chatsock)))
        .run(([0, 0, 0, 0], 8080))
        .await
}
