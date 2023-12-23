use strict;
use warnings;

require './common.pl';

# Read data from file
my @data = readFile('day01-input.txt');

# Find first and last digit of each line
my @digits = map { firstDigit($_) . lastDigit($_) } @data;

# Print the sum
my $sum = arraySum(@digits);
print "Part 1: $sum\n";

# Part 2: replace 'one' with 1, and so on
@data = readFile('day01-example2.txt');

my @data2 = map { replaceWordWithDigit($_) } @data;

@digits = map { firstDigit($_) . lastDigit($_) } @data2;


foreach (@digits) {
    print "$_\n";
}

$sum = arraySum(@digits);
print "Part 2: $sum\n";

