var scroll_enquiry_into_view = function() {
    var $target = jQuery('#wrapper');
    if ($target.length) {
        var targetOffset = $target.offset().top;
        $('html,body').animate({scrollTop: targetOffset}, 1000);
    }
};