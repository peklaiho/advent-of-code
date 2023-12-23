use strict;
use warnings;

use Path::Tiny;
use autodie;

# https://learn.perl.org/examples/read_write_file.html
sub readFile {
    # shift returns the first element from list, and without
    # arguments that list is $_ that contains the function arguments
    # individual arguments can be accessed as $_[0], $_[1], and so on
    my $name = shift;

    my $dir = path('.');
    my $file = $dir->child($name);
    return $file->lines;
}

# Return the first digit from a string
sub firstDigit {
    my $str = shift;

    foreach (split('', $str)) {
        my $v = ord($_);
        if ($v >= 48 && $v <= 57) {
            return $_;
        }
    }

    return;
}

sub lastDigit {
    return firstDigit reverse $_;
}

sub arraySum {
    my @list = shift
    my $sum = 0;

    foreach (@list) {
        $sum += $_;
    }

    return $sum;
}

# Apparently Perl files need to finish with truthy value
# when included from other files.
1;
