<section id="homeSection" class="pageSection sm_hidden">
    <section id="mainSlider" class="sliderViewport">
        <!-- Left-Right buttons to navigate back and forward in the slider-->
        <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
        <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
        <!-- Main slider-->
        <ul class="slider">
            <!-- Start of home slide, contains 4 frames, each with an image slider, there is a frame per bussiness channel-->
            <li>
                <?php placeTemplate('frames-template'); ?>
            </li>
            <!--   Start .socialBlocks : Contains 4 blocks with twitter and fb box for each place (kukaramakara,sixxtina,etc -->
            <li>
                <?php placeTemplate('social-blocks-template'); ?>
            </li>

            <li>
                <?php placeTemplate('news-template'); ?>
            </li>
        </ul>
    </section>
    <footer class="BrandsFooter sm_hidden">
        <div class="container">
            <figure class="partnersLogos kukaramakaraLogo"></figure>
            <figure class="partnersLogos lussacLogo"></figure>
            <figure class="partnersLogos sixttinaLogo"></figure>
            <figure class="partnersLogos delaireLogo"></figure>
        </div>
    </footer>
</section>

<?php
$id = getIdFromSlug('mobile-home');
$post = get_post($id);
$content = apply_filters('the_content', $post->post_content);
?>

<section id="mobilHome" class="portfolioSection">
    <?php if(!empty($content)) echo  $content; ?>
</section>