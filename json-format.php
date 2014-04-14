<?php
/*
 * Template Name: News.json
 */

header('content-type: application/json; charset=ISO-8859-1');
header("access-control-allow-origin: *");
/*
 * {title:Here comes coffescript,date:2 Abril 2014,content:Cookie biscuit fruitcake toffee applicake chocolate cake gingerbread. Dessert soufflÃ© apple pie oat cake jujubes tart jelly.,imgSrc:imgs/news-dummy.jpg}
 * */
$json = array(
    array(
        'title' => 'Here comes coffescript',
        'date' => '2 Abril 2014',
        'content' => 'Cookie biscuit fruitcake toffee applicake chocolate cake gingerbread. Dessert soufflÃ© apple pie oat cake jujubes tart jelly.',
        'imgSrc' => 'imgs/news-dummy.jpg'
    ),
    array(
        'title' => 'Here comes coffescript',
        'date' => '2 Abril 2014',
        'content' => 'Cookie biscuit fruitcake toffee applicake chocolate cake gingerbread. Dessert soufflÃ© apple pie oat cake jujubes tart jelly.',
        'imgSrc' => 'imgs/news-dummy.jpg'
    ),
    array(
        'title' => 'Here comes coffescript',
        'date' => '2 Abril 2014',
        'content' => 'Cookie biscuit fruitcake toffee applicake chocolate cake gingerbread. Dessert soufflÃ© apple pie oat cake jujubes tart jelly.',
        'imgSrc' => 'imgs/news-dummy.jpg'
    )


);
query_posts(array('post_type' => 'noticia', 'posts_per_page' => '3', 'paged' => $page));
if(have_posts()):
    $newsArray = array();
    while(have_posts()) : the_post();
       $news = array(
           'title' => get_the_title(),
           'date' => '2 Abril 2014',
           'content' => get_the_content(),
           'imgSrc' => get_template_directory_uri().'/'. 'imgs/news-dummy.jpg'
       );
       array_push($newsArray, $news);
    endwhile;
endif;

echo json_encode($newsArray);