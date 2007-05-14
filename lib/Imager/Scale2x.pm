package Imager::Scale2x;

use strict;
use warnings;

our $VERSION = '0.01';

package Imager;

use strict;
use warnings;

use Algorithm::Scale2x ();

sub scale2x {
    my $self = shift;

    return $self->_scale( 2, @_ );    
}

sub scale3x {
    my $self = shift;

    return $self->_scale( 3, @_ );    
}

sub scale4x {
    my $self = shift;

    my $image = $self->scale2x( @_ );
    return $image->scale2x;
}

sub _scale {
    my $self     = shift;
    my $scale    = shift;
    my %opts     = @_;
    my $source_x = $opts{ source_x } || 0;
    my $source_y = $opts{ source_y } || 0;
    my $source_w = $opts{ source_w };
    my $source_h = $opts{ source_h };

    unless( $source_w ) {
        ( $source_w, $source_h ) = ( $self->getwidth, $self->getheight );
        $source_w -= $source_x;
        $source_h -= $source_y;
    }

    my $image   = Imager->new( xsize => $source_w * $scale, ysize => $source_h * $scale );
    my $bound_x = $source_w - 1;
    my $bound_y = $source_h - 1;

    for my $y ( $source_y..$bound_y ) {
        for my $x ( $source_x..$bound_x ) {
            my $x_plus  = ( $x + 1 > $bound_x  ? $x : $x + 1 );
            my $x_minus = ( $x - 1 < $source_x ? $x : $x - 1 );
            my $y_plus  = ( $y + 1 > $bound_y  ? $y : $y + 1 );
            my $y_minus = ( $y - 1 < $source_y ? $y : $y - 1 );

            # 0 1 2 #
            # 3 4 5 # 4 => x, y
            # 6 7 8 #

            my @pixels = (
                $self->getpixel( x => $x_minus, y => $y_minus ),
                $self->getpixel( x => $x, y => $y_minus ),
                $self->getpixel( x => $x_plus, y => $y_minus ),
                $self->getpixel( x => $x_minus, y => $y ),
                $self->getpixel( x => $x, y => $y ),
                $self->getpixel( x => $x_plus, y => $y ),
                $self->getpixel( x => $x_minus, y => $y_plus ),
                $self->getpixel( x => $x, y => $y_plus ),
                $self->getpixel( x => $x_plus, y => $y_plus )
            );

            my $code = Algorithm::Scale2x->can( "scale${scale}x" );
            my @E = $code->( @pixels );
            my $scaledx = $x * $scale;
            my $scaledy = $y * $scale;

            for my $y ( 0..$scale - 1 ) {
                for my $x ( 0..$scale - 1 ) {
                    $image->setpixel(
                        x     => $scaledx + $x,
                        y     => $scaledy + $y,
                        color => shift @E
                    );
                }
            }
        }
    }

    return $image;
}

package Imager::Color; 

use overload
    '=='     => sub { shift->equals( other => shift ); },
    '!='     => sub { !shift->equals( other => shift ); },
    fallback => 1;

1;
