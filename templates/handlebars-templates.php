<script id="newsEntryTemplate" type="text/x-handlebars-template">
    <div class="entryThumb">
        <a href="{{permalink}}">
            <img src="{{thumbnail}}"/>
        </a>
    </div>
    <a href="{{permalink}}">
        <h3 class="entryTitle">{{{title}}}</h3>
    </a>
    <span class="publishDate">{{date}}</span>
    <p>{{{excerpt}}}</p>
</script>

<script id="fullEntryTemplate" type="text/x-handlebars-template">
    <a href="noticias/" id="backToNews">Regresar</a>
    <h3 class="entryTitle">{{{title}}}</h3>
    <div class="entryBody">
        <div class="entryThumb">
            <a href="/news">
                <img src="{{featuredImg}}"/>
            </a>
        </div>
    <span class="publishDate">
            {{date}}
        </span>
        <div class="entryContent">
            {{{content}}}
        </div>
    </div>
</script>

<script id="galleryTemplate" type="text/x-handlebars-template">
        {{setCounter this}}
        {{#each gallery}}
            <div class="galleryBlock">
                <h3 class="galleryTitle">{{{title}}}</h3>
                {{#each galleryItems}}
                    <div class="grid_2 galItem">
                        <a href="{{this.fullImg}}" title="{{{this.title}}}">
                        <img src="{{this.thumbnail}}" class="galleryThumb" data-index='{{getCounter ../../this}}'>
                        </a>
                    </div>
                    {{increaseCounter ../../this}}
                {{/each}}
            </div>
        {{/each}}
</script>

