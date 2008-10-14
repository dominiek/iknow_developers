<?
/*
  Apologies for my horrible PHP coding, haven't done this in a while.
  Most of this code is modified from: http://code.google.com/p/oauth-php/wiki/ConsumerHowTo
  - Dominiek
 */
// Load: http://code.google.com/p/oauth-php/
require_once('oauth-php-r50/library/OAuthStore.php');
require_once('oauth-php-r50/library/OAuthRequester.php');
require_once('config.inc.php');
  
?>
<h1>Create a list on iKnow!</h1>
<? if (count($store->listServerTokens($user_id)) > 0) { ?>
  <form action="create_list.php" method="post">
    <p><label>name </label><input type="text" name="list[name]"/></p>
    <p><label>from language </label><input type="text" name="list[language]" value="ja"/></p>
    <p><label>to language </label><input type="text" name="list[translation_language]" value="en"/></p>
    <input type="submit" name="commit" value="save">
  </form>
<? } else { ?>
  <p>Please <a href="authenticate.php">authenticate with iKnow!</a> in order to create a list</p>
<? } ?>