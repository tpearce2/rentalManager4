class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :locations, :dependant => :destroy
  has_many :rentals, :dependant => :destroy
end
