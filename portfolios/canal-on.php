<section id="on" class="container portfolioSection">
    <header class="portfolioHeader">
        <div class="grid_7"><h1>Canal On</h1>

            <p>The aim of this document is to get you started with developing applications for Node.js. It teaches you
                everything you need to know about advanced JavaScript</p></div>
        <div class="grid_5">
            <ul class="portfolioBtns navigator">
                <li><a href="/portafolio/on/kukaramakara" class="portfolioBtn portfolioPlaceBtn kukaramakaraBtn selected"></a></li>
                <li><a href="/portafolio/on/lussac" class="portfolioBtn portfolioPlaceBtn lussacBtn"></a></li>
                <li><a href="/portafolio/on/sixxtina" class="portfolioBtn portfolioPlaceBtn sixttinaBtn"></a></li>
                <li><a href="/portafolio/on/delaire" class="portfolioBtn portfolioPlaceBtn delaireBtn"></a></li>
            </ul>
        </div>
    </header>
    <div id="onSectionSldr" class="sliderViewport">
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

            # Get all the content text and images from the gallery
            query_posts('post_type=on&order=ASC');
            while(have_posts()):
                if(have_posts()): the_post();
                    echo '<li>';
                        echo '<div class="ourPlaces grid_11">';

                                $data = splitGalFromContent();
                                $content = apply_filters('the_content', $data['content']);
                                $gallery = createGalleryObj($data['galleryIds']);

                                $entryData = array(
                                    'title' => get_the_title(),
                                    'content' => $content
                                );

                                placeTemplate('on-template', $entryData);

                                if(!empty($gallery))
                                    placeTemplate('gallery-template', $gallery, array('colsQ' => 6));

                                $gallery = array(); // Reseting gallery array

                                if(!empty($videoGallery[$post->post_name])){
                                    echo '<div class="grid_12">';
                                    echo '<h3>Videos</h3>';
                                    placeTemplate('video-gallery-template', $videoGallery[$post->post_name],
                                        array('colsQ' => 6));
                                    echo '</div>';
                                }

                        echo '</div>';
                    echo '</li>';
                endif;
            endwhile;
            ?>
        </ul>
    </div>
</section>