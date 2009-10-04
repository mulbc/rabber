class RoasterGroup < ActiveRecord::Base
  belongs_to :user
  has_many :roaster_entries
end