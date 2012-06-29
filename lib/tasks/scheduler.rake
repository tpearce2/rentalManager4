desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
    puts "Sending Customer Reminders"
     Customer.send_reminders
    puts "Ending "
end