<footer class="BrandsFooter">
    <div class="container">
        <figure class="partnersLogos kukaramakaraLogo"></figure>
        <figure class="partnersLogos lussacLogo"></figure>
        <figure class="partnersLogos sixxtinaLogo"></figure>
        <figure class="partnersLogos delaireLogo"></figure>
    </div>
</footer>
</body>
<?php wp_footer() ?>
<!-- Minify all the app files, and use cdn for libs on production-->

<!-- Libs -->
<script src="<?php stylesheetUri(); ?>js/lib/underscore-min.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/jquery.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/backbone.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/drag-slider.js"></script>
<script src="<?php stylesheetUri(); ?>js/lib/jquery.colorbox-min.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/main.js"></script>
<!-- Models-->
<script src="<?php stylesheetUri(); ?>js/src/models/news.js"></script>
<!-- Views -->
<script src="<?php stylesheetUri(); ?>js/src/views/navigator.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/collection.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/news.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/pagination.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/gallery.js"></script>
<script src="<?php stylesheetUri(); ?>js/src/views/contact.js"></script>
<!-- Router -->
<script src="<?php stylesheetUri(); ?>js/src/routers/app.js"></script>
</html>