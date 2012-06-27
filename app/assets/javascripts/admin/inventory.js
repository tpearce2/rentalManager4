 
function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}
$(document).ready(function() {
  
  $('.updateQuantity').click(function(){ 
    var quantErrorMSG = "";
    var quantity = $(this).prev('input').val();
    var updateBtn = $(this);
    var productID = $(this).data('productid');
    $(updateBtn).removeClass('btn-success').html('Update');
    
    if(isNumber(quantity) == false)
      quantErrorMSG += "Invalid Number<br>"
    if(quantity == "")
      quantErrorMSG += "Quantity can't be Blank<br>"
    if(quantity == "0")
      quantErrorMSG += "Quantity can't be 0<br>"
    
    if(quantErrorMSG != "")
    {
      showAlert(quantErrorMSG);
    }
    else
    {
       $.ajax({
        type: 'POST',
        url: '/admin/inventory',
        data: { product_id: productID, quantity: quantity},
        success: function(data){
          if(data['status'] == 1)
            $(updateBtn).addClass('btn-success').html('Updated').prepend('<i class="icon icon-ok icon-white"></i>');
          else
            showAlert("Error: Please check your input and try again");
        },
        dataType: 'json'
      });    
    }
  });
          
 
          
});