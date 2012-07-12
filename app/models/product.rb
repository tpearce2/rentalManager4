class Product < ActiveRecord::Base
  #attr_accessible :productDescription, :productHandle, :productID, :productImage, :productPrice, :productQuantity, :productSku, :productTags, :productTitle
  has_many :rentals, :dependent => :destroy
end
