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
    $(".ws-combined-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        var id = $(this).data('id');
        $('.'+id).removeClass(['_srch-show']);
        $('.'+id).filter(function() {
            return $(this).text().toLowerCase().indexOf(value) > -1
        }).addClass(['_srch-show']);
        // glossary
        $('.ws-glossary-defn._srch-show').each(function() {
            $(this).nextUntil('.ws-glossary-defn').addClass(['_srch-show']);
        });
        $('.ws-glossary-file._srch-show').each(function() {
            $(this).nextUntil('.ws-glossary-file, .ws-glossary-defn').addClass(['_srch-show']);
        });
        $('.ws-glossary-place._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-glossary-file');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });
        $('.ws-glossary-file._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-glossary-file,.ws-glossary-defn');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });
        // toc
        $('.ws-toc-file._srch-show').each(function() {
            $(this).nextUntil('.ws-toc-file').addClass(['_srch-show']);
        });
        $('.ws-toc-head-1._srch-show').each(function() {
            $(this).nextUntil('.ws-toc-head-1, .ws-toc-file').addClass(['_srch-show']);
        });
        $('.ws-toc-head-2._srch-show').each(function() {
            $(this).nextUntil('.ws-toc-head-2, .ws-toc-head-1, .ws-toc-file').addClass(['_srch-show']);
        });
        $('.ws-toc-head-3._srch-show').each(function() {
            $(this).nextUntil('.ws-toc-head-3, .ws-toc-head-2, .ws-toc-head-1, .ws-toc-file').addClass(['_srch-show']);
        });
        $('.ws-toc-head-4._srch-show').each(function() {
            $(this).nextUntil('.ws-toc-head-4, .ws-toc-head-3, .ws-toc-head-2, .ws-toc-head-1, .ws-toc-file').addClass(['_srch-show']);
        });
        $('.ws-toc-head-4._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-toc-head-3');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });
        $('.ws-toc-head-3._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-toc-head-1');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });
        $('.ws-toc-head-2._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-toc-head-1');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });
        $('.ws-toc-head-1._srch-show').each(function(){
            var ups = $(this).prevUntil('.ws-toc-file');
            if (ups.length == 0) $(this).prev().addClass(['_srch-show']);
            else ups.last().prev().addClass(['_srch-show']);
        });

        $('.'+id).filter(function() {
            $(this).toggle($(this).hasClass(['_srch-show']) || $(this).hasClass(['no-search']))
        });
    });
});

