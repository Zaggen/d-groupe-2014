<div class="container">
    <h1 class="homeSectionTitle">Noticias recientes</h1>
    <!--   Undescore.js Templates inserted here  -->
    <div id="newsWrapper">
        <ul id="newsFeed" class="feed"></ul>
    </div>
    <input type="button" value="Regresar a la lista" id="backToNewsList" class="backToList hidden"/>
    <?php
    $newsQ = wp_count_posts('noticia');
    $publishedNewsQ = $newsQ->publish;
    $newsPerPage = 3;
    $pageQ = ceil($publishedNewsQ / $newsPerPage);
    ?>
    <ul id="newsNavi" class="pageNavi" data-page-quantity="<?php echo $pageQ; ?>"></ul>
</div>