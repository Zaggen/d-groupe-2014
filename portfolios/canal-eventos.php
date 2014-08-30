<?php

$slugPrefix = 'events';
$postType = 'canal-eventos';
$postSlug = "portafolio/{$postType}";
$args = array(
    'name' => $postType,
    'post_type' => 'portfolio_line',
    'post_status' => 'publish',
    'numberposts' => 1
);
$post = array_shift(get_posts($args));

$galConf = array(
    'from' => $postType,
    'imgPerPage' => 18,
    'getPageQ' => true
);

$post = array_shift(get_posts($args));
if( $post ): ?>
    <section data-slug="<?= $postSlug; ?>" class="container portfolioSection">
        <header class="portfolioHeader">
            <div class="grid_7 md_grid_6 sm_grid_12"><h1><?= $post->post_title; ?></h1>
                <p>
                    <?= $post->post_content; ?>
                </p>
            </div>
            <div class="grid_5 md_grid_6 sm_grid_12">
            <ul class="portfolioBtns navigator">
                <li><a href="<?= getRoute(); ?>/fotos" class="portfolioBtn picsBtn route selected"></a></li>
                <li><a href="<?= getRoute(); ?>/videos" class="portfolioBtn vidsBtn route"></a></li>
            </ul>
        </div>
    </header>
    <div id="<?= $slugPrefix; ?>SectionSldr" class="sliderViewport">
        <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
        <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
        <ul class="slider">
            <li class="gallery">
                <div class="grid_11 gallery" id="<?= $slugPrefix; ?>Gal">
                    <?php
                    $galleryPage = getGalleryPage($galConf);
                    placePicGal($galleryPage);
                    ?>
                </div>
                <?php
                if(isset($galleryPage['pageQ']))
                    echo "<ul id='{$slugPrefix}GalNavi' class='pageNavi galNavi' data-page-quantity='{$galleryPage['pageQ']}'></ul>";
                ?>
            </li>
            <li class="videoGallery">
                <?php placeVideoGal($postType, "{$slugPrefix}VideoGal");  ?>
            </li>
        </ul>
    </div>
</section>

<?php endif; ?>