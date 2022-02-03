
const openSocket = (callback) => {
    let url = "ws://localhost:8080/echo"
    let websocket = new WebSocket(url/*, protocols*/);
    
    websocket.onopen = (event) => {
        callback(websocket);
    }
}

const onSearch = (socket) => {
      
}