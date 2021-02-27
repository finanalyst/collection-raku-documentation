// algorithm: remove class _srch-show from all divs within a container, excluding some, make all visible
// using filter assign _srch-show to all divs that match the search criterion
// traverse backwards so that left-ward siblings of divs with _srch-show are also _srch-show
// filter for _srch-show and hide divs without.
// Data is arranged <div .class1 ><div .class2 >...<div .classN>
$(document).ready(function(){
    var selector = '.ws-glossary-defn:not(.header), .ws-glossary-file:not(.header), .ws-glossary-place:not(.header), .ws-glossary-place:not(.header) *';
    var bubble = ['.ws-glossary-place:not(.header)', '.ws-glossary-file:not(.header)', '.ws-glossary-defn:not(.header)'];
    $(".ws-glossary-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        var id = $(this).attribute['data-id'].value;
        $(selector).hasClass(id).removeClass(['_srch-show']);
        $(selector).hasClass(id).filter(function() {
            return $(this).text().toLowerCase().indexOf(value) > -1
        }).addClass(['_srch-show']);
        bubble.forEach(function(sel) {
            $(sel).filter(function() {
                if ($(this).has('a._srch-show')) { $(this).addClass(['_srch-show']) };
                return $(this).hasClass('_srch-show')
            }).prev().addClass(['_srch-show'])
        });
        $(selector).hasClass(id).filter(function() {
            $(this).toggle($(this).hasClass(['_srch-show']))
        });
    });
});