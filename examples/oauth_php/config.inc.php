<?

// Get the id of the current user (must be an int)
$user_id = 1;

// The server description
$server = array(
    'consumer_key' => 'ZxPXCNRM9mGzv8K3m6NOg',
    'consumer_secret' => 'R1Ee8nGp7WBxmp3ivMiYbzcNwtLjouIvOpMPlK38',
    'server_uri' => 'http://faith04.cerego.co.jp:3500/',
    'signature_methods' => array('HMAC-SHA1', 'PLAINTEXT'),
    'request_token_uri' => 'http://faith04.cerego.co.jp:3500/oauth/request_token',
    'authorize_uri' => 'http://faith04.cerego.co.jp/oauth/authorize',
    'access_token_uri' => 'http://faith04.cerego.co.jp:3500/oauth/access_token'
);

// Save the server in the the OAuthStore
$store = OAuthStore::instance('MySQL', array('username' => 'root', 'server' => 'localhost', 'database' => 'oauth_php'));
$servers = $store->listServers('', $user_id);

if(count($servers) == 0) {
  $consumer_key = $store->updateServer($server, $user_id);
} else {
  $consumer_key = $servers[0]['consumer_key'];
}

?>