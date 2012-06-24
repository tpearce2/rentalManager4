
class ApiController < ApplicationController
   # around_filter :shopify_session
  
  def update_quantity
    product = ShopifyAPI::Product.find(params['product_id'])
    # product
  end
  
  def get_quantity
     products = ShopifyAPI::Product.find(94091072)
    render :text => products.title
     # product = ShopifyAPI::Product.find(:one, :params => { :title => 'Cup'})
    
      
    # render :text => product.variants[0].inventory_quantity
    # render :json => product.inspect
  end
  
  
  def calendar_days_admin
    
    cDate = params[:date]
    rentalID = params[:rentalID]
    
    rDate = Date.parse(cDate)
    
    startTime = Date.new rDate.year, rDate.month
    endTime = Date.new rDate.year, rDate.month, -1

    rental = Rental.find(rentalID)
    
    rProduct = Product.where('id = ?', rental['product_id']).first
    @quantity = rProduct['quantity']
    @rentals = Rental.where('pickupDate >= ? AND deliveryDate <= ? AND product_id = ?', startTime, endTime, rProduct['id'].to_i)
    
    @rangeDays = Date.all_days(startTime, endTime)

    # Check known booked days from other rentals first   
    bookedDays = @rangeDays.select do |day|
      returnDay = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     # 
      @day = day
      bookedRentals = @rentals.select {|rental| (rental.deliveryDate <= @day && rental.pickupDate >= @day) ? true : false }

      if bookedRentals.length >= @quantity
        returnDay = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         # 
      else
        returnDay = false
      end
      returnDay
    end
    
    rentalRange = Date.all_days(rental['deliveryDate'], rental['pickupDate'])
    bookedDaysLess = bookedDays - rentalRange
    
    # Do Manual Unavailable days 

    unavailables = Unavailable.where('awayDate >= ? AND awayDate <= ?', startTime, endTime)    
    manualDays = unavailables.map{|t| t.awayDate}.uniq
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            # 
    
    
    returnData = {:booked => bookedDays, :booked_less_range => bookedDaysLess, :manual => manualDays}
    
    render :json => returnData.to_json
    
  end
  
  def update_rental
    returnData = {:status => 'Error saving, please try again'}
    
    if(params[:rentalID] && params[:deliveryDate] && params[:pickupDate])
      begin
        rDate = Date.parse(params[:deliveryDate])
        dDate = Date.parse(params[:pickupDate])
        
        rental = Rental.find(params[:rentalID])
        rental.deliveryDate = params[:deliveryDate]
        rental.pickupDate = params[:pickupDate]
        if (rental.save)
          returnData = {:status => 1}
        end
      rescue ArgumentError => e
        returnData = {:status => e.message}
      end
      
      
    end
    
    render :json => returnData.to_json
    
  end
  
  def delete_rental
    returnData = {:status => 'Error deleting, please try again'}
    if(params[:rentalID])
      rental = Rental.find(params[:rentalID])
      if(rental.destroy)
        returnData = {:status => 1}
      end
    end
    render :json => returnData.to_json
    
  end
  
  
end
