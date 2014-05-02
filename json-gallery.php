<?php
/*
 * Template Name: Json-Gallery
 */

$page = (isset($page)) ? $page : $_REQUEST['page'];

header('content-type: application/json; charset=ISO-8859-1');

$galleries = getGalleries('musical', 2, $page, true);

echo '<pre>';
print_r($galleries);
echo '</pre>';

//echo json_encode($galleries);