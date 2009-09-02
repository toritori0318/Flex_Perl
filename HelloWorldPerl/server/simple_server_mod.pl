#!/usr/bin/env perl

use strict;
use warnings;
use FindBin::libs;
use Data::AMF::Packet;
use List::Util ();
use Path::Class;
use Data::Dumper;

use HTTP::Engine;

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

1;
