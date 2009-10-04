require "socket"
require "thread"
require "rexml/document"
require "base64"
require "builder"
require "active_support/secure_random"
require "activerecord"
require "csv"

ActiveRecord::Base # load here to avoid verbose warnings

$VERBOSE = true

module Kernel
  def quiet
    verbose = $VERBOSE
    $VERBOSE = false
    yield
    $VERBOSE = verbose
  end
end

require "errors"
require "user"
require "roaster"
require "client"
require "debug_io_wrapper"

ActiveRecord::Base.logger = Logger.new STDOUT
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "rabber.sqlite3"

if $*.empty?
  tcpserver = Socket.new Socket::AF_INET, Socket::SOCK_STREAM, 0
  tcpserver.setsockopt Socket::SOL_SOCKET, Socket::SO_LINGER, [1, 0].pack("ii") # to avoid port block (TIME_WAIT state)
  tcpserver.bind Socket.pack_sockaddr_in(5222, '')
  tcpserver.listen 1024
  
  socket = tcpserver.accept[0]
  socket = DebugIoWrapper.new socket
  
  client = Client.new socket
  client.run
else
  case $*[0]
  when "user"
    case $*[1]
    when "add"
      User.create :name => $*[2], :password => $*[3]
      puts "User added."
    end
  end
end
