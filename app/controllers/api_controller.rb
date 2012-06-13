
class ApiController < ApplicationController
  # around_filter :shopify_session, :except => 'welcome'
  
  def rentals_json
    @params = params
    
    if not @params[:start] && @params[:end]
       render :text=>"Error: Missing Start/End Time for Calendar"
    else
      startTime = Time.new
      startTime = Time.at(@params[:start].to_i).strftime("%Y-%m-%d")
      
      endTime = Time.new
      endTime = Time.at(@params[:end].to_i).strftime("%Y-%m-%d")
      @rentals = Rental.find(:all)
     # render :text=>startTime
      testarray = Array.new
      testarray << {:id => 1, :title => "hello", :start => startTime}
     testarray << {:id => 1, :title => "hello", :start => endTime}
    
    
      render :json => testarray.to_json
      

    end
  end
end
