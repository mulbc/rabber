class DebugIoWrapper < IO
  def initialize(target)
    @target = target
    @direction = nil
    @mutex = Mutex.new
  end
  
  def read(length)
    data = @target.read length
    @mutex.synchronize do
      if @direction != :in
        @direction = :in
        $stdout.write "\n\nin   "
      end
    end
    $stdout.write data
    data
  end
  
  def readline(del)
    data = @target.readline del
    @mutex.synchronize do
      if @direction != :in
        @direction = :in
        $stdout.write "\n\nin   "
      end
      $stdout.write data
    end
    data
  end
  
  def eof?
    @target.eof?
  end
  
  def write(data)
    @mutex.synchronize do
      if @direction != :out
        @direction = :out
        $stdout.write "\n\nout  "
      end
      $stdout.write data
    end
    @target.write data
  end
end