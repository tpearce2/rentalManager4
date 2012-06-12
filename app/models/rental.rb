class Rental < ActiveRecord::Base
  attr_accessible :customerID, :deliveryDate, :orderID, :pickupDate, :productID
end
