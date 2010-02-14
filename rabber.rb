require "socket"
require "thread"
require "rexml/document"
require "base64"
require "builder"
require "active_support/secure_random"
require "active_record"
require "csv"
require 'digest/md5'

ActiveRecord::Base # load here to avoid verbose warnings

#$VERBOSE = true
$WARNING = false

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
require "roster"
require "server"
require "client"
require "debug_io_wrapper"

ActiveRecord::Base.logger = Logger.new STDOUT
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => "rabber.sqlite3"

if $*.empty?
  Server.new.run
else
  case $*[0]
  when "user"
    case $*[1]
    when "add"
      User.create :name => $*[2], :password => $*[3]
      puts "User #{$*[2]} added."
    when "del"
      User.delete_all :name => $*[2]
      puts "User #{$*[2]} deleted"
    when "list"
      user = User.find(:all) 
      printf "%-20s %s\n", "Username", "| Password"
      user.each {|user| printf "%-20s %s\n", user.name, "| #{user.password}" }
    end
  end
end
