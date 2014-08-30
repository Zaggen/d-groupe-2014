<?php
/*
 * Template Name: Json-Gallery
 */

$page = (isset($page)) ? $page : $_REQUEST['page'];
$postSlug = $_REQUEST['from'] ?: '';

header('content-type: application/json; charset=ISO-8859-1');

$galConf = array(
    'from' => $postSlug,
    'imgPerPage' => 18,
    'page' => 1,
    'getPageQ' => true
);

$galleryPage = getGalleryPage($galConf);


echo json_encode($galleryPage);