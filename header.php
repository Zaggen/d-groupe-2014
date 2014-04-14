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
                <li class="current_page_item"><a href="/" class="route">Home</a></li>
                <li><a href="/redes" class="route">Redes</a></li>
                <li><a href="/noticias" class="route">Noticias</a></li>
                <li class="mainLvl" class="route">Portafolio
                    <ul class="subLvl">
                        <li><a href="/portafolio/on/kukaramakara" class="route">On</a></li>
                        <li><a href="/portafolio/musical/fotos" class="route">Musical</a></li>
                        <li><a href="/portafolio/corporativo" class="route">Corporativo</a></li>
                        <li><a href="/portafolio/eventos" class="route">Eventos</a></li>
                    </ul>
                </li>
                <li><a href="/contacto" class="route">contacto</a></li>
            </ul>
        </nav>
    </div>
</header>