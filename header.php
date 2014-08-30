<html lang="es">
<head>
    <meta charset="utf8"/>
    <title>Dgroupe</title>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.0.3/css/font-awesome.min.css" type="text/css"/>
    <link rel="stylesheet" href="<?php echo get_template_directory_uri() . '/' ?>style.css" type="text/css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <?php wp_head(); ?>
</head>
<body>

<header id="mainHeader">
    <div class="container">
        <a href="/" id="homeLink">
            <figure id="mainLogo" class="route"></figure>
        </a>
        <nav id="mainNav">
            <header id="mobileNavBar">
                <div class="iconMenu">
                    <div class="iconMenuStripes"></div>
                </div>
            </header>
            <ul id="mainMenu">
                <li><a href="/" class="current_page_item">Home</a></li>
                <li class="hideInMobile"><a href="/redes">Redes</a></li>
                <li class="hideInMobile"><a href="/noticias">Noticias</a></li>
                <li class="mainLvl">Portafolio
                    <ul class="subLvl">
                        <li><a href="/portafolio/canal-on">On</a></li>
                        <li><a href="/portafolio/canal-musical">Musical</a></li>
                        <li><a href="/portafolio/canal-corporativo">Corporativo</a></li>
                        <li><a href="/portafolio/canal-eventos">Eventos</a></li>
                    </ul>
                </li>
                <li><a href="/contacto" class="route">contacto</a></li>
            </ul>
        </nav>
    </div>
</header>

<div id="mainLoader" class="progress hidden">
    <div>Loading…</div>
</div>