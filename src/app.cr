require "kemal"

messages = [] of String
sockets = [] of HTTP::WebSocket

public_folder "src/assets"

get "/" do
  render "src/views/index.ecr"
end

ws "/" do |socket|
  sockets.push socket
  socket.on_message do |message|
    messages.push message
    sockets.each do |a_socket|
      a_socket.send messages.to_json
    end
  end
end

Kemal.run
