class User < ActiveRecord::Base
  has_many :roster_groups
  has_many :roster_entries, :through => :roster_groups
  
  attr_accessor :server
  
  def jid
    "#{name}@#{@server.hostname}"
  end
end