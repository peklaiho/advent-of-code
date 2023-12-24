use strict;
use warnings;

require './common.pl';

my @a = (3, 5, 2, 7, 1, 8, 4);

assert(arrayMin(@a) == 1);
assert(arrayMax(@a) == 8);

assert(arrayMinKey(@a) == 4);
assert(arrayMaxKey(@a) == 5);

print "Ok!\n";
