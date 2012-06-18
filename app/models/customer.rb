class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :locations, :dependent => :destroy
  has_many :rentals, :dependent => :destroy
end
