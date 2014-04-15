<html lang="es">
<head>
    <meta charset="utf8"/>
    <title>Dgroupe</title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.0.3/css/font-awesome.min.css" type="text/css"/>
    <link rel="stylesheet" href="<?php echo get_template_directory_uri() . '/' ?>style.css" type="text/css"/>
    <?php wp_head(); ?>
</head>
<body>
<header id="mainHeader">
    <div class="container">
        <a href="/"><figure id="mainLogo" class="route"></figure></a>
        <nav id="NavBar">
            <ul>
                <li><a href="/" class="current_page_item">Home</a></li>
                <li><a href="/redes">Redes</a></li>
                <li><a href="/noticias">Noticias</a></li>
                <li class="mainLvl">Portafolio
                    <ul class="subLvl">
                        <li><a href="/portafolio/on/kukaramakara">On</a></li>
                        <li><a href="/portafolio/musical/fotos">Musical</a></li>
                        <li><a href="/portafolio/corporativo/fotos">Corporativo</a></li>
                        <li><a href="/portafolio/eventos/fotos">Eventos</a></li>
                    </ul>
                </li>
                <li><a href="/contacto" class="route">contacto</a></li>
            </ul>
        </nav>
    </div>
</header>