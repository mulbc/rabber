class RoasterGroup < ActiveRecord::Base
  belongs_to :user
  has_many :roaster_entries
end

class RoasterEntry < ActiveRecord::Base
  belongs_to :roaster_group
  
  attr_accessor :status
end