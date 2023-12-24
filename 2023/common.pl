use strict;
use warnings;

sub assert {
    die "Assertion failed!" unless $_[0];
}

# Read all lines from a file and return an array.
sub readFile {
    # Take first argument
    my $name = shift;

    open(my $file, '<', $name) or die "Unable to read file!";
    my @lines = <$file>;
    close $file;

    # Remove trailing newline from lines
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

# Same as firstDigit but includes words like
# 'one', 'two', and so on.
sub firstDigitWords {
    my $str = shift;

    my %digits = (
        '0' => 0,
        '1' => 1,
        '2' => 2,
        '3' => 3,
        '4' => 4,
        '5' => 5,
        '6' => 6,
        '7' => 7,
        '8' => 8,
        '9' => 9,
        'one' => 1,
        'two' => 2,
        'three' => 3,
        'four' => 4,
        'five' => 5,
        'six' => 6,
        'seven' => 7,
        'eight' => 8,
        'nine' => 9,
    );

    my @keys = keys %digits;
    my @indexes = map { index($str, $_) } @keys;
    my $key = arrayMinKeyPos(@indexes);

    if ($key >= 0) {
        return $digits{$key};
    }

    return;
}

# Calculate the sum of numbers in an array.
sub arraySum {
    my $sum = 0;

    foreach (@_) {
        $sum += $_;
    }

    return $sum;
}

# Print array
sub arrayPrint {
    foreach (@_) {
        print "$_\n";
    }
}

# Max of array values
sub arrayMax {
    my $key = arrayMaxKey(@_);

    if ($key >= 0) {
        return $_[$key];
    }

    return;
}

# Min of array values
sub arrayMin {
    my $key = arrayMinKey(@_);

    if ($key >= 0) {
        return $_[$key];
    }

    return;
}

# Return array key with largest value
sub arrayMaxKey {
    my $key = -1;
    my $val;

    for (my $i = 0; $i < @_; $i++) {
        my $v = $_[$i];

        if ($i == 0 || $v > $val) {
            $key = $i;
            $val = $v;
        }
    }

    return $key;
}

# Return array key with smallest value
sub arrayMinKey {
    my $key = -1;
    my $val;

    for (my $i = 0; $i < @_; $i++) {
        my $v = $_[$i];

        if ($i == 0 || $v < $val) {
            $key = $i;
            $val = $v;
        }
    }

    return $key;
}

# Same as arrayMinKey, but ignore < 0 values
sub arrayMinKeyPos {
    my $key = -1;
    my $val;

    for (my $i = 0; $i < @_; $i++) {
        my $v = $_[$i];

        if ($v >= 0 && ($key < 0 || $v < $val)) {
            $key = $i;
            $val = $v;
        }
    }

    return $key;
}

# Apparently Perl files need to finish with truthy value
# when included from other files.
1;
