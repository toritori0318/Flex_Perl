package AmfTest::Web::Controller::Amf;

use strict;
use warnings;
use AmfTest::Web::Service::Emp;
use base 'Catalyst::Controller::FlashRemoting';
use Data::Dumper;

sub gateway :Local :AMFGateway { }


sub echo :AMFMethod {
    my ($self, $c, $args) = @_;
    return $args;
}

sub sum :AMFMethod {
    my ($self, $c, $args) = @_;
    return List::Util::sum( @{ $args } );
}

sub dump :AMFMethod  {
    use YAML;
    warn Dump $_[0];
}
 
sub list :AMFMethod {
    my ($self, $c, $args) = @_;
    my $hash = $$args[0];
    my $api = AmfTest::Web::Service::Emp->new();
    return $api->getEmp($c->model('DB::Emp'), $hash);
}

1;
