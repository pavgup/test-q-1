class LineItem < ActiveRecord::Base
  validates :quantity, :numericality => { :only_integer => true,
                                          :greater_than => 0}
  belongs_to :order
  belongs_to :product
  attr_accessible :quantity, :product_id, :order_id

end
