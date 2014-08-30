<div class="container fastFadeIn">
    <div id="canalOnFrame" class="sectionFrames"><span class="SectionLabel">Canal On</span>

        <div id="frameOnSldr" class="sliderViewport">
            <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
            <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
            <ul class="slider">
                <?php
                query_posts('post_type=on&order=ASC');
                while(have_posts()):
                    if(have_posts()): the_post();
                        $imgUrl = getThumbUrl('onFrame');
                        $route = str_replace('on','canal-on', getRoute());

                        #Only create <li> if there is a featured image assigned to the on entry (default wp img)
                        if(strpos($imgUrl, 'default') == false){
                            echo '<li>';
                            echo "<a href='{$route}' class='route'>";
                                echo '<img src="' . $imgUrl . '"/>';
                            echo '</a>';
                            echo '</li>';
                        }
                    endif;
                endwhile;

                ?>
            </ul>
        </div>
    </div>

    <?php
    $imgPerPage = 4;
    $framesConf = array(
        array(
            'prefix' => 'corp',
            'galConf' => array(
                'from' => 'canal-corporativo',
                'thumbSize' => 'corpFrame',
                'imgPerPage' => $imgPerPage
            )
        ),
        array(
            'prefix' => 'Music',
            'galConf' => array(
                'from' => 'canal-musical',
                'thumbSize' => 'musicFrame',
                'imgPerPage' => $imgPerPage
            )
        ),
        array(
            'prefix' => 'corp',
            'galConf' => array(
                'from' => 'canal-corporativo',
                'thumbSize' => 'corpFrame',
                'imgPerPage' => $imgPerPage
            )
        ),
        array(
            'prefix' => 'Events',
            'galConf' => array(
                'from' => 'canal-eventos',
                'thumbSize' => 'eventsFrame',
                'imgPerPage' => $imgPerPage
            )
        )
    );

    foreach ($framesConf as $frameConf): extract($frameConf);
        $label = ucfirst( str_replace('canal-', '', $galConf['from']) );
        ?>

        <div id="canal<?= $prefix; ?>Frame" class="sectionFrames"><span class="SectionLabel"><?= $label; ?></span>

            <div id="frame<?= $prefix; ?>Sldr" class="sliderViewport">
                <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
                <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
                <ul class="slider">

                    <?php
                    $galItems = getGalleryItems($galConf);
                    if(count($galItems) > 0):
                        foreach($galItems as $img): ?>
                            <li>
                                <a href="portafolio/<?= $galConf['from']; ?>" class="route">
                                    <img src="<?= $img['thumbnail']; ?>" alt=""/>
                                </a>
                            </li>
                    <?php
                        endforeach;
                    endif;
                    ?>
                </ul>
            </div>
        </div>

    <?php
    endforeach;
    ?>
