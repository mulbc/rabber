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