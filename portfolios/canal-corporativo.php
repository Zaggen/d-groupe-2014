<section id="corporativo" class="container portFolioSection">
    <header class="portfolioHeader">
        <div class="grid_8"><h1>Canal Corporativo</h1>

            <p>The aim of this document is to get you started with developing applications for Node.js. It teaches you
                everything you need to know about advanced JavaScript</p></div>
        <div class="grid_4">
            <ul class="portfolioBtns navigator">
                <li><a href="/portafolio/corporativo/fotos" class="portfolioBtn picsBtn route selected"></a></li>
                <li><a href="/portafolio/corporativo/videos" class="portfolioBtn vidsBtn route"></a></li>
            </ul>
        </div>
    </header>
    <div id="corpSectionSldr" class="sliderViewport">
        <div class="sliderBtn prevBtn"><i class="fa fa-angle-left"></i></div>
        <div class="sliderBtn nextBtn"><i class="fa fa-angle-right"></i></div>
        <ul class="slider">
            <li class="gallery">
                <div class="grid_11">
                    <?php
                    $galleries = getGalleries('corporativo', 14, 1);
                    placePicGal($galleries, 'corpGalNavi');
                    ?>
                </div>
            </li>
            <li class="videoGallery">
                <?php placeVideoGal('canal-corporativo');  ?>
            </li>
        </ul>
    </div>
</section>