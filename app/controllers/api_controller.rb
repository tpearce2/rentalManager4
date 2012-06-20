
class ApiController < ApplicationController
   around_filter :shopify_session
  
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
  
  
 
end
