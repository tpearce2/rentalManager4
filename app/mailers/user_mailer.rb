require 'digest/md5' 
class UserMailer < ActionMailer::Base
  default from: "info@justplaytoyrental.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.pickup_reminder.subject
  #
  def pickup_reminder(customer, products, pickupDate)
    @customer = customer
    @products = products
    @pickupDate = pickupDate
    
    mail to: @customer.email, subject: "Toy Rental Pickup Reminder"
  end
  
  def verify_cancel(email, sub)
    @subscription = sub
    @customer = sub.customer
    @location = sub.location
    @hash = Digest::MD5::hexdigest("#{HASH_SECRET}#{sub.subscriptionID}")
    
    mail to: email, subject: "Cancel Subscription - Just Play Toy Rental"
  end
  
end
