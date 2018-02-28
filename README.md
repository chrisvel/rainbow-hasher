## Rainbow Hasher

> This project was an experiment in Ruby while I was trying to find out how fast can I create
> a file with a permutations list including letters & numbers and a specific string length.

### Current status
* _StandBy_

#### Features

* Displays time running
* How many hashes have been generated and how many are left
* Hashes amount generated in last second
* Average of hashes generated per second
* Estimated time left to complete

#### Screenshot

![Screenshot Running Command](/screenshots/screenshot_1.png?raw=true "Running command screenshot")

### Install & Configuration

1. `Bundle install`
2. Edit main settings inside file of `main.rb`
3. Execute `ruby main.rb` and wait.

### How to Use?

**a. Configure Settings**

I will add comments when it's possible. Until then, `rs = Rainsolver.new("a", "z", 0, 9, 4)`
means that you want all possible and unique permutations including all alphabet
letters between "a" and "z", plus all numbers between 0 and 9 to create strings
of length 4.
