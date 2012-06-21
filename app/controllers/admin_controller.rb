
class AdminController < ApplicationController
  
  def admin_rentals
    if not(params[:range_start] && params[:range_end])
      t = Date.today
      params[:range_start] = t
      params[:range_end] = t + 30
    end
    
    @dates = Date.all_days(params[:range_start], params[:range_end])
    @rentals = Rental.where('(deliveryDate <= ? AND deliveryDate >= ?) OR (pickupDate <= ? AND pickupDate >= ?)', params[:range_end], params[:range_start], params[:range_end], params[:range_start])
    @customers = Array.new
    @locations = Array.new
    
    @rentals.map{|t| t.customer_id}.uniq.each do |id|
      @customers << Customer.find(id)
    end
    
    @rentals.map{|t| t.location_id}.uniq.each do |id|
      @locations << Location.find(id)
    end
    
    
  end
  
end

class Date
  def self.all_days from, to
      m = Date.new from.year, from.month, from.day
      result = []
      while m <= to
        result << m
        m += 1
      end
  
      result
    end
  end