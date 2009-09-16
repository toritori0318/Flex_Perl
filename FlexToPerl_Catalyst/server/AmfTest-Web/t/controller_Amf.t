use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'AmfTest::Web' }
BEGIN { use_ok 'AmfTest::Web::Controller::Amf' }

ok( request('/amf')->is_success, 'Request should succeed' );


