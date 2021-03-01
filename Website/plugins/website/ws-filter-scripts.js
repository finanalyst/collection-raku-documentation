// algorithm: remove class _srch-show from all divs within a container, excluding some, make all visible
// using filter assign _srch-show to all divs that match the search criterion
// traverse backwards so that left-ward siblings of divs with _srch-show are also _srch-show
// filter for _srch-show and hide divs without.
// Data is arranged <div .class1 ><div .class2 >...<div .classN>
$(document).ready(function(){
    var g_selector = '.ws-glossary-defn:not(.header), .ws-glossary-file:not(.header), .ws-glossary-place:not(.header), .ws-glossary-place:not(.header) *';
    var g_bubble = ['.ws-glossary-place:not(.header)', '.ws-glossary-file:not(.header)'];
    $(".ws-glossary-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        var id = $(this).data('id');
        $(g_selector).filter(function(){ return $(this).hasClass(id)}).removeClass(['_srch-show']);
        $(g_selector).filter(function() {
            return $(this).hasClass(id) && $(this).text().toLowerCase().indexOf(value) > -1
        }).addClass(['_srch-show']);
        g_bubble.forEach(function(sel) {
            $(sel).filter(function() {
                if ($(this).has('a._srch-show').length > 0 ) { $(this).addClass(['_srch-show']) };
                return $(this).hasClass('_srch-show')
            }).prev().addClass(['_srch-show'])
        });
        $(g_selector).filter(function() {
            $(this).toggle($(this).hasClass(['_srch-show']) || $(this).hasClass(['no-search']))
        });
    });
    var toc_selector = '.ws-toc-head-1, .ws-toc-head-2, .ws-toc-head-3, .ws-toc-head-4 *';
    var toc_bubble = ['.ws-toc-headers'];
    var toc_show = '.ws-toc-file, .ws-toc-headers, .ws-toc-headers, .ws-toc-head-1, .ws-toc-head-2, .ws-toc-head-3, .ws-toc-head-4 *';
    $(".ws-toc-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        var id = $(this).data('id');
        $(toc_show).filter(function(){ return $(this).hasClass(id)}).removeClass(['_srch-show']);
        $(toc_selector).filter(function() {
            return $(this).hasClass(id) && $(this).text().toLowerCase().indexOf(value) > -1
        }).addClass(['_srch-show']);
        toc_bubble.forEach(function(sel) {
            $(sel).filter(function() {
                if ($(this).has('*._srch-show').length > 0 ) { $(this).addClass(['_srch-show']) };
                return $(this).hasClass('_srch-show')
            }).prev().addClass(['_srch-show'])
        });
        $(toc_show).filter(function() {
            $(this).toggle($(this).hasClass(['_srch-show']) || $(this).hasClass(['no-search']))
        });
    });
    var comb_selector = '.ws-toc-head-1, .ws-toc-head-2, .ws-toc-head-3, .ws-toc-head-4 *, ';
    comb_selector = comb_selector + '.ws-glossary-defn:not(.header), .ws-glossary-file:not(.header), .ws-glossary-place:not(.header), .ws-glossary-place:not(.header) *';
    var comb_bubble = ['.ws-toc-headers','.ws-glossary-place:not(.header)', '.ws-glossary-file:not(.header)'];
    var comb_show = '.ws-toc-file, .ws-toc-headers, .ws-toc-headers, .ws-toc-head-1, .ws-toc-head-2, .ws-toc-head-3, .ws-toc-head-4 *,';
    comb_show = comb_show + '.ws-glossary-defn:not(.header), .ws-glossary-file:not(.header), .ws-glossary-place:not(.header), .ws-glossary-place:not(.header) *';
    $(".ws-combined-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        var id = $(this).data('id');
        $(comb_show).filter(function(){ return $(this).hasClass(id)}).removeClass(['_srch-show']);
        $(comb_selector).filter(function() {
            return $(this).hasClass(id) && $(this).text().toLowerCase().indexOf(value) > -1
        }).addClass(['_srch-show']);
        comb_bubble.forEach(function(sel) {
            $(sel).filter(function() {
                if ($(this).has('*._srch-show').length > 0 ) { $(this).addClass(['_srch-show']) };
                return $(this).hasClass('_srch-show')
            }).prev().addClass(['_srch-show'])
        });
        $(comb_show).filter(function() {
            $(this).toggle($(this).hasClass(['_srch-show']) || $(this).hasClass(['no-search']))
        });
    });
});

