<?php
$djHouses = array();
$conf = array(
    'post_type' => 'dj',
    'order' => 'ASC',
    'posts_per_page' => -1
);
query_posts($conf);
while(have_posts()):
    if(have_posts()): the_post();

        $djHousesList =	get_the_terms($post->id, 'dj-house');
        $djName = get_the_title();
        $djPic = getThumbUrl('djThumb');

        foreach($djHousesList as $djHouse){
            $djHouses[$djHouse->slug][] = array(
                'name' => $djName,
                'thumbnail' => $djPic
            );
        }

        ?>

    <?php
    endif;
endwhile;


$djLimit = 4;
foreach($djHouses as $djHouse => $djs):
    $counter = 0; ?>
    <div class="djBlockList">
        <div class="grid_12">
            <figure class="partnersLogos <?= $djHouse; ?>Logo"></figure>
        </div>
            <ul class="grid_12">
            <?php foreach($djs as $dj): ?>
                <li class="dj">
                    <figure><img src="<?= $dj['thumbnail']; ?>"/>
                        <figcaption><?= $dj['name']; ?></figcaption>
                    </figure>
                </li>
            <?php endforeach; ?>
            </ul>
    </div>
<?php
endforeach;
?>

