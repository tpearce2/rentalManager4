function resetProductArea()
{
    $('.selectedElement').fadeOut();
    $('#selectedToyCont').html("");
    $('#productWell').html("Please Select a Date Range");
}

function initRemoveProduct()
    {
      $('.removeProduct').unbind('click');
      
      $('.removeProduct').click(function(e){
         e.stopPropagation();
        $('#productWell .product-' + $(this).closest('.listProduct').data('productid') + ' .addedProduct').removeClass('addedProduct btn-primary').addClass('addProduct').unbind('click').html('Add');
        $(this).closest('.listProduct').remove();
        initShowProduct();
        initAddProduct();
        
        if($('#selectedToyCont').html() == "")
        {
          $('.selectedElement').fadeOut();
        }
      });
    }
    
    function initAddProduct()
    {
      $('.addProduct').unbind('click');
      $('.addProduct').click(function(e){
         e.stopPropagation();
        var product = $(this).closest('.listProduct');
        
        if($('#selectedToyCont').html() == "")
        {
           $('#selectedToyCont').append($(product).outerHTML());  
          $('.selectedElement').fadeIn();
        }
        else
        {
          $('#selectedToyCont').append($(product).outerHTML());  
        }
       
        
        
        $('#selectedToyCont .product-' + $(product).data('productid') + ' .addProduct').removeClass('addProduct').addClass('removeProduct btn-danger').html('Remove');
        $(this).removeClass('addProduct').addClass('addedProduct btn-primary').html('Added').unbind('click'); 
        
        $('.addedProduct').unbind('click');
        $('.addedProduct').click(function(e){
          e.stopPropagation();
          showAlert('That Item has already been added');
        });
        
        initRemoveProduct();
        initShowProduct();
      });
    }
    

    
    $(document).ready(function() {
      
      if($('.customerLocation').length == 1)
        $('.customerLocation a').addClass('selected btn-primary').html(" Selected").prepend('<i class="icon icon-ok icon-white"></i>');
        
      $('#submitRental').click(function(){  
        var errorMSG = "";
        if($('.customerLocation .selected').length == 0)
          errorMSG += "No Delivery Location Specified<br>";
        try {
            $.datepicker.parseDate('yy-mm-dd', $('#rangeStart').val());
            $.datepicker.parseDate('yy-mm-dd', $('#rangeEnd').val());
          } catch (e) {
              errorMSG += "Incorrect Delivery or Pickup Date<br>";
          };
        if($('#selectedToyCont .listProduct').length == 0)
          errorMSG += "No Toys have been Selected<br>";
        
        if(errorMSG != "")
          showAlert(errorMSG);
        else
        {
          var locationID = $('.customerLocation .selected').closest('.customerLocation').data('locationid');
          var rentals = [];
          $('#selectedToyCont .listProduct').each(function(index) {
            rentals.push($(this).data('productid'));
          });
          
          $.ajax({
            type: 'POST',
            url: '/admin/addRentals',
            data: { customer_id: customerID, location_id: locationID, deliveryDate: $('#rangeStart').val(), pickupDate: $('#rangeEnd').val(), rental_type: layoutType, 'rentals': rentals },
            success: function(data){
              if(data['status'] == 1)
              {
                if(layoutType == "single")
                  window.location = "/admin/customers/?flash=1"
                else
                  window.location = "/admin/subscriptions/?flash=1"
              } 
              else
                alert("failed")
                
              
              
            },
            dataType: 'json'
          });    
          
          
        }
      });
      
      $('.customerLocation a').click(function(){
        $('.customerLocation a').removeClass('selected btn-primary').html('Select');
        $('.customerLocation a i').remove();
        $(this).addClass('selected btn-primary').html(" Selected").prepend('<i class="icon icon-ok icon-white"></i>');
      });
      
      var loadingHTML = '<%= escape_javascript(render("modal/modal_loading")) %>';

      $('#rangeStart').datepicker({dateFormat: "yy-mm-dd", onSelect: resetProductArea});
      $('#rangeEnd').datepicker({dateFormat: "yy-mm-dd", onSelect: resetProductArea});

      $('#rangeStart_btn').click(function(){ $('#rangeStart').datepicker('show') });
      $('#rangeEnd_btn').click(function(){ $('#rangeEnd').datepicker('show') });
    
      $('#rangeRefresh').click(function(){ 
        if($('#rangeStart').val() == "" || $('#rangeEnd').val() == "")
        {
          showAlert("Please pick a Delivery and Pickup time first");
        }
        else{
         $.ajax({
          type: 'POST',
          url: '/admin/findProducts',
          data: {startTime: $('#rangeStart').val(), endTime: $('#rangeEnd').val()},
          success: function(data){
            $('#productWell').html(data + '<div style="clear:both;"></div>');
            initAddProduct();
            initShowProduct();
            
            
          },
          dataType: 'html'
        });    
      }
        
        
      });
    
    });