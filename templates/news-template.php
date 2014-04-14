<div class="container">
    <h1 class="homeSectionTitle">Noticias recientes</h1>
    <script id="newsEntries" type="text/template">
        <div
            class="entryThumb">
            <a href="/news">
                <img src="<%= imgSrc %>"/>
            </a>
        </div>
        <h3 class="entryTitle"><%= title %></h3>
        <span class="publishDate"><%= date %></span>
        <p><%= content %></p>
    </script>
    <script id="fullEntry" type="text/template">
        <h3 class="entryTitle"><%= title %></h3>
        <div class="entryThumb">
            <a href="/news">
                <img src="<%= imgSrc %>"/>
            </a>
        </div>
        <span class="publishDate">
            <%= date %>
        </span>
        <p>
            <%= content %>
        </p>
    </script>
    <div id="newsWrapper">
        <ul id="newsFeed"></ul>
    </div>
    <input type="button" value="Regresar a la lista" id="backToNewsList" class="backToList hidden"/>
    <ul id="newsNavi" class="pageNavi">
        <li class="selectedNav">1</li>
        <?php
        $newsQ = wp_count_posts('noticia');
        $publishedNewsQ = $newsQ->publish;
        $newsPerPage = 3;
        $pageQ = ceil($publishedNewsQ / $newsPerPage);
        for($i = 2; $i <= $pageQ; $i++):
            echo "<li>{$i}</li>";
        endfor;
        ?>
    </ul>
</div>