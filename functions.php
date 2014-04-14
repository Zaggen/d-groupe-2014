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

function getStylesheetUri(){
    return get_stylesheet_directory_uri() . '/';
}

function stylesheetUri(){
    echo getStylesheetUri();
}


function getYtEmbedUrl($ytLink)
{
    $search = '#(.*?)(?:href="https?://)?(?:www\.)?(?:youtu\.be/|youtube\.com(?:/embed/|/v/|/watch?.*?v=))([\w\-]{10,12}).*#x';
    $replace = 'http://www.youtube.com/embed/$2';
    return preg_replace($search, $replace, $ytLink);
}

function getYtThumb($ytLink){
    parse_str(parse_url($ytLink, PHP_URL_QUERY), $urlSegments);
    return "http://img.youtube.com/vi/{$urlSegments['v']}/2.jpg";
}

function placeTemplate($templateName,  $data = array(), $args = array()) {
    $templatePath = 'templates/' . $templateName . '.php';
    return include($templatePath);
}

function createGalleryObj($galleryIdString) {

    if ($galleryIdString == '') return false;

    $idsArr = explode(',', $galleryIdString);
    $galleryObj = array();

    foreach ($idsArr as $id) {
        $galleryObj[] = array(
            'title' => get_the_title($id),
            'thumbnail' => array_shift(wp_get_attachment_image_src($id, 'galleryThumb')),
            'fullImg' => array_shift(wp_get_attachment_image_src($id, 'large'))
        );
    }
    return $galleryObj;
}

function placeVideoGal($terms)
{
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
            $termObj = get_the_terms($post->id, 'category');
            $termSlug = array_shift($termObj)->slug;
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

function placePicGal($postType){
    query_posts(array('post_type' => $postType, 'name' => 'fotos'));
    while (have_posts()):
        if (have_posts()): the_post();
            preg_match('/\[gallery ids="(.*)"\]/', get_the_content(), $match);
            $galleryIds = $match[1]; // String
            $gallery = createGalleryObj($galleryIds);
            placeTemplate('gallery-template', $gallery, array('colsQ' => 6, 'class' => 'musicGal'));
        endif;
    endwhile;
}

// Disabling jquery load from WP
if (!is_admin()) {
    wp_deregister_script('jquery');
}

add_image_size('galleryThumb', 142, 142, true);