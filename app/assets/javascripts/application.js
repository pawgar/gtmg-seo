// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require xepOnline.jqPlugin
// require turbolinks
//= require_tree .



// To make Pace works on Ajax calls
/*global $*/
$(document).ajaxStart(function() {
    Pace.restart();
});



/*global $*/
setTimeout(function() {
    $("#notice_wrapper, #error_wrapper").fadeOut('slow').empty();
}, 5000);


$(document).ajaxError(function(event,xhr,options,exc) {
    
    var errors = JSON.parse(xhr.responseText);
    var er ="<div class='box-body'>";
    for(var i = 0; i < errors.length; i++){
        var list = errors[i];
        er += "<small> <i class='fa fa-times-circle-o margin-r-5'> </i>"+list+"</small><br/>"
    }
    er+="</div>"
    $("#error_explanation").html(er);
       
});