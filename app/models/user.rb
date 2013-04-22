class User < ActiveRecord::Base
  has_many :product
  has_many :order
  attr_accessible :name
end
