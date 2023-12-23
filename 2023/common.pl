use strict;
use warnings;

# Read all lines from a file and return
# an array. Remove trailing newline.
sub readFile {
    # Take first argument
    my $name = shift;

    open(my $file, '<', $name);
    my @lines = <$file>;
    close $file;

    return map { substr($_, 0, -1) } @lines;
}

# Return the first digit from a string.
sub firstDigit {
    my $str = shift;

    foreach (split('', $str)) {
        my $v = ord;
        if ($v >= 48 && $v <= 57) {
            return $_;
        }
    }

    return;
}

# Return last digit from a string.
sub lastDigit {
    return firstDigit scalar reverse;
}

# Calculate the sum of numbers in an array.
sub arraySum {
    my $sum = 0;

    foreach (@_) {
        $sum += $_;
    }

    return $sum;
}

# Apparently Perl files need to finish with truthy value
# when included from other files.
1;
