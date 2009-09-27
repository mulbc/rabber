require "socket"
require "thread"
require "rexml/document"
require "base64"
require "builder"

class DebugIoWrapper < IO
  def initialize(target)
    @target = target
    @direction = nil
  end
  
  def read(length)
    data = @target.read length
    if @direction != :in
      @direction = :in
      $stdout.write "\n\nin   "
    end
    $stdout.write data
    data
  end
  
  def readline(del)
    data = @target.readline del
    if @direction != :in
      @direction = :in
      $stdout.write "\n\nin   "
    end
    $stdout.write data
    data
  end
  
  def eof?
    @target.eof?
  end
  
  def write(data)
    if @direction != :out
      @direction = :out
      $stdout.write "\n\nout  "
    end
    $stdout.write data
    @target.write data
  end
end

class Client
  def initialize(socket)
    @socket = socket
    @queue = Queue.new
    @next_element = nil
    @stream_id_counter = 0
    
    @user = nil
    
    @socket = DebugIoWrapper.new @socket
    @xml_output = Builder::XmlMarkup.new :target => @socket
    Thread.new {
      Thread.current.abort_on_exception = true
      REXML::Document.parse_stream @socket, self
    }
  end
  
  def xmldecl(version, encoding, standalone)
  end
  
  def tag_start(name, attrs)
    @queue.push [:tag_start, name, attrs]
  end
  
  def text(content)
    @queue.push [:text, content]
  end
  
  def tag_end(name)
    @queue.push [:tag_end, name]
  end
  
  def next_element
    @next_element ||= @queue.pop
  end
  
  def consume
    @next_element = nil
  end
  
  def expect_tag(expected_name = nil)
    start_type, start_name, attrs = next_element
    raise ArgumentError, "expected tag_start, got #{start_type} (#{start_name})" if start_type != :tag_start
    raise ArgumentError if expected_name and start_name != expected_name
    consume
    
    yield start_name, attrs if block_given?
    
    end_type, end_name = next_element
    raise ArgumentError if end_type != :tag_end
    raise ArgumentError if end_name != start_name
    consume
  end
  
  def expect_text
    type, content = next_element
    raise ArgumentError if type != :text
    consume
    content
  end
  
  def next_is_tag_end?
    next_element[0] == :tag_end
  end
  
  def run
    expect_tag "stream:stream" do
      handle_stream
    end
  end
  
  def handle_stream
    stream_id = @stream_id_counter
    @stream_id_counter += 1
    @xml_output.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
    @xml_output.stream :stream, "xmlns:stream" => "http://etherx.jabber.org/streams", "xmlns" => "jabber:client", "from" => "localhost", "id" => stream_id, "xml:lang" => "en", "version" => "1.0" do
      
      @xml_output.stream :features do
        if @user.nil?
          @xml_output.mechanisms "xmlns" => "urn:ietf:params:xml:ns:xmpp-sasl" do
            @xml_output.mechanism "PLAIN"
          end
          @xml_output.auth "xmlns" => "http://jabber.org/features/iq-auth"
        else
          @xml_output.bind "xmlns" => "urn:ietf:params:xml:ns:xmpp-bind"
          @xml_output.session "xmlns" => "urn:ietf:params:xml:ns:xmpp-session"
        end
      end
      
      loop do
        break if next_is_tag_end?
        
        expect_tag do |name, attrs|
          case name
          when "auth"
            raise ArgumentError if @user
            
            authzid, username, password = Base64.decode64(expect_text).split("\0")
            puts "", username, password
            @user = username
            
            @xml_output.success "xmlns" => "urn:ietf:params:xml:ns:xmpp-sasl"
          when "stream:stream"
            handle_stream
          else
            raise ArgumentError, name
          end
        end
      end
    end
  end
end

tcpserver = Socket.new Socket::AF_INET, Socket::SOCK_STREAM, 0
tcpserver.setsockopt Socket::SOL_SOCKET, Socket::SO_LINGER, [1, 0].pack("ii") # to avoid port block (TIME_WAIT state)
tcpserver.bind Socket.pack_sockaddr_in(5222, '')
tcpserver.listen 1024

socket = tcpserver.accept[0]

client = Client.new socket
client.run
