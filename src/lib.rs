use serde::{Serialize, Deserialize};

#[derive(Clone)]
pub struct User {
    pub message_chan: tokio::sync::mpsc::UnboundedSender<warp::ws::Message>,
}

#[derive(Clone, Serialize)]
pub struct LoginResponse {
    pub username: String,
}

#[derive(Clone, Serialize, Deserialize)]
pub struct Message {
    #[serde(skip_deserializing)]
    pub username: String,
    pub message: String,
}

#[derive(Clone, Serialize)]
pub struct Error {
    pub error: String
}

impl Error {
    pub fn new<T: AsRef<str>>(msg: T) -> Error {
        Self {
            error: msg.as_ref().to_string()
        }
    }

    pub fn message(&self) -> warp::ws::Message {
        warp::ws::Message::text(serde_json::to_string(self).unwrap())
    }
}