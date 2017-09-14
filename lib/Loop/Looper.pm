package Loop::Looper;

use Moose;
use Loop::Random::Randomizer qw( randomize_string randomize_numbers );

my $randomizer = Loop::Random::Randomizer->new;
my @chars  = ("A".."Z", "a".."z");
my @nrs    = ("0".."9");

sub randomlooper {
    my $randomchars = $randomizer->randomize_string(\@chars, 8);
    my $randomnrs   = $randomizer->randomize_numbers(\@nrs, 8);

    my $randomstring = $randomchars.$randomnrs;
    return $randomstring;
}

1;
