<?php
if(have_posts()):
    while(have_posts()): the_post();

        $thumbId = get_post_thumbnail_id();
        $featuredImageArr = wp_get_attachment_image_src($thumbId, 'singleEntry', true);
        $featuredImage = $featuredImageArr[0];

        $response = array(
            'title' => get_the_title(),
            'content' => apply_filters( 'the_content',get_the_content() ),
            'featuredImg' => $featuredImage,
            'date' => get_the_date()
        );
    endwhile;
endif;


if (isAjaxRequest()) {
    jsonResponse($response);
} else {
    include_once('app-modules.php');
}


