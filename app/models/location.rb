class Location < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :rentals
  belongs_to :customer
end
 