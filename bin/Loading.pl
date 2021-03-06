#!/usr/bin/env perl
use strict;
use warnings;

use lib 'lib';

use Time::HiRes qw( sleep );
use Term::ReadKey;
use DBIx::Class;
use Loop::Looper;
use Loop::Random::Sorter;
use Loop::Schema;

my $generator = Loop::Looper->new;
my $sorter    = Loop::Random::Sorter->new;

print "Enter desired number of randomized strings:\n";
my $count_input = <STDIN>;
print "\nWould you like to sort the strings by numerics? (y/n)\n";
my $sort_input = <STDIN>;

my $key;
my $i=0;
my @load  = qw( / - \ | );
my @randomized;

ReadMode 4;

while ( ( scalar @randomized < $count_input ) && (!defined ($key = ReadKey(-1)))) {
    my $seconds = $i/10;
    printf "Loading... $load[$i % 4] for %.1f seconds... The current time is: %d\r", $seconds, time;

    push @randomized, $generator->randomgenerator;

    sleep 0.1;
    $i++;
}

ReadMode 0;

my @sorted = $sorter->sort_strings(@randomized);

print "\nGenerated ", scalar @randomized, " randomized strings.\n";
if ($sort_input =~ /^y/i) {
    print "\nSorted by numerics:\n".join ("\n", @sorted)."\n\n";
}
else {
    print "\nRandomized strings:\n".join ("\n", @randomized)."\n"
}



#Writing the strings plus date to the database
my $schema = Loop::Schema->connect('dbi:SQLite:db/randomized_strings.db');
my $now = time;

$schema->resultset('RandomString')->populate([
    [ qw( string epoch_time ) ],
    map { [ $_, $now ] } @sorted,
]);



#Find a lucky string and mark it
my $lucky_string = $schema->resultset('RandomString')->search(
    { string => { -like => '%777%' } },
);

if ($lucky_string) {print "We've got " . $lucky_string . " lucky strings so far.\n"};
$lucky_string->update_all({ lucky => 'slevin' });
