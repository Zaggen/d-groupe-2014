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
    <p class="entryContent">
            <%= content %>
        </p>
</script>

<!--
<script id="galleryTemplate" type="text/template">

</script>
-->


