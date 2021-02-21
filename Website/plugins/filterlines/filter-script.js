$(document).ready(function(){
  $("#RakuSearchLine").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#RakuSearchContent *").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
