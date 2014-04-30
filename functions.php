<?php
/**
 * Created by PhpStorm.
 * User: ZARICH
 * Date: 4/4/14
 * Time: 8:10 PM
 */

if (function_exists('add_theme_support')) {
    add_theme_support('post-thumbnails');
}

function getStylesheetUri() {
    return get_stylesheet_directory_uri() . '/';
}

function stylesheetUri() {
    echo getStylesheetUri();
}

function getThumbUrlArr($thumbnailSize = 'small') {
    $thumbId = get_post_thumbnail_id();
    $thumbUrl = wp_get_attachment_image_src($thumbId, $thumbnailSize, true);
    return $thumbUrl;
}

function getThumbUrl($thumbnailSize = 'small') {
    $thumbUrl = getThumbUrlArr($thumbnailSize);
    return $thumbUrl[0];
}

function getRoute() {
    $link = rtrim(get_permalink(), '/'); # We remove the last trailing slash
    return removeBaseUrl($link);
}

# Removes the site base url from the link, useful in our backbone routes, we can't use full urls but paths :)
function removeBaseUrl($permalink) {
    return str_replace(get_site_url(), '', $permalink);
}


function getYtEmbedUrl($ytLink) {
    $search = '#(.*?)(?:href="https?://)?(?:www\.)?(?:youtu\.be/|youtube\.com(?:/embed/|/v/|/watch?.*?v=))([\w\-]{10,12}).*#x';
    $replace = 'http://www.youtube.com/embed/$2';
    return preg_replace($search, $replace, $ytLink);
}

function getYtThumb($ytLink) {
    parse_str(parse_url($ytLink, PHP_URL_QUERY), $urlSegments);
    return "http://img.youtube.com/vi/{$urlSegments['v']}/2.jpg";
}

function placeTemplate($templateName, $data = array(), $args = array()) {
    $templatePath = 'templates/' . $templateName . '.php';
    return include($templatePath);
}

function getGalIdsFromContent() {
    $content = get_the_content();
    preg_match('/\[gallery ids="(.*)"\]/', $content, $match);
    return $match[1];
}

/**
 * Searches for a gallery shortCode in the wordpress content, it stores its ids in a key of the array returned
 * and also returns the original content string with the shortcode from the gallery removed
 * @return array
 */
function splitGalFromContent() {
    $content = get_the_content();
    preg_match('/\[gallery ids="(.*)"\]/', $content, $match);
    $content = str_replace($match[0], '', $content);
    $content = apply_filters('the_content', $content);
    $galleryIds = $match[1]; // String

    return array(
        'galleryIds' => $galleryIds,
        'content' => $content
    );
}

function createGalleryObj($galleryIdS, $title = '') {

    if (is_array($galleryIdS)) {
        if(count($galleryIdS) > 0){
            $idsArr = $galleryIdS;
        }else{
            return null;
        }
    }elseif(is_string($galleryIdS)){
        if($galleryIdS == ''){
            $idsArr = explode(',', $galleryIdS);
        }else{
            return null;
        }
    }elseif($galleryIdS === null){
        return null;
    }else{
        trigger_error('createGalleryObj needs an array of ids or a comma separated id string, or null to bypass it', E_USER_ERROR);
        return null;
    }

    $galleryObj = array();

    if($title !== ''){
        $galleryObj['title'] = $title;
    }


    foreach ($idsArr as $id) {
        $galleryObj[] = array(
            'title' => get_the_title($id),
            'thumbnail' => array_shift(wp_get_attachment_image_src($id, 'galleryThumb')),
            'fullImg' => array_shift(wp_get_attachment_image_src($id, 'large'))
        );
    }
    return $galleryObj;
}

function getGalleryThumbsArr($galleryIdString, $thumbSize = 'small') {

    if ($galleryIdString == '') {
        return false;
    }

    $idsArr = explode(',', $galleryIdString);
    $galleryArr = array();

    foreach ($idsArr as $id) {
        $galleryArr[] = array_shift(wp_get_attachment_image_src($id, $thumbSize));
    }
    return $galleryArr;
}

function placeVideoGal($terms) {
    $query = array(
        'post_type' => 'video',
        'tax_query' => array(
            array(
                'taxonomy' => 'category',
                'field' => 'slug',
                'terms' => $terms
            )
        )
    );
    query_posts($query);
    while (have_posts()):
        if (have_posts()): the_post();
            $videoGallery[] = array(
                'title' => get_the_title(),
                'url' => getYtEmbedUrl(get_the_excerpt()),
                'thumbnail' => getYtThumb(get_the_excerpt())
            );
        endif;
    endwhile;
    if (!empty($videoGallery)) {
        echo '<div class="grid_12">';
        placeTemplate('video-gallery-template', $videoGallery,
            array('colsQ' => 6));
        echo '</div>';
    }
}

/*function placePicGal($postType) {
    query_posts(array('post_type' => $postType));
    while (have_posts()):
        if (have_posts()): the_post();
            $data = splitGalFromContent();
            $gallery = createGalleryObj($data['galleryIds']);
            placeTemplate('gallery-template', $gallery, array('colsQ' => 6, 'class' => 'musicGal'));
        endif;
    endwhile;
}*/

function placePicGal($galleryArr) {
    foreach($galleryArr as $gallery){
        placeTemplate('gallery-template', $gallery, array('colsQ' => 6, 'class' => 'musicGal'));
    }
}

/**
 * @param string $postType
 * @param integer $imgPerPage
 * @param integer $page
 * @return array
 * */
function getGalleries($postType = 'post', $imgPerPage = 0, $page = 1) {
    $galleries = array();
    $imgCounter = 0; # Images Quantity
    $pageLimit = (is_int($imgPerPage) && $imgPerPage > 0) ? true : false;
    $pageIterator = 1;
    $overflow = 0;
    $overflowedObj = array();

    query_posts(array('post_type' => $postType));
    while (have_posts()):
        if (have_posts()): the_post();

            $galTitle = get_the_title();
            $data = splitGalFromContent();
            echo '$data[galleryIds]->'. $data['galleryIds'] . '</br>';
            $galIds = explode(',', $data['galleryIds']);

            if($pageLimit){

                if($pageIterator <= $page){
                    $currentGalQ = count($galIds);
                    echo '$currentGalQ ->'. $currentGalQ . '</br>';
                    $imgCounter += $currentGalQ;
                    echo '$imgCounter ->'. $imgCounter . '</br>';
                    # -do not push gallery objs from any other page but the specified
                    # -page iterator should increase each time it gets the $imgPerPage cuota filled by the counter
                    # -overflowed images should go into another page, this is imgs from the current page that overflows
                    # into $imgPerPage limit.

                    /*if($imgCounter > $imgPerPage && $pageIterator !== $page){
                        $overflow = $imgCounter - $imgPerPage;
                        echo '$overflow ->'. $overflow . '</br>';
                        $chunks = array_chunk($galIds, $currentGalQ - $overflow);

                        echo '<pre>';
                        print_r($chunks);
                        echo '</pre>';
                        $overflowedObj['title'] = $galTitle;
                        $overflowedObj['ids'] = array_splice($galIds, $overflow);//$chunks[1];

                        $galIds = array_splice($galIds, 0, $overflow); //$chunks[0];


                        if($pageIterator !== $page){
                            $pageIterator++;
                        }
                        echo '$pageIterator ->'. $pageIterator . '</br>';
                        $imgCounter = $overflow; # We reset our imgCounter taking into account the overflowed images for the next page
                    }*/

                    if($imgCounter > $imgPerPage){

                        echo '$galIds</br>';


                        $overflow = $imgPerPage - $imgCounter; #Negative index
                        echo '$overflow ->'. $overflow . '</br>';
                        $overflowedIds = array_splice($galIds, $overflow);

                        echo '<pre>';
                        print_r($galIds);
                        echo '</pre>';


                        echo '$overflowedIds</br>';
                        echo '<pre>';
                        print_r($overflowedIds);
                        echo '</pre>';

                        if($pageIterator === $page){
                            $galleries[] = createGalleryObj($galIds, $galTitle);
                            break;
                        }else{
                            $overflowedObj['title'] = $galTitle;
                            $overflowedObj['ids'] = $overflowedIds;

                            $overflowedObj[] = array(
                                'title' => $galTitle,
                                'ids' => $overflowedIds
                            );

                            $imgCounter = abs($overflow);
                            $pageIterator++;
                        }


                    }

                    /*if($pageIterator === $page){
                        echo '$page ->'. $page . '</br>';
                        if(!empty($overflowedObj)){
                            echo '$overflowedObj -> not empty</br>';
                            $galleries[] = createGalleryObj($overflowedObj['ids'], $overflowedObj['title']);
                            $overflowedObj = array();
                        }
                        if($imgCounter > $imgPerPage){
                            $overflow = $imgPerPage - $imgCounter; #Negative index
                            echo '$overflow ->'. $overflow . '</br>';
                            $galIds = array_splice($galIds, 0, $overflow);

                            echo '<pre>';
                            print_r($galIds);
                            echo '</pre>';
                            $galleries[] = createGalleryObj($galIds, $galTitle);
                            break;
                        } else {
                            $galleries[] = createGalleryObj($galIds, $galTitle);
                        }

                    }*/


                }else{
                    break;
                }

            }

            #$galleries[] = createGalleryObj($galIds, $galTitle);

            #placeTemplate('gallery-template', $gallery, array('colsQ' => 6, 'class' => 'musicGal'));
        endif;
    endwhile;

    echo '<pre>';
    print_r($galleries);
    echo '</pre>';

    return $galleries;
}

function galFrameSliderItems($config) {

    query_posts(array(
        'post_type' => $config['postType'],
        'name' => $config['slug']
    ));

    while (have_posts()):
        if (have_posts()): the_post();

            $galIds = explode(',', getGalIdsFromContent());

            for($i = 0; $i < $config['limit']; $i++){
                $imgUrl = array_shift(wp_get_attachment_image_src($galIds[$i], $config['thumbSize']));
                echo '<li>';
                echo '<a href="' . getRoute() . '" class="route">';
                echo '<img src="' . $imgUrl . '"/>';
                echo '</a>';
                echo '</li>';
            }

        endif;
    endwhile;

    wp_reset_query();
}

# Disabling jquery load from WP
if (!is_admin()) {
    wp_deregister_script('jquery');
}

// Limpia los imputs de los formularios enviados.

function sanitize($imput,$mode="txt")  {
    $imput = trim($imput);
    $imput = strip_tags($imput);
    switch ($mode)	  {
        case "varchar":
            $healthy = preg_replace('/[^a-z A-Z-_]/', '', $imput);
            return $healthy;

        case "alpha":
            $healthy = preg_replace('/[^a-z A-Z]/', '', $imput);
            return $healthy;

            break;

        case "alnum":
            $healthy = preg_replace('/[^0-9 a-zA-Z]/', '', $imput);
            return $healthy;

            break;

        case "num":
            $healthy = preg_replace('/[^0-9]/', '', $imput);
            return $healthy;

            break;

        case "email":
            $healthy = trim(preg_replace('/[^0-9a-zA-Z_@.]/', '', $imput)," ");
            return $healthy;

            break;

        case "txt":
            $healthy = preg_replace('/[^a-z A-Z0-9@\'\"\.\,\#\%\(\)\$\/\:áéíóú&ñ\;\¿\?\!\¡\+\-\*\=]/', '', $imput);
            return $healthy;

            break;

    }
}

# Sizes
# 369 * 237
# Slider Frames Thumb Sizes
add_image_size('onFrame', 363, 306, true);
add_image_size('musicFrame', 369, 237, true);
add_image_size('corpFrame', 352, 210, true);
add_image_size('eventsFrame', 344, 238, true);

add_image_size('newsThumb', 182, 141, true);
add_image_size('galleryThumb', 142, 142, true);