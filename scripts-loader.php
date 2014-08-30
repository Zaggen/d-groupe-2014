<!-- Minify all the app files, and use cdn for libs on production-->

<!-- Libs -->
<script src="<?php stylesheetUri(); ?>js/lib/underscore-min.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/jquery.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/backbone.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/drag-slider.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/handlebars-v1.3.0.js"></script>

<!-- App-->
<script src="<?php stylesheetUri(); ?>js/src/init.js"></script>
<!-- Models-->
<script src="<?php stylesheetUri(); ?>js/src/models/base-model.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/models/paginated-base-collection.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/models/news.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/models/single-entry.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/models/galleries.js"></script>
<!-- Views -->
<script src="<?php stylesheetUri(); ?>js/src/views/navigator.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/collection.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/base-content.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/layout.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/news.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/single-entry.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/pagination.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/loader.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/gallery.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/slim-gallery.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/contact.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/lightbox.js"></script>
<!-- Router -->
<script src="<?php stylesheetUri(); ?>js/src/routers/app.js"></script>

<script>
    $ = jQuery;
    !function(){
        if (matchMedia('only screen and (min-width: 850px)').matches) {
            $.getScript('http://platform.twitter.com/widgets.js');
        }
    }();

    // Ajax PreFilter, Used to filter each ajax json request for the backbone models
    $.ajaxPrefilter(function(options){
          options.url = Dgroupe.helpers.rootUrl + options.url
    });
</script>
