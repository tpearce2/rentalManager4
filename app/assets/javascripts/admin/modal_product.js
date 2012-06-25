$(document).ready(function() {

  
  var editProductBody = $('#modal_showProduct').html();
  $('.showProduct').click(function()
  {
    $('#modal_showProduct').html(editProductBody)
    $('#modal_showProduct').modal('show');
    var productID = $(this).data('productid');
    $.ajax({
      type: 'GET',
      url: '/modal/product?productID='+productID+'&action1=show',
      success: function(data){
        $('#modal_showProduct').html(data);
      },
      dataType: 'HTML'
    });    
  });
});