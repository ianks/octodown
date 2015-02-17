var socket = new WebSocket('ws://localhost:8080');

socket.onmessage = function(event) {
  $(".markdown-body").html(event.data)
};
