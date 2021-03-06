package AmfTestDBIx::Schema::Emp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
          "AsFdat",
          "PK::Auto",
          "Core",
);
__PACKAGE__->table("emp");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "emp_no",
  { data_type => "integer", default_value => undef, is_nullable => 0, size => 4 },
  "emp_name",
  {
    data_type => "character varying",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "mgr_id",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "hiredate",
  { data_type => "date", default_value => undef, is_nullable => 1, size => 4 },
  "sal",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "dept_id",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "version_no",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-09-03 23:36:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zodSpAu+iOg7NWEP4Akulg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
