<?
// Load: http://code.google.com/p/oauth-php/
require_once('oauth-php-r50/library/OAuthStore.php');
require_once('oauth-php-r50/library/OAuthRequester.php');
require_once('config.inc.php');

// Obtain a request token from the server
$token = OAuthRequester::requestRequestToken($consumer_key, $user_id);

// Callback to our (consumer) site, will be called when the user finished the authorization at the server
$callback_uri = 'http://php.faith04/callback.php?consumer_key='.rawurlencode($consumer_key).'&user_id='.intval($user_id);

// Now redirect to the autorization uri and get us authorized
if (!empty($token['authorize_uri']))
{
    // Redirect to the server, add a callback to our server
    if (strpos($token['authorize_uri'], '?'))
    {
        $uri = $token['authorize_uri'] . '&'; 
    }
    else
    {
        $uri = $token['authorize_uri'] . '?'; 
    }
    $uri .= 'oauth_token='.rawurlencode($token['token']).'&oauth_callback='.rawurlencode($callback_uri);
}
else
{
    // No authorization uri, assume we are authorized, exchange request token for access token
   $uri = $callback_uri . '&oauth_token='.rawurlencode($token['token']);
}

header('Location: '.$uri);
exit();

?>