package AmfTest::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use Data::Dumper;
use URI::Escape;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

AmfTest::Web::Controller::Root - Root Controller for AmfTest::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

sub default : Path {
    my ( $self, $c ) = @_;
    $c->response->body('Page not found');
    $c->response->status(404);
}

sub gateway : Local {
    my ( $self, $c ) = @_;
    $c->forward('/amf/gateway');
}

sub json : Local {
    my ( $self, $c ) = @_;
    my $qq = cnv_hash( $c->req->uri->query )
      if $c->req->uri->query;

    use AmfTest::Web::Service::Emp;
    my $api = AmfTest::Web::Service::Emp->new();

    #$c->log->info(Dumper($api->getEmp( $c->model('DB::Emp'), $qq )));
    #$c->stash = [$api->getEmp( $c->model('DB::Emp'), $qq )];
    #$c->response->body($api->getEmp( $c->model('DB::Emp'), $qq ));
    $c->stash->{response} = $api->getEmp( $c->model('DB::Emp'), $qq );
    $c->forward( $c->view('JSON') );
}

sub xml : Local {
    my ( $self, $c ) = @_;
    my $qq = cnv_hash( $c->req->uri->query )
      if $c->req->uri->query;

    $c->response->headers->content_type('text/xml');

    use XML::Simple;
    use AmfTest::Web::Service::Emp;
    my $api = AmfTest::Web::Service::Emp->new();
    $c->stash->{xml} = $api->getEmp( $c->model('DB::Emp'), $qq );
    $c->forward( $c->view('XML') );

#    my $emp = $api->getEmp( $c->model('DB::Emp'), $qq );
#    if ( @$emp > 0 ) {
#        my $emp_rec = { record => $emp };
#        $c->response->output(
#            XMLout $emp_rec,
#            RootName => 'Result',
#            NoAttr   => 1
#        );
#    }
#    else {
#        $c->response->output("<Result><record></record></Result>");
#    }
}

sub cnv_hash {
    my $qs    = shift;
    my %ret   = ();
    my @pairs = split( /&/, $qs );
    foreach my $pair (@pairs) {
        my ( $name, $value ) = split( /=/, $pair );
        $ret{ uri_unescape($name) } = uri_unescape($value);
    }
    return \%ret;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub render : ActionClass('RenderView') {
}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
