<?php
/**
 * Created by PhpStorm.
 * User: ZARICH
 * Date: 4/4/14
 * Time: 8:10 PM
 */

function getIdFromSlug($pageslug) {
    $page = get_page_by_path($pageslug);
    if ($page) {
        return $page->ID;
    } else {
        return null;
    }
}

function isAjaxRequest(){
    if(strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest')
        return true;
    else
        return false;
}

#Echoes a json object with json headers
function jsonResponse($jsonArray){
    header('Content-type: application/json');
    $jsonResponse = json_encode($jsonArray);
    echo $jsonResponse;
}

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

function createGalleryObj($galleryIdS, $title = '', $thumbnailSize = 'galleryThumb') {

    if (is_array($galleryIdS)) {
        if(count($galleryIdS) > 0){
            $idsArr = $galleryIdS;
        }else{
            return null;
        }
    }elseif(is_string($galleryIdS)){
        if($galleryIdS !== ''){
            $idsArr = explode(',', $galleryIdS);
        }else{
            trigger_error('createGalleryObj argument string is empty, use a comma separated ids or an array', E_USER_ERROR);
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
        $galleryObj['galleryItems'][] = array(
            'title' => get_the_title($id),
            'thumbnail' => array_shift(wp_get_attachment_image_src($id, $thumbnailSize)),
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

function placeVideoGal($terms, $containerId = '') {
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
        echo "<div class='grid_12' id='{$containerId}'>";
        placeTemplate('video-gallery-template', $videoGallery,
            array('colsQ' => 6));
        echo '</div>';
    }
}

function placePicGal($galleryPage, $galId = '', $class = 'gal') {
    if(empty($galleryPage)){
        return false;
    }

    placeTemplate('gallery-template', $galleryPage['galleries'], null);
    return true;
}


/**
 * @param array $conf
 * @return array Associative array containing all the galleries images inside the conf criteria (page and postPerPage)
 * */
function getGalleryPage($conf = array('postType' => 'post')) {

    $postType = $conf['postType'] ?: 'gallery';
    $termSlug = $conf['from'];
    $imgPerPage = $conf['imgPerPage'] ?: 10;
    $page = $conf['page'] ?: 1;
    $getPageQ = $conf['getPageQ'] ?: false;
    $thumbSize = $conf['thumbSize'] ?: null;

    $galleryPage = array();
    $galleries = array();

    # Item Quantity needed to fill a whole page
    $dueItems =  $imgPerPage;

    # Used to ignore galleries outside of our lookup page range
    $rangeToIgnore = ($page  * $imgPerPage) - $imgPerPage; # The range is between 0 and this number
    $totalImgQ = 0;

    # Used to skip the gallery adding process just to get the $totalImgQ
    $skip = false;

    $query = new WP_Query( array(
            'post_type' => $postType,
            'tax_query' => array(
                array(
                    'taxonomy' => 'category',
                    'field' => 'slug',
                    'terms' => $termSlug)
            )
        )
    );
    while ( $query->have_posts() ) :
        if (have_posts()): $query->the_post();

            $galTitle = get_the_title();
            $data = splitGalFromContent();
            $galIds = explode(',', $data['galleryIds']);
            $galImgQ = count($galIds);

            $temp = $rangeToIgnore - $totalImgQ; # We might use it as our $startIndex value
            $temp = ($temp < 0) ? 0 : $temp;
            $totalImgQ += $galImgQ;


            # Once we get our images object, and the getPageQ option is
            # true, we need to keep looping just to find out how many
            # images are there in total, but we don't want to add those
            # to our array, so we just skip them
            if(!$skip):

                # We ignore the images in any gallery when the image count is
                # inside the ignore range (0-$rangeToIgnore), since it depends of the current page
                # being displayed, e.g: on page 1 it starts at 0, at page 2
                # with the default img per page we start at 10, so the first admitted
                # gallery should come after the the $totalImgQ gets as high as 11

                if($totalImgQ > $rangeToIgnore){
                    $startIndex = $temp;
                    $itemsToTake = ( $galImgQ > $dueItems ) ? $dueItems : $galImgQ;
                    $galIds = array_splice($galIds, $startIndex, $itemsToTake);
                    $galleries[] = createGalleryObj($galIds, $galTitle, $thumbSize);
                    $dueItems = $dueItems - $galImgQ;
                }

                # When no more items are needed to fill our page, we either break out of the loop or
                # keep adding the gallery Quantity of each entry but skipping them and use the total
                # to get our number of pages(A few lines below).
                if($dueItems <= 0){
                    if($getPageQ){
                        $skip = true;
                    }else{
                        break;
                    }
                }
            endif;

        endif;
    endwhile;

    if($getPageQ){
        $galleryPage['pageQ'] = ceil($totalImgQ / $imgPerPage);
    }

    $galleryPage['galleries'] = $galleries;

    return $galleryPage;
}

function getArrayFromIds($ids){
    if(is_string($ids)){

        if($ids == ''){
            return array();
        }

        $ids = explode(',',$ids);

    }elseif(is_array($ids)){

        return $ids;
    }

    return $ids;

}

function getGalPageFromIds($conf = array()) {

    $galIds = getArrayFromIds($conf['galIds']);
    $imgPerPage = $conf['imgPerPage'] ?: 10;
    $page = $conf['page'] ?: 1;
    $getPageQ = $conf['getPageQ'] ?: false;
    $galTitle = $conf['galTitle'] ?: null;

    $galleryPage = array();
    $startRange = ($page * $imgPerPage) - $imgPerPage;
    $totalImgQ = count($galIds);
    $galleries = array();

    if($startRange < $totalImgQ){
        $galIds = array_splice($galIds, $startRange, $imgPerPage);
        $galleries[0] = createGalleryObj($galIds, $galTitle);

    }

    if($getPageQ){
        $galleryPage['pageQ'] = ceil($totalImgQ / $imgPerPage);
    }

    $galleryPage['galleries'] = $galleries;

    return $galleryPage;
}

function getGalleryItems($galConf){
    $galleryPage = getGalleryPage($galConf);
    $galleries = array_shift($galleryPage['galleries']);
    return $galleries['galleryItems'];
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
    wp_deregister_script('underscore');
}

// Limpia los imputs de los formularios enviados.

function sanitize($input, $mode = 'txt')  {
    $input = trim($input);
    $input = strip_tags($input);
    switch ($mode)	  {
        case 'varchar':
            $healthy = preg_replace('/[^a-z A-Z-_]/', '', $input);
            return $healthy;
            break;

        case 'alpha':
            $healthy = preg_replace('/[^a-z A-Z]/', '', $input);
            return $healthy;
            break;

        case 'alnum':
            $healthy = preg_replace('/[^0-9 a-zA-Z]/', '', $input);
            return $healthy;
            break;

        case 'num':
            $healthy = preg_replace('/[^0-9]/', '', $input);
            return $healthy;
            break;

        case 'email':
            $healthy = trim(preg_replace('/[^0-9a-zA-Z_@.]/', '', $input)," ");
            return $healthy;
            break;

        case 'txt':
            $healthy = preg_replace('/[^a-z A-Z0-9@\'\"\.\,\#\%\(\)\$\/\:áéíóú&ñ\;\¿\?\!\¡\+\-\*\=]/', '', $input);
            return $healthy;
            break;

        case null:
            return $input;

    }

    return true;

}

include_once('includes/encrypt-decrypt.php');

# Sizes
# 369 * 237
# Slider Frames Thumb Sizes
add_image_size('onFrame', 363, 306, true);
add_image_size('musicFrame', 369, 237, true);
add_image_size('corpFrame', 352, 210, true);
add_image_size('eventsFrame', 344, 238, true);

add_image_size('newsThumb', 182, 141, true);
add_image_size('galleryThumb', 142, 142, true);

add_image_size('singleEntry', 680, 270, true);

add_image_size('djThumb', 120, 120, true);

