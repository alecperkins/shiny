$('.BlockSource, .ExampleSource, .ExampleRendered').each(function(i, el) {
    var $block = $(el);
    var $toggler = $('<button class="BlockToggler">hide</button>');
    $block.prev().append($toggler);
    $toggler.on('click',function(){
        if($block.attr('data-collapsed')) {
            $block.removeAttr('data-collapsed');
            $toggler.text('hide');
        } else {
            $block.attr('data-collapsed', true);
            $toggler.text('show');
        }
    });
    if(!$block.hasClass('ExampleRendered')) {
        $toggler.trigger('click');
    }
});