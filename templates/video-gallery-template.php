<?php
$i = 0;
foreach($data as $video):

        echo
        "<div class='grid_2 galItem'>
                <a href='{$video['url']}' title='{$video['title']}' class='ytGal'>
                    <img src='{$video['thumbnail']}' class='galleryThumb' data-index='{$i}'>
                </a>
           </div>";
        $i++;

endforeach;

