class Server
  attr_reader :hostname
  
  def initialize
    @hostname = "localhost"
  end
  
  def run
    tcpserver = Socket.new Socket::AF_INET, Socket::SOCK_STREAM, 0
    tcpserver.setsockopt Socket::SOL_SOCKET, Socket::SO_LINGER, [1, 0].pack("ii") # to avoid port block (TIME_WAIT state)
    tcpserver.bind Socket.pack_sockaddr_in(5222, '')
    tcpserver.listen 1024
    
    loop do
      socket = tcpserver.accept[0]
      socket = DebugIoWrapper.new socket
      client = Client.new socket
      Thread.new {
        begin
          client.run
        rescue Exception => e
          puts "", "#{e.class}: #{e.to_s}", e.backtrace
        end
      }
    end
  end
end