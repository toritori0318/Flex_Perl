package AmfTestDBIx::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_classes;
__PACKAGE__->connection(
    'dbi:Pg:dbname=test;host=localhost',
    'postgres',
    '',
    { AutoCommit => 0 } );


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-03 23:36:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:daMfUJRYCrplvTiPZE84Dw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
