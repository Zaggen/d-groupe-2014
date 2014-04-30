<section id="contacto" class="container pageSection">
    <div class="grid_12">
        <?php
        query_posts(array(
            'post_type' => 'page',
            'name' => 'contacto'
        ));

        while (have_posts()):

            if (have_posts()): the_post(); ?>
                <?php
                    the_title( '<h2>', '</h2>' );
                    the_content();
                ?>
                <div class="grid_7 contactBlock">
                    <form id="mainContact" class="contactForm grid_8" action="/contact-processor">
                        <input type="text" name="nombre" placeholder="Nombre Completo" required="required" class="textInput"/>
                        <input type="text" name="correo" placeholder="Correo" required="required" class="textInput"/>
                        <input type="text" name="tema" placeholder="Tema" required="required" class="textInput"/>
                        <textarea name="mensaje" placeholder="Mensaje" cols="30" rows="10" class="textInput" required="required"></textarea>
                        <input type="submit" class="contactBtn" value="Enviar"/>
                    </form>
                    <div class="grid_5 contactDetails">
                        <h3>Nuestros Datos</h3>
                        <ul>
                            <li>D-Groupe Bogota</li>
                            <li>Calle 70 # 23 - 45</li>
                            <li>Tel: 656543456</li>
                        </ul>

                        <ul>
                            <li>D-Groupe Medellin</li>
                            <li>Calle 34 # 23 - 45</li>
                            <li>Tel: 656543456</li>
                        </ul>

                    </div>
                </div>
                <div class="grid_4 contactBlock right">
                    <figure>
                        <?php the_post_thumbnail(); ?>
                    </figure>
                </div>
            <?php
            endif;
        endwhile;
        ?>
    </div>
</section>