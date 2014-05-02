<?php
$i = 0;
$class = isset($args['class']) ? $args['class'] :  'gal';
$j = 0; // Limit iterator - Remove when pagination is properly implemented please.
$limit = 30; // Pagination for gallery needs to be implemented, meanwhile, just show up to $limit images
$galTitle = array_shift($data);
echo "<h3 class='galleryTitle'>{$galTitle}</h3>";
foreach($data as $img):

    if($j == $limit)
        return false;
    $j++;
    if($i == 0)
        echo '<div class="grid_12 galleryRow">';

    echo '<div class="grid_2 galItem">
            <a href="'.$img['fullImg'].'" title="'.$img['title'].'" class="'.$class.'">
                <img src="'.$img['thumbnail'].'" class="galleryThumb"/>
            </a>
         </div>';

    $i++;
    if($i == $args['colsQ']){
        echo '</div>';
        $i = 0;
    }
endforeach;

