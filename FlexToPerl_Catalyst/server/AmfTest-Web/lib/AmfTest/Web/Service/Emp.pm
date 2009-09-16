package AmfTest::Web::Service::Emp;
use strict;
use AmfTest::Web::Schema;
use DBIx::Class::AsFdat;

sub new {
  return bless {}, shift;
}

sub getEmp {
  my ($self, $resultset, $args) =@_;
    $args = +{ map { ( $_, '%' . $args->{$_} . '%' ) } keys %$args };
    my $schema = AmfTest::Web::Schema->connect;
    my @rs = map { $_->as_fdat } $resultset->search({ 'emp_name' => { like => $$args{emp_name} }});
    return \@rs;
}

1;


