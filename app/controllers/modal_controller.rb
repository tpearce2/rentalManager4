
class ModalController < ApplicationController
  
   def rental
    if(params[:rentalID])
      @rentalID = params[:rentalID]
      
      render 'modal/rental', :layout => false
    else
      render :text => 'Error: No RentalID given'  
    end
  end
  
end
