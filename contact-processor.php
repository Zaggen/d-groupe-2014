<?php
/*
 * Template Name: Contact Processor
 * */

# Handles the creation and response of an encrypted token
require_once('includes/contact-processor.php');

if(have_posts()):
    while(have_posts()): the_post();
        $to = get_the_content(); # We get the admin email from the content of the contact page
    endwhile;
endif;

$to = $to ?: '';

$config = array(
    'from' => array(
        'Catalina Otalvaro Website',
        'no-reply@catalinaotalvaro.me'
    ),
    'to' => $to,
    'replyTo' => 'no-reply@catalinaotalvaro.me',
    'inputs' => array(
        'name' => array(
            'value' => $_POST['nombre'],
            'filter' => 'alpha'
        ),
        'email' => array(
            'value' => $_POST['correo'],
            'filter' => 'email'
        ),
        'topic' => array(
            'value' => $_POST['asunto'],
            'filter' => 'varchar',
            'notRequired' => true
        ),
        'msg' => array(
            'value' => $_POST['mensaje'],
            'filter' => 'txt'
        ),
        'token' => array(
            'value' => $_POST['token'],
            'filter' => null
        )
    )
);

new ContactProcessor($config);
