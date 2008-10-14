<?
// Load: http://code.google.com/p/oauth-php/
require_once('oauth-php-r50/library/OAuthStore.php');
require_once('oauth-php-r50/library/OAuthRequester.php');
require_once('config.inc.php');

// Request parameters are oauth_token, consumer_key and usr_id.
$oauth_token = $_GET['oauth_token'];

try
{
    OAuthRequester::requestAccessToken($consumer_key, $oauth_token, $user_id);
}
catch (OAuthException $e)
{
    // Something wrong with the oauth_token.
    // Could be:
    // 1. Was already ok
    // 2. We were not authorized
    print('error!');
    print_r($e);
}

header('Location: index.php');
exit();

?>