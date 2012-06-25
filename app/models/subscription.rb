class Subscription < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :customer
  belongs_to :location
end
