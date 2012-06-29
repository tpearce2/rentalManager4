class UserMailer < ActionMailer::Base
  default from: "tyler@stuffedmotion.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.pickup_reminder.subject
  #
  def pickup_reminder
    @greeting = "Hi"

    mail to: "gigabytestudio@gmail.com", subject: "test"
  end
end
