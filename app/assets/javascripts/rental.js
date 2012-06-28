$(document).ready(function() {
	
		var date = new Date();
		var d = date.getDate();
		var m = date.getMonth();
		var y = date.getFullYear();

		$('#calendar').fullCalendar({
			theme: true,
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			editable: false,
      eventRender: function(event, element) {
        if(element.hasClass('t_delivery'))
        {
          element.children('div').prepend('<i class="icon-chevron-down"></i>');
        }
        if(element.hasClass('t_pickup'))
        {
          element.children('div').prepend('<i class="icon-chevron-up"></i>');
        }
        if(element.hasClass('t_recurring'))
        {
          element.children('div').prepend('<i class="icon-refresh"></i>');
        }
        
    },
     eventSources: [

        // your event source
        {
            url: '/webhooks/rental_json',
            type: 'GET',
            data: {
                custom_param1: 'something',
                custom_param2: 'somethingelse'
            },
            error: function() {
                alert('there was an error while fetching events!');
            },
            color: 'yellow',   // a non-ajax option
            textColor: 'black' // a non-ajax option
        }

        // any other sources...

    ],
    dayClick: function(date, allDay, jsEvent, view) {
      window.location = "/admin/rentals/?range_start=" + $.datepicker.formatDate('yy-mm-dd',date) + "&range_end=" + $.datepicker.formatDate('yy-mm-dd',date) + "&layout=date";
    }
			
		});
		
	});