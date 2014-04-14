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
        <li><<</li>
        <li class="selectedNav">1</li>
        <li>2</li>
        <li>3</li>
        <li>4</li>
        <li>5</li>
        <li>>></li>
    </ul>
</div>