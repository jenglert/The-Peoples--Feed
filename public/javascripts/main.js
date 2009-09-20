// Logic that needs to be performed when the page loads.
jQuery(document).ready(function() {
	jQuery(".tooltip").tooltip({showURL: false, fade: 250, track: true });
	
	// Ajax submit methods
	jQuery(".deleteComment").linkWithAjax();
});

// Ensure that jQuery sends all javascript files with a text/javascript header
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

// Hide the flash messages after 5 seconds
setTimeout("jQuery('.flashes').slideUp('slow')", 6000);


// jQuery function extension that will allow you to submit a form using ajax.
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    jQuery.post(this.action, jQuery(this).serialize(), null, "script");
    return false;
  })
  return this;
};

// jQuery function extension that will allow you to click a link with ajax.
jQuery.fn.linkWithAjax = function() {
	jQuery(this).click(function() {
		jQuery.get(jQuery(this).attr('href'), null, null, "script");
		return false;
	});
	return this;
};
