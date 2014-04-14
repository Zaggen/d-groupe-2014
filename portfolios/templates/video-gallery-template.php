<?php
$i = 0;
$class = isset($args['class']) ? $args['class'] :  'ytGal';
$j = 0; // Limit iterator - Remove when pagination is properly implemented please.
$limit = 30; // Pagination for gallery needs to be implemented, meanwhile, just show up to $limit images
foreach($data as $video):
    if($j == $limit)
        return false;
    $j++;
    if($i == 0)
        echo '<div class="grid_12 galleryRow">';

    echo '<div class="grid_2">
            <a href="'.$video['url'].'" title="'.$video['title'].'" class="'.$class.'">
                <img src="'.$video['thumbnail'].'" class="galleryThumb"/>
            </a>
         </div>';

    $i++;
    if($i == $args['colsQ']){
        echo '</div>';
        $i = 0;
    }
endforeach;

