use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'PerlOAuthTest' }
BEGIN { use_ok 'PerlOAuthTest::Controller::Sentences' }

ok( request('/sentences')->is_success, 'Request should succeed' );


