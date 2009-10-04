class RoasterGroup < ActiveRecord::Base
  belongs_to :user
  has_many :roaster_entries
end

class RoasterEntry < ActiveRecord::Base
  belongs_to :roaster_group
  
  attr_accessor :status
  
  SUBSCRIPTION_TO = 1
  SUBSCRIPTION_FROM = 2
  SUBSCRIPTION_BOTH = SUBSCRIPTION_TO | SUBSCRIPTION_FROM
  
  def subscription_to?
    subscription & SUBSCRIPTION_TO != 0
  end

  def subscription_from?
    subscription & SUBSCRIPTION_FROM != 0
  end
end