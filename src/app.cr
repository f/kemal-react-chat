require "kemal"

messages = [] of String
sockets = [] of HTTP::WebSocket

public_folder "src/assets"

get "/" do
  render "src/views/index.ecr"
end

ws "/" do |socket|
  sockets.push socket

  # Handle incoming message and dispatch it to all connected clients
  socket.on_message do |message|
    messages.push message
    sockets.each do |a_socket|
      a_socket.send messages.to_json
    end
  end

  # Handle disconnection and clean sockets
  socket.on_close do |_|
    sockets.delete(socket)
    puts "Closing Socket: #{socket}"
  end
end

Kemal.run
