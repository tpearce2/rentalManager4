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
        render :nothing => true, :status => 422 and return
      end
    end

    
  	def test
      Rails.logger.debug params.to_json
      render :nothing => true, :status => 200
    end
    
    def signup_success
       Rails.logger.debug params.to_json
      
      
      render :nothing => true, :status => 200
    end
      
    
    
  
  	protected
    def verify
      if params[:signature].nil?
        params[:signature] = request.headers["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE"]
      end
      
      
      unless Digest::MD5::hexdigest('EiQkSNDguhAmeOz-lLnF' + request.raw_post) == params[:signature]
        render :nothing => true, :status => :forbidden
      end
    end
    
  
end