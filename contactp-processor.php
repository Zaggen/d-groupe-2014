<?php
/*
 * Template Name: Form Contact
 * */

header('content-type: application/json; charset=ISO-8859-1');

if(!empty($_POST['nombre']) and !empty($_POST['mensaje'])){

    // We take the data that came from POST and sanitize it.

    $nombre = sanitize($_POST['nombre'], 'alpha');
    $correo = sanitize($_POST['correo'], 'email');
    $asunto = sanitize($_POST['asunto'], 'varchar');
    $mensaje = sanitize($_POST['mensaje'], 'txt');

    $to = 'dgroupe@hotmail.com';
    $subject = "contacto";

    $body = "<p>Te han enviado un mensaje desde tu web, revisa aqui tu mensaje:</p>
	<p><strong>Nombre:</strong> ".$nombre."</p>
	<p><strong>Correo:</strong> ".$correo."</p>
	<p><strong>Asunto:</strong> ".$asunto."</p>
	<p><strong>Message:</strong> ".$mensaje."

	";
    $headers = 'From: <no-reply@madregabriela.edu.co>' . "\r\n";
    $headers .= "Content-type: text/html\r\n";

    // mail($to, $subject, $body, $headers)

    if(true){
        $msg = array(
            'status' => 'success',
            'title' => 'Gracias',
            'description' => 'Tu mensaje fue enviado con exito'
        );
    }else{
        $msg = array(
            'status' => 'failed',
            'title' => 'Lo sentimos',
            'description' => 'El mensaje no pudo ser enviado, intenta nuevamente'
        );
    }

}else{
    $msg = array(
        'status' => 'failed',
        'title' => 'Ups',
        'description' => 'No llenaste todos los campos, intentalo otra vez'
    );
}

$msg['get'] = $_GET;
$msg['name'] = $_POST['nombre'];
$msg['msg'] = $_POST['mensaje'];

echo json_encode($msg);