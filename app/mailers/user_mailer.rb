class UserMailer < ActionMailer::Base
  default from: "tyler@stuffedmotion.ca"

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
end
