# Advent of Code 2022

The 2022 puzzles are in [Scheme](https://www.scheme.org/) language.

## Day 1: Calorie Counting

Group lines of strings separated by one empty line. Then count the sums of the values.

Example input:

```
1000
2000
3000

4000

5000
6000
```

## Day 2: Rock Paper Scissors

Parse the "strategy" of a Rock, Paper and Scissors game and sum the resulting scores.

Example input:

```
A Y
B X
C Z
```

## Day 3: Rucksack Reorganization

For each line of input, first split the input in half into two substrings. Then find which character is present in both substrings.

Example input:

```
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
```

* The first rucksack contains the items vJrwpWtwJgWrhcsFMMfFFhFp, which means its first compartment contains the items vJrwpWtwJgWr, while the second compartment contains the items hcsFMMfFFhFp. The only item type that appears in both compartments is lowercase p.
* The second rucksack's compartments contain jqHRNqRjqzjGDLGL and rsFMfFZSrLrFZsSL. The only item type that appears in both compartments is uppercase L.

## Day 4: Camp Cleanup

Find overlaps of two ranges. Part 1 asks how many pairs of ranges fully contain each other. Part 2 asks how many pairs of ranges overlap at all.

Example input:

```
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
```

## Day 5: Supply Stacks

A cargo crane that moves crates between multiple stacks. This was a perfect example of how to use the stack datatype. The crane moves one crate at a time in part 1 and multiple crates at a time in part 2.

Example input:

```
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
```

## Day 6: Tuning Trouble

Find the position in a string that contains n unique characters in a row.

Example input:

```
mjqjpqmgbljsphdztnvjfqwrcgsmlb
```

Find the position of first 4 unique characters. In this example the first 4 unique characters are `jpqm`, after the 7th character. So the result from this string should be 7.

## Day 7: No Space Left On Device

This problem simulates Unix filesystem and the related commands such as `ls`, `cd` and so forth. The final value is created from counting directory sizes. I used hash-tables for the solution, so this is a good example of that.

Example input:

```
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
```

## Day 8: Treetop Tree House

Skipped this.

## Day 9: Rope Bridge

Skipped this.

## Day 10: Cathode-Ray Tube

Simulate a simple CPU with two instructions: `noop` and `addx`. Store a register value for each CPU cycle in part 1. Use the stored values in part 2 to simulate a CRT screen and drawing text on it.

Example input:

```
noop
addx 3
addx -5
```

## Day 11: Monkey in the Middle

Skipped this.

## Day 12: Hill Climbing Algorithm

Skipped this.

## Day 13: Distress Signal
