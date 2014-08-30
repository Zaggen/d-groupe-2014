<?php

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

$newsQ = wp_count_posts('noticia');
$publishedNewsQ = $newsQ->publish;
$newsPerPage = 3;
$pageQ = ceil($publishedNewsQ / $newsPerPage);
?>

<div class="container">
    <h1 class="homeSectionTitle">Noticias recientes</h1>
    <div id="newsWrapper">
        <ul id="newsFeed" class="grid">
        <?php foreach($response as $entry): extract($entry);?>
            <li class="entry">
                <div class="entryThumb">
                    <a href="<?= $permalink; ?>">
                        <img src="<?= $thumbnail; ?>"/>
                    </a>
                </div>
                <a href="<?= $permalink; ?>">
                    <h3 class="entryTitle"><?= $title; ?></h3>
                </a>
                <span class="publishDate"><?= $date; ?></span>
                <p><?= $excerpt; ?></p>
            </li>
        <?php endforeach; ?>
        </ul>
        <ul id="newsNavi" class="pageNavi" data-page-quantity="<?= $pageQ; ?>"></ul>
    </div>
</div>