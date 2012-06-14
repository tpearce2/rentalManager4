class Rental < ActiveRecord::Base
  #attr_accessible :customerID, :deliveryDate, :orderID, :pickupDate, :productID
  validates_inclusion_of :type, :in => %w(single recurring)
  belongs_to :customer
  belongs_to :location
  belongs_to :product
end
