<div class="container">
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

                        #Only create <li> if there is a featured image assigned to the on entry (default wp img)
                        if(strpos($imgUrl, 'default') == false){
                            echo '<li>';
                            echo '<a href="'. getRoute() . '" class="route">';
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
    <div id="canalMusicalFrame" class="sectionFrames"><span class="SectionLabel">Musical</span>

        <div id="frameMusicSldr" class="sliderViewport">
            <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
            <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
            <ul class="slider">
                <?php
                $config = array(
                    'postType' => 'musical',
                    'slug' => 'fotos',
                    'limit' => 4,
                    'thumbSize' => 'musicFrame'
                );
                galFrameSliderItems($config);
                ?>
            </ul>
        </div>
    </div>
    <div id="canalCorpFrame" class="sectionFrames"><span class="SectionLabel">Corporativo</span>

        <div id="frameCorpSldr" class="sliderViewport">
            <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
            <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
            <ul class="slider">
                <?php
                $config = array(
                    'postType' => 'corporativo',
                    'slug' => 'fotos',
                    'limit' => 4,
                    'thumbSize' => 'corpFrame'
                );
                galFrameSliderItems($config);
                ?>
            </ul>
        </div>
    </div>
    <div id="eventosFrame" class="sectionFrames"><span class="SectionLabel">Eventos</span>

        <div id="frameEventsSldr" class="sliderViewport">
            <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
            <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
            <ul class="slider">
                <?php
                $config = array(
                    'postType' => 'eventos',
                    'slug' => 'fotos',
                    'limit' => 4,
                    'thumbSize' => 'eventsFrame'
                );
                galFrameSliderItems($config);
                ?>
            </ul>
        </div>
    </div>
</div>