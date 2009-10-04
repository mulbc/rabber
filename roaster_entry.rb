class RoasterEntry < ActiveRecord::Base
  belongs_to :roaster_group
  
  attr_accessor :status
end