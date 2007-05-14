use Test::More;

use strict;
use warnings;

BEGIN {
	eval "use Image::Compare";
	plan skip_all => "Image::Compare required" if $@;
	plan tests => 8;

    use_ok( 'Imager' );
    use_ok( 'Imager::Scale2x' );
}

my $image1x = Imager->new;
$image1x->read( file => 't/mslug2-1.png' );

{
    my $image2x = Imager->new;
    $image2x->read( file =>  't/mslug2-2.png' );

    my $scaled2x = $image1x->scale2x;
    isa_ok( $scaled2x, 'Imager' );

    my $cmp = Image::Compare->new( image1 => $image2x, image2 => $scaled2x, method => &Image::Compare::EXACT );
    ok( $cmp->compare, 'scale2x' );
}

{
    my $image3x = Imager->new;
    $image3x->read( file =>  't/mslug2-3.png' );

    my $scaled3x = $image1x->scale3x;
    isa_ok( $scaled3x, 'Imager' );

    my $cmp = Image::Compare->new( image1 => $image3x, image2 => $scaled3x, method => &Image::Compare::EXACT );
    ok( $cmp->compare, 'scale3x' );
}

{
    my $image4x = Imager->new;
    $image4x->read( file =>  't/mslug2-4.png' );

    my $scaled4x = $image1x->scale4x;
    isa_ok( $scaled4x, 'Imager' );

    my $cmp = Image::Compare->new( image1 => $image4x, image2 => $scaled4x, method => &Image::Compare::EXACT );
    ok( $cmp->compare, 'scale4x' );
}

