use strict;
use warnings;

require './common.pl';

# Read data from file
my @data = readFile('day01-example.txt');

# Find first and last digit of each line
my @digits = map { firstDigit($_) . lastDigit($_) } @data;

print arraySum(@digits);
