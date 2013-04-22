class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :line_item
  attr_accessible :name, :price, :user_id
end
