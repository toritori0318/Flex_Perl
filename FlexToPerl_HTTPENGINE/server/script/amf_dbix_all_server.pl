#!/usr/bin/perl

use strict;
use warnings;

use HTTP::Engine;
use Data::AMF::Packet;

use List::Util ();
use FindBin::libs;
use Path::Class;
use URI::Escape;
use Data::Dumper;


use lib '/home/toritori0318/AmfTestDBIx/lib';
use AmfTestDBIx::Schema;
use DBIx::Class::AsFdat;

sub getEmp {
    my $prm = shift;
    $prm = +{ map { ( $_, '%' . $prm->{$_} . '%' ) } keys %$prm };
    my $schema = AmfTestDBIx::Schema->connect;
    my @rs = map { $_->as_fdat } $schema->resultset('Emp')->search({ 'emp_name' => { like => $$prm{emp_name} }});
    #my @rs = map { $_->as_fdat } $schema->resultset('Emp')->search_like($prm);
    return \@rs;
}

&main;
exit;

sub main {
    my $engine = HTTP::Engine->new(
        interface => {
            module => 'ServerSimple',
            args   => {
                host => 'localhost',
                port => '3000',
            },
            request_handler => \&handler,
        },
    );
    $engine->run;
}

sub handler {
    my $req = shift;
    my $qq = cnv_hash( $req->uri->query )
      if $req->uri->query;

      if ( $req->uri->path eq '/gateway' ) {
        my $fh = $req->body;
        my $body = do { local $/; <$fh> };

        my $request = Data::AMF::Packet->deserialize($body);

        my @result;
        for my $message ( @{ $request->messages } ) {
            my $method = __PACKAGE__->can( $message->target_uri );

            if ($method) {
                my $result = $method->( $message->value );

                push @result, $message->result($result);
            }
        }

        my $response = Data::AMF::Packet->new(
            version  => $request->version,
            headers  => [],
            messages => \@result,
        );

        return res( 'application/x-amf', $response->serialize );
    }
    elsif ( $req->uri->path eq '/json' ) {
        use JSON;
        return res( 'application/xhtml+xml', to_json( &getEmp( $qq ) ) );
    }
    elsif ( $req->uri->path eq '/xml' ) {
        use XML::Simple;
        my $xml  = new XML::Simple;
        my $body = '<?xml version="1.0" encoding="utf-8" ?>\n';
        my $emp = &getEmp($qq);


        if(@$emp > 0){
            my $emp_rec = {record => $emp};
            $body .= XMLout( $emp_rec, RootName=>'Result', NoAttr => 1 );
        }else{
            $body .= "<Result><record></record></Result>";
        }
        return res( 'application/xhtml+xml', $body );
    }
    else {
        return res( 'application/x-shockwave-flash',
            scalar file('./examples/simple_flash_remoting.swf')->slurp );
    }
}

sub res {
    my ( $content, $body ) = @_;
    HTTP::Engine::Response->new(
        content_type => $content,
        body         => $body
    );
}

sub echo {
    return $_[0];
}

sub sum {
    return List::Util::sum( @{ $_[0] } );
}

sub dump {
    use YAML;
    warn Dump $_[0];
}

sub list {
    my $prm  = shift;
    my $hash = $$prm[0];

    #my %hash = %{ $$prm[0] };
    return getEmp($hash);
}

sub cnv_hash {
    my $qs = shift;
    my %ret = ();
    my @pairs = split( /&/, $qs );
    foreach my $pair (@pairs) {
        my ( $name, $value ) = split( /=/, $pair );
        $ret{uri_unescape($name)} = uri_unescape($value);
    }
    return \%ret;
}
1;
