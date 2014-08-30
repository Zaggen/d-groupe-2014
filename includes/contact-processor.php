<?php
class ContactProcessor {
    public $config;
    private $inputData, $response, $to, $from, $replyTo, $subject;

    function __construct($config) {
        $this->config = $config;
        $this->decideAction();
    }

    function decideAction(){

        $action = sanitize($_GET['action']);

        if($action == 'getToken'):
            $this->setToken();
        else:
            $this->setMessage();
        endif;

        jsonResponse($this->response);

    }

    private function setToken(){
        $name = sanitize($_GET['tokenString'], 'alpha'); # This should be the name in the form
        if($name != null){
            $timeStamp = time();
            $tokenString = "{$name}*{$timeStamp}";
            $this->response = array(
                'token' => Encryption::encode($tokenString)
            );

        }else{
            $this->response = array('status' => 'forbidden');
        }
    }

    private function validateToken($token, $name){
        $tokenFragments = explode('*', Encryption::decode($token) );
        $tokenName = $tokenFragments[0];
        $tokenTimeStamp = $tokenFragments[1];
        if($tokenName == $name){
            return true;
        }else{
            return false;
        }
    }

    private function setMessage(){
        $this->to = $this->config['to'];
        $this->from = $this->config['from'];
        $this->replyTo = $this->config['replyTo'];
        $this->subject = $this->config['subject'];
        $this->inputData = $this->sanitizeInputs($this->config['inputs']);
        if($this->inputData){
            $validToken = $this->validateToken($this->inputData['token'], $this->inputData['name']);
            if($validToken){
                $this->sendMessage();
            }else{
                $this->response = array(
                    'status' => 'failed',
                    'title' => 'Token Invalida',
                    'description' => 'Tu sesión expiro, intentalo nuevamente'
                );
            }

        }else{
            $this->response = array(
                'status' => 'failed',
                'title' => 'Ups',
                'description' => 'No llenaste todos los campos, intentalo otra vez'
            );
        }
    }

    function sanitizeInputs($inputs){
        $sanitizedValues = array();
        foreach($inputs as $inputName => $inputData){
            $sanitizedValues[$inputName] = sanitize($inputData['value'], $inputData['filter']);

            $required = ( isset($inputData['notRequired'] )) ? false : true;
            if($sanitizedValues[$inputName] == '' and $required){
                return false;
            }
        }
        return $sanitizedValues;
    }

    private function setMsgBody(){
        $body =
            "<p>Te han enviado un mensaje desde tu web, revisa aqui tu mensaje:</p>
            <p><strong>Nombre:</strong> {$this->inputData['name']}</p>
            <p><strong>Correo:</strong> {$this->inputData['email']}</p>
            <p><strong>Asunto:</strong> {$this->inputData['topic']}</p>
            <p><strong>Message:</strong>{$this->inputData['msg']}";

        return $body;
    }

    private function setHeaders(){
        $headers[] =  "From: {$this->from[0]} <{$this->from[1]}/>";
        $headers[] = 'Reply-To: {$this->replyTo}';
        $headers[] = 'Content-type: text/html';
        return $headers;
    }

    private function sendMessage(){
        $headers = $this->setHeaders();
        $body = $this->setMsgBody();

        if(wp_mail($this->to, $this->subject, $body, $headers)){
            $this->response = array(
                'status' => 'success',
                'title' => 'Gracias',
                'description' => 'Tu mensaje fue enviado con exito'
            );
        }else{
            $this->response = array(
                'status' => 'failed',
                'title' => 'Lo sentimos',
                'description' => 'El mensaje no pudo ser enviado, intenta nuevamente'
            );
        }
    }

}

