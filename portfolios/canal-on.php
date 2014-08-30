<?php
$slugPrefix = 'on';
$postType = 'canal-on';
$postSlug = "portafolio/{$postType}";
$args = array(
    'name' => $postType,
    'post_type' => 'portfolio_line',
    'post_status' => 'publish',
    'numberposts' => 1
);
$post = array_shift(get_posts($args));
if( true ): ?>
<section data-slug="<?= $postSlug; ?>" class="container portfolioSection">
    <header class="portfolioHeader">
        <div class="grid_7 md_grid_6 sm_grid_12"><h1>Canal On</h1>
            <p>
            <?= $post->post_content; ?>
            </p>
        </div>
        <div class="grid_5 md_grid_6 sm_grid_12">
            <ul class="portfolioBtns navigator">
                <li><a href="<?= getRoute(); ?>/kukaramakara" class="portfolioBtn portfolioPlaceBtn kukaramakaraBtn selected"></a></li>
                <li><a href="<?= getRoute(); ?>/lussac" class="portfolioBtn portfolioPlaceBtn lussacBtn"></a></li>
                <li><a href="<?= getRoute(); ?>/sixxtina" class="portfolioBtn portfolioPlaceBtn sixttinaBtn"></a></li>
                <li><a href="<?= getRoute(); ?>/delaire" class="portfolioBtn portfolioPlaceBtn delaireBtn"></a></li>
            </ul>
        </div>
    </header>
    <div id="<?= $slugPrefix; ?>SectionSldr" class="sliderViewport">
        <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
        <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
        <ul class="slider">
            <?php
            # Get all video galleries and set an array
            $videoGallery = array();
           query_posts('post_type=video');
            while(have_posts()):
                if(have_posts()): the_post();
                    $termObj =	get_the_terms($post->id, 'category');
                    $termSlug = array_shift($termObj)->slug;
                    $portfolio = str_replace('on-','',$termSlug); // We get the matching portfolio from e.g on-kukaramakara
                    $videoGallery[$portfolio][] = array(
                        'title' => get_the_title(),
                        'url' => getYtEmbedUrl(get_the_excerpt()),
                        'thumbnail' => getYtThumb(get_the_excerpt())
                    );
                endif;
            endwhile;
            wp_reset_query();

            # Get all the content text and images from the gallery
           $var = query_posts(array(
                    'post_type' => 'on',
                    'order' => 'ASC',
                )
            );

            while(have_posts()):
                if(have_posts()): the_post();

                    $entryData = array(
                        'title' => get_the_title(),
                        'content' => apply_filters('the_content', get_the_content())
                    );

                    $galleryTitle = strtolower( get_the_title() );
                    $galleryTermSlug = "on-{$galleryTitle}";

                    $galConf = array(
                        'from' => $galleryTermSlug,
                        'imgPerPage' => 18,
                        'page' => 1,
                        'getPageQ' => true
                    );
                    $galleryPage = getGalleryPage($galConf);
                    ?>
                    <li>
                        <div class="ourPlaces grid_12">

                                <div class="grid_9 md_grid_11">
                                    <h1><?= $entryData['title']; ?></h1>
                                    <?= $entryData['content'] ?>
                                </div>
                                <div class="grid_3 md_grid_0">
                                    <figure class="partnersLogos <?= strtolower($entryData['title']) . 'Logo'; ?>">
                                    </figure>
                                </div>

                                <div class="grid_12">
                                    <div id="<?= strtolower($galleryTitle); ?>Gal">
                                        <?php placePicGal($galleryPage); ?>
                                    </div>
                                    <?php

                                    if(!empty($videoGallery[$post->post_name])): ?>
                                        <h3>Videos</h3>
                                        <div id="<?= $post->post_name; ?>VideoGal">
                                        <?php
                                            placeTemplate('video-gallery-template', $videoGallery[$post->post_name]);
                                        ?>
                                        </div>
                                    <?php
                                    endif;
                                    ?>
                              </div>
                        </div>
                   </li>
                <?php
                endif;
            endwhile;
            #wp_reset_query();
            ?>
        </ul>
    </div>
</section>


<?php endif; ?>