class Order < ActiveRecord::Base
  
  before_create :set_initial_status

  has_many :line_item, :dependent => :destroy 
  belongs_to :user
  attr_accessible :date, :user_id, :status

  def set_initial_status
    self.status = "DRAFT"
  end

end
