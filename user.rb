class User < ActiveRecord::Base
  has_many :roaster_groups
  has_many :roaster_entries, :through => :roaster_group
end