use strict;
use warnings;

require './common.pl';

# Read data from file
my @data = readFile('day01-input.txt');

# Find first and last digit of each line
my @digits = map { firstDigit($_) . lastDigit($_) } @data;

# Print the sum
my $sum = arraySum(@digits);
print "Sum: $sum\n";
