require 'digest/md5'
class ChargifyController < ApplicationController
  	protect_from_forgery :except => :dispatch_handler
    before_filter :verify, :only => :dispatch_handler
 # EiQkSNDguhAmeOz-lLnF
  
  	def dispatch_handler
      event = params[:event]


      begin
        self.send event
      rescue Exception => e
        Rails.logger.debug e
        render :nothing => true, :status => 422 and return
      end
    end

    
  	def test
      Rails.logger.debug params.to_json
      render :nothing => true, :status => 200
    end
    
    def signup_success
      Rails.logger.debug params.to_json
      data = params[:payload]
      puts "IN SIGNUP_success"
      subscription = Subscription.new
      subscription.customer_id = checkCustomer data.subscription.customer
      subscription.location_id = newLocation data.subscription.customer subscription.customer_id
      subscription.subscriptionID = data.subscription.id
      subscription.recurringDate = data.subscription.customer.reference
      subscription.customerID = data.subscription.customer.id
      
      puts "SUB DATA: "
      puts subscription
      if(subscription.save)
        render :nothing => true, :status => 200
      else
        render :nothing => true, :status => 422
      end
      
    end
      
    
    
  
  	protected
    
    def newLocation customer, customer_id
      location = Location.new
      location.customer_id = customer_id
      location.address1 = customer.address
      location.address2 = customer.address_2
      location.city = customer.city

      location.country = customer.country
      location.first_name = customer.first_name
      location.last_name = customer.last_name
      location.phone = customer.phone
      location.province = customer.state
      location.zip = customer.zip
      location.name = "#{customer.first_name} #{customer.last_name}"      
      location.country_code = customer.country      
      location.province_code = customer.province      
      location.company = customer.organization      
      location.location_type = "recurring"      
      location.save
      
      puts "LOC DATA: "
      puts location
      
      location.id
    end
    
    def checkCustomer customerData
      customer = Customer.where('email = ?',  customerData.email).first
      if customer.blank?
         customer = Customer.new
      end

      customer.email = customerData.email
      customer.first_name = customerData.first_name
      customer.last_name = customerData.last_name
      customer.phone = customerData.phone
      customer.save
      
      puts "Customer DATA: "
      puts customer
      
      customer.id
    end
    
    
    def verify
      if params[:signature].nil?
        params[:signature] = request.headers["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE"]
      end
      
      
      unless Digest::MD5::hexdigest('EiQkSNDguhAmeOz-lLnF' + request.raw_post) == params[:signature]
        render :nothing => true, :status => :forbidden
      end
    end
    
  
end