
class ModalController < ApplicationController
  
   def rental
    if(params[:rentalID])
      @rentalID = params[:rentalID]
      
      if(params[:action])
        @action = params[:action1]
      end
      render 'modal/rental', :layout => false
    else
      render :text => 'Error: No RentalID given'  
    end
  end
  
  def product
    if(params[:productID])
      @productID = params[:productID]
      
      if(params[:action])
        @action = params[:action1]
      end
      render 'modal/product', :layout => false
    else
      render :text => 'Error: No ProductID given'  
    end
  end
  
end
