class Server
  attr_reader :hostname
  
  def initialize
    @hostname = "localhost"
    @clients = []
  end
  
  def find_client(user)
    @clients.find { |client| client.user == user }
  end
  
  def run
    tcpserver = Socket.new Socket::AF_INET, Socket::SOCK_STREAM, 0
    tcpserver.setsockopt Socket::SOL_SOCKET, Socket::SO_LINGER, [1, 0].pack("ii") # to avoid port block (TIME_WAIT state)
    tcpserver.bind Socket.pack_sockaddr_in(5223, '')
    tcpserver.listen 1024
    
    loop do
      socket = tcpserver.accept[0]
      socket.set_encoding "UTF-8"
      socket = DebugIoWrapper.new socket
      client = Client.new self, socket
      @clients << client
      Thread.new {
        begin
          client.run
        rescue Exception => e
          puts "", "#{e.class}: #{e.to_s}", e.backtrace
        end
        @clients.delete client
      }
    end
  end
end