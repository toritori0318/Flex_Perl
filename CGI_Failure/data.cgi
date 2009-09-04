#!/usr/bin/perl

BEGIN{
   unshift(@INC, "/home/toritori0318/AmfTestDBIx/lib");
}


use warnings;
use strict;
use Data::Dumper;
use Encode qw/ from_to /;
use CGI qw/:standard -debug/;
#use CGI;


#use lib '/home/toritori0318/AmfTestDBIx/lib';
use AmfTestDBIx::Schema;
use DBIx::Class::AsFdat;

sub getEmp {
    my $schema = AmfTestDBIx::Schema->connect;
    my @rs = map { $_->as_fdat } $schema->resultset('Emp')->search;
    return \@rs;
}

{
    my $q = CGI->new;

    if ( $q->param('type') eq 'json' ) {
        use JSON;
        print $q->header('application/xhtml+xml');
        print to_json(&getEmp());
    }
    elsif ( $q->param('type') eq 'xml' ) {
        use XML::Simple;
        my $xml = new XML::Simple;
        print $q->header('application/xhtml+xml');
        print '<?xml version="1.0" encoding="utf-8" ?>\n';
        print XMLout(&getEmp(), NoAttr => 1);
    }
    elsif ( $q->param('type') eq 'amf' ) {
        use Data::AMF;
        my $amf0 = Data::AMF->new( version => 0 );
        print $q->header('application/x-amf');
        print $amf0->serialize(&getEmp());
    }
    elsif ( $q->param('type') eq 'amf3' ) {
        use Storable::AMF0 qw(freeze thaw);
        print $q->header('application/x-amf');
        print freeze(&getEmp());
    }
}

1;
