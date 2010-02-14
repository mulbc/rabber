class User < ActiveRecord::Base
  has_many :roster_groups
  has_many :roster_entries, :through => :roster_groups
  
  attr_accessor :status
  attr_accessor :status_id
  attr_accessor :server
  
  def jid
    "#{name}@#{@server.hostname}"
  end
end