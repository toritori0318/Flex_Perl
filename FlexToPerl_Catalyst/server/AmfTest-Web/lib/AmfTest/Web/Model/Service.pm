package AmfTest::Web::Model::Service;
use base 'Catalyst::Model::MultiAdaptor';
__PACKAGE__->config( 
    package => 'AmfTest::Web::Service',
);

1;
