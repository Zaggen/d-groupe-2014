<?php
$i = 0;
foreach($data as $gallery): ?>

        <div class="galleryBlock">
            <h3 class="galleryTitle"><?= $gallery['title']; ?></h3>
            <?php
            $itemsInRow = 0;
            foreach($gallery['galleryItems'] as $galleryItem){
               echo
               "<div class='grid_2 galItem'>
                    <a href='{$galleryItem['fullImg']}' title='{$galleryItem['title']}' class='gal'>
                        <img src='{$galleryItem['thumbnail']}' class='galleryThumb' data-index='{$i}'>
                    </a>
               </div>";
               $i++;
            }
            ?>
        </div>

<?php
endforeach;