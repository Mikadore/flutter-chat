use serde::{Serialize, Deserialize};

#[derive(PartialEq, Eq, Clone, Serialize, Deserialize)]
pub struct Token(String);

impl Token {
    pub fn new() -> Token {
        let rand = rand::random::<[u8;32]>();
        Token(base64::encode(rand))
    }

    pub fn as_str<'a>(&'a self) -> &'a str {
        &self.0
    }
}

#[derive(Clone)]
pub struct User {
    pub message_chan: tokio::sync::mpsc::UnboundedSender<warp::ws::Message>,
}

#[derive(Clone, Serialize)]
pub struct LoginResponse {
    pub token: Token,
    pub username: String,
}

#[derive(Clone, Serialize, Deserialize)]
pub struct Message {
    #[serde(skip_serializing)]
    pub token: Token,
    #[serde(skip_deserializing)]
    pub username: String,
    pub message: String,
}

