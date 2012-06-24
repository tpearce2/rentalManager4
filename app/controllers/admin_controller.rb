
class AdminController < ApplicationController
  around_filter :shopify_session
  
  def admin_rentals
    if not(params[:range_start] && params[:range_end])
      t = Date.today
      params[:range_start] = t
      params[:range_end] = t + 30
    end
    
    
    @rentals = Rental.where('(deliveryDate <= ? AND deliveryDate >= ?) OR (pickupDate <= ? AND pickupDate >= ?)', params[:range_end], params[:range_start], params[:range_end], params[:range_start])
    @customers = Array.new
    @locations = Array.new
    
    @dates = Date.all_days(Date.parse(params[:range_start]), Date.parse(params[:range_end]))
    @dates = @dates.select do |day|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 
        @day = day
        eventDays = @rentals.select {|rental| (rental.deliveryDate == @day || rental.pickupDate == @day) ? true : false }
        if eventDays.length > 0
          returnDay = true
        else
          returnDay = false
        end
        returnDay
    end
    
    
    @rentals.map{|t| t.customer_id}.uniq.each do |id|
      @customers[id] = Customer.find(id)
    end
    
    @rentals.map{|t| t.location_id}.uniq.each do |id|
      @locations[id] = Location.find(id)
    end
    
    @params = params
    params[:layout] ? (render "rentals_#{params[:layout]}") : (render :text => "Error: Layout not present")
 
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