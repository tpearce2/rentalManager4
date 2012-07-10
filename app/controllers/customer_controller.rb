require 'digest/md5'
class CustomerController < ApplicationController
  
  
  def getSubscriptions
    if params[:email]
      subs = []
      customer = Customer.where('email = ?', params[:email]).first
      if customer.blank?
        render :json => { :error => "Invalid Email"}, :callback => params[:callback]
      else
        customer.subscriptions.each do |sub|
          curSub = {}
          
          subLocation = sub.location
          curSub[:details] = "#{subLocation.first_name} #{subLocation.last_name}<br>#{subLocation.address1}<br>#{subLocation.address2}<br>#{subLocation.zip}<br>#{subLocation.city}, #{subLocation.province}, #{subLocation.country}"
          curSub[:sID] = sub.subscriptionID
          subs << curSub
        end
        render :json => {:subs => subs}, :callback => params[:callback]
      end
    else
      render :json => { :error => "No Email Specified"}, :callback => params[:callback]
    end
    
  end
  
   
  def verifyCancelSubscription
    if params[:email] && params[:sID] 
      
      customer = Customer.where('email = ?', params[:email]).first 
      subscription = Subscription.where('subscriptionID = ?', params[:sID]).first 
      if(!customer.blank? && !subscription.blank?)
          customer.sendCancelEmail(subscription)
          render :json => { :status => 1}, :callback => params[:callback]
      else
        render :json => { :error => 'Invalid Email'}, :callback => params[:callback] 
      end
      
    else
      render :json => { :error => 'Missing Email'}, :callback => params[:callback]
    end
    
  end
  
  
  def cancelSubscription
    if params[:sID] && params[:hash]
      if Digest::MD5::hexdigest("#{HASH_SECRET}#{params[:sID]}") == params[:hash]
        subData = `curl -u d5FoR3cfJqKnY8hHJY4A:x -X DELETE https://shopify-just-play-toy-rental.chargify.com/subscriptions/#{params[:sID]}.json`
        if(subData.to_s.length > 1)
          render :json => {:status => 1}, :callback => params[:callback]
        else
          render :json => {:error => "Error Deleting Subscription"}, :callback => params[:callback]
        end
      else
        render :json => { :error => 'Invalid Hash'}, :callback => params[:callback]
      end
    else
      render :json => { :error => 'Missing Params'}, :callback => params[:callback]
    end
  end
  
  def test

  end
  
end