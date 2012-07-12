 var loadingHTML;

function showNote(rentalID)
  {

     $('#modal_showNote').html(loadingHTML)
     $('#modal_showNote').modal('show');
    
    $.ajax({
      type: 'GET',
      url: '/modal/note?rentalID='+rentalID,
      success: function(data){
        $('#modal_showNote').html(data);
       
      },
      dataType: 'HTML'
    });      
  
  }
  
function initShowNote()
{
     $('.showNote').unbind('click');
    $('.showNote').click(function()
    {
      showNote($(this).data('rentalid'));
    });
  }
$(document).ready(function() {

  loadingHTML = $('#modal_showProduct').html();
  initShowNote();
  
});