package AmfTest::Web::View::XML;

use strict;
use base 'Catalyst::View';
use XML::Simple;
use Data::Dumper;

sub process {
    my ( $self, $c ) = @_;
    $c->response->headers->content_type('text/xml');

    my $xml = $c->stash->{xml};
    if(@$xml > 0){
        my $emp_rec = { record => $xml };
        $c->response->output(
            XMLout $emp_rec,
            RootName => 'Result',
            NoAttr   => 1
        );
    }
    else {
        $c->response->output("<Result><record></record></Result>");
    }

    return 1;
}

1;

