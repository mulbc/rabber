class RosterGroup < ActiveRecord::Base
  belongs_to :user
  has_many :roster_entries
end

class RosterEntry < ActiveRecord::Base
  belongs_to :roster_group
  
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