$(document).ready(function() {


  var editRentalBody = $('#modal_editRental').html();
  $('.editRental').click(function()
  {
    $('#modal_editRental').html(editRentalBody)
    $('#modal_editRental').modal('show');
    var rentalID = $(this).data('rentalid');
    $.ajax({
      type: 'GET',
      url: '/modal/rental?rentalID='+rentalID,
      success: function(data){
        $('#modal_editRental').html(data);

        $('#editRental_start').data('rentalID', rentalID);
        $('#editRental_start').datepicker({beforeShow: getDays, beforeShowDay: unavailable, dateFormat: "yy-mm-dd"});
        $('#editRental_start').datepicker('setDate', $('#editRental_start').val());

        $('#editRental_end').data('rentalID', rentalID);      
        $('#editRental_end').datepicker({beforeShow: getDays, beforeShowDay: unavailable, dateFormat: "yy-mm-dd"});
        $('#editRental_end').datepicker('setDate', $('#editRental_end').val());



      },
      dataType: 'HTML'
    });    
  })
});

function getDays(input, inst)
{
rentalID = $(input).data('rentalID');
   $.ajax({
    type: 'GET',
    url: '/api/calendar/admin',
    data: {date: $(input).val(), rentalID: rentalID},
    success: function(data){
      
  
  
  
    },
    dataType: 'HTML'
  });    
}

function unavailable(date)
{

       
  console.log('test');
return [true, "enabled", "Book Now"];
}