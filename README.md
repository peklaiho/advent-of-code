# Advent of Code

Puzzle solutions for [Advent of Code](https://adventofcode.com/).

## 2022

The code for 2022 is in [this repo](https://bitbucket.org/maddy83/misc-scheme/src/master/advent-of-code/), written in Scheme.

## 2023

For this year I am using [Perl](https://www.perl.org/) language.

### Installing modules for Perl

Here is [related instructions](https://www.cpan.org/modules/INSTALL.html).

First use `cpan` to install `cpanm`:

    $ cpan App::cpanminus

I did not add cpanm to PATH, so it went to `~/perl5/bin`. Use it to install the Path::Tiny module:

    $ ~/perl5/bin/cpanm Path::Tiny

The module was installed also under `~/perl5`, but that is not included in Perl's include directories, so received this error:

    Can't locate Path/Tiny.pm in @INC (you may need to install the Path::Tiny module) (@INC entries checked: ... )

The solution was to define a `PERL5LIB` environment variable:

    $ export PERL5LIB=/home/pekka/perl5/lib/perl5
