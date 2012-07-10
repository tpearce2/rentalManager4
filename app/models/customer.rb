class Customer < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :locations, :dependent => :destroy
  has_many :rentals, :dependent => :destroy
  has_many :subscriptions
  
 
  
  def self.send_reminders
    noticeDays = 3
    today = Date.today
    rentals = Rental.where('pickupDate = ?', today + noticeDays)
    
    if(rentals.length > 0)
      rentals.map{|t| t.customer_id}.uniq.each do |id|
        @customer = Customer.find(id)
        @products = []
        rentals.each {|rental| rental.customer_id == id ? @products << rental.product.title : false }
        
        UserMailer.pickup_reminder(@customer, @products, today + noticeDays).deliver
      end
    else
      puts "SendReminders: No rentals found"
    end
  end
  
  
  def sendCancelEmail sub
    UserMailer.verify_cancel(email, sub).deliver
  end 
  
  
end
