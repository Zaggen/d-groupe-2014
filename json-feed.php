<?php
/*
 * Template Name: News.json
 */

header('content-type: application/json; charset=ISO-8859-1');

query_posts(array('post_type' => 'noticia', 'posts_per_page' => '3', 'paged' => $page));
if(have_posts()):
    $newsArray = array();
    while(have_posts()) : the_post();

       $thumbId = get_post_thumbnail_id();
       $thumbUrl = wp_get_attachment_image_src($thumbId,'thumbnail-size', true);
       $news = array(
           'title' => get_the_title(),
           'date' => '2 Abril 2014',
           'content' => get_the_content(),
           'imgSrc' => getThumbUrl('newsThumb')
       );
       array_push($newsArray, $news);
    endwhile;
endif;

echo json_encode($newsArray);

///get_template_directory_uri().'/'. 'imgs/news-dummy.jpg'

