$(document).ready(function() {
  $('#rangeStart').datepicker({dateFormat: "yy-mm-dd"});
  $('#rangeEnd').datepicker({dateFormat: "yy-mm-dd"});
  $('#rangeStart_btn').click(function(){ $('#rangeStart').datepicker('show') });
  $('#rangeEnd_btn').click(function(){ $('#rangeEnd').datepicker('show') });
  
  $('#addDate').click(function(){ 
    var errorMSG = "";
     try {
      $.datepicker.parseDate('yy-mm-dd', $('#rangeStart').val());
      if($('#rangeEnd').val() != "")
        $.datepicker.parseDate('yy-mm-dd', $('#rangeEnd').val());
    } catch (e) {
        errorMSG += "Incorrect From or To Date<br>";
    };
    if($('#rangeStart').val() == "")
      errorMSG += "From date can't be blank"
    
    if(errorMSG != "")
    {
      showAlert(errorMSG);
    }
    else
    {
       $.ajax({
        type: 'POST',
        url: '/admin/unavailable',
        data: { rangeStart: $('#rangeStart').val(), rangeEnd: $('#rangeEnd').val(), reason: $('#awayReason').val()},
        success: function(data){
          if(data['status'] == 1)
            location.reload(true);
          else
            showAlert("Error: Please check your input and try again");
        },
        dataType: 'json'
      });    
    }
  });
  
  $('.deleteDate').click(function(){ 
    var awayRow = $(this).closest('tr');
    $.post('/admin/unavailable', { _method: 'delete', awayID: $(this).data('awayid') }, 
          function(data){ 
            if(data.status == 1){
              awayRow.fadeOut();
            }
            else
              showAlert('Error: Please try again');
          }, "json");
  });
          
 
          
});