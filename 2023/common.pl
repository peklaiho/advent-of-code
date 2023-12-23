use strict;
use warnings;

# Read all lines from a file and return
# an array. Remove trailing newline.
sub readFile {
    # Take first argument
    my $name = shift;

    open(my $file, '<', $name) or die "Unable to read file!";
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

sub replaceWordWithDigit {
    my $result = shift;

    $result =~ s/one/1/g;
    $result =~ s/two/2/g;
    $result =~ s/three/3/g;
    $result =~ s/four/4/g;
    $result =~ s/five/5/g;
    $result =~ s/six/6/g;
    $result =~ s/seven/7/g;
    $result =~ s/eight/8/g;
    $result =~ s/nine/9/g;

    return $result;
}

# Apparently Perl files need to finish with truthy value
# when included from other files.
1;
