use strict;

use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Imager::Scale2x',
    dist_author        => 'Brian Cassidy <bricas@cpan.org>',
    license            => 'perl',
    create_readme      => 1,
    create_makefile_pl => 'traditional',
    requires           => {
        'Imager'             => 0,
        'Algorithm::Scale2x' => 0
    },
    build_requires     => {
        'Test::More'  => 0
    },
);
$build->create_build_script;
