use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'AmfTestDBIx',
    license             => 'perl',
    dist_author         => 'tsuyoshi torii <toritori0318@gmail.com>',
    dist_version_from   => 'lib/AmfTestDBIx.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'AmfTestDBIx-*' ],
);

$builder->create_build_script();
