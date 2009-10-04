class User < ActiveRecord::Base
  has_many :roster_groups
  has_many :roster_entries, :through => :roster_group
end