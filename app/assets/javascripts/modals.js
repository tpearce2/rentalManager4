var dayInfo = [];
var tester;
$(document).ready(function() {

  
  var editRentalBody = $('#modal_editRental').html();
  $('.editRental').click(function()
  {
    $('#modal_editRental').html(editRentalBody)
    $('#modal_editRental').modal('show');
    var rentalID = $(this).data('rentalid');
    $.ajax({
      type: 'GET',
      url: '/modal/rental?rentalID='+rentalID+'&action1=edit',
      success: function(data){
        $('#modal_editRental').html(data);

        $('#editRental_start').data('rentalID', rentalID);
        $('#editRental_start').datepicker({onChangeMonthYear: reloadDays, beforeShow: getDays, beforeShowDay: unavailable, defaultDate:$('#editRental_start').val(), dateFormat: "yy-mm-dd"});

        $('#editRental_end').data('rentalID', rentalID);      
        $('#editRental_end').datepicker({onChangeMonthYear: reloadDays, beforeShow: getDays, beforeShowDay: unavailable, defaultDate:$('#editRental_end').val(), dateFormat: "yy-mm-dd"});
        
        $('#editRental_start_btn').click(function(){ $('#editRental_start').datepicker('show') });
        $('#editRental_end_btn').click(function(){ $('#editRental_end').datepicker('show') });
        
        $('#editRental_save_btn').click(function(){ update_rental(rentalID, $('#editRental_start').val(), $('#editRental_end').val()) });
      },
      dataType: 'HTML'
    });    
  });
    $('.deleteRental').click(function()
    {
      $('#modal_deleteRental').html("");
      $('#modal_deleteRental').modal('show');
      var rentalID = $(this).data('rentalid');
      var curElement = $(this);
      $.ajax({
        type: 'GET',
        url: '/modal/rental?rentalID='+rentalID+'&action1=delete',
        success: function(data){
          $('#modal_deleteRental').html(data);
  
          $('#deleteRental_btn').click(
            function(){ 
              $.post('/api/rental', { _method: 'delete', rentalID: rentalID }, 
              function(data){ 
                if(data.status == 1){
                  $('#modal_deleteRental').modal('hide');
                  $(curElement).closest('tr').fadeOut('slow');
                }
                else
                  alert(status);
              }, "json") 
            }
          );
        },
        dataType: 'HTML'
      });    
    
  });
});

  function update_rental(rentalID, deliveryDate, pickupDate)
  {
    $.ajax({
      type: 'POST',
      url: '/api/rental',
      data: {rentalID: rentalID, deliveryDate: deliveryDate, pickupDate: pickupDate},
      success: function(data){
        if(data.status != 1)
          alert(data.status);
        else{
          $('#modal_editRental').modal('hide');
          
        }
      },
      dataType: 'json'
    });    
  }
  
  function reloadDays(year, month, inst)
  {
    if(month)
    getDays($(this), inst, year, month);
  }
  function getDays(input, inst, year, month)
  {
    var iDate = $(input).datepicker('getDate');
    iDate = $.datepicker.formatDate('yy-mm-dd', iDate);
    if(year != null && month != null)
    {
      nDate = new Date(year, month-1, 1);
      iDate = $.datepicker.formatDate('yy-mm-dd', nDate);
    }
  
      rentalID = $(input).data('rentalID');
     $.ajax({
      type: 'GET',
      url: '/api/calendar/admin',
      async: false,
      data: {date: iDate, rentalID: rentalID},
      success: function(data){
        dayInfo = data;
      },
      dataType: 'json'
    });    
  }
  
  function unavailable(date){
    var formatDate = $.datepicker.formatDate('yy-mm-dd', date);
     if($.inArray(formatDate, dayInfo.booked_less_range) != -1)
    {
      return [true, "toy_booked", "Toy Booked"];
    }
    return [true, "enabled", "Available"];
  }

