class Rental < ActiveRecord::Base
  attr_accessible :customerID, :deliveryDate, :orderID, :pickupDate, :productID
  validates_inclusion_of :type, :in => %w(single recurring)
end
