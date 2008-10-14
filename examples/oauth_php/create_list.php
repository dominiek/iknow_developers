<?
// Load: http://code.google.com/p/oauth-php/
require_once('oauth-php-r50/library/OAuthStore.php');
require_once('oauth-php-r50/library/OAuthRequester.php');
require_once('config.inc.php');

// The request uri being called.
$request_uri = 'http://api.iknow.co.jp/lists';

// This is a little bit silly, I know, my PHP friends
$params = array(
  'list[name]' => $_POST['list']['name'], 
  'list[language]' => $_POST['list']['language'],
  'list[translation_language]' => $_POST['list']['translation_language']
);
  
// Obtain a request object for the request we want to make
$req = new OAuthRequester($request_uri, 'POST', $params);

// Sign the request, perform a curl request and return the results, throws OAuthException exception on an error
$result = $req->doRequest($user_id);

// $result is an array of the form: array ('code'=>int, 'headers'=>array(), 'body'=>string)

?>
Yeey! List created. Great success!