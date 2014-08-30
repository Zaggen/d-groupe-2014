<?php
/*
 * Template Name: News.json
 */


$page = (isset($page)) ? $page : $_REQUEST['page'];

query_posts(array('post_type' => 'noticia', 'posts_per_page' => '3', 'paged' => $page));
if(have_posts()):
    $response = array();
    while(have_posts()) : the_post();
       $news = array(
           'title' => get_the_title(),
           'date' => get_the_date(),
           'excerpt' => get_the_excerpt(),
           'thumbnail' => getThumbUrl('newsThumb'),
           'permalink' => getRoute()
       );
       array_push($response, $news);
    endwhile;
endif;

if (isAjaxRequest()) {
    jsonResponse($response);
}