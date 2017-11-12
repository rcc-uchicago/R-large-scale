# Instructor notes

* Slides:
    - Title (with github repo URL)
    - Aims
	- Outline (divided into X parts)
	- Prerequisities (my expectations)

## Pre-workshop email

+ Prerequisites.
+ Add your name & program to Etherpad.
+ Make sure you can connect to midway2 (ssh or ThinLinc).
+ Make sure you can transfer files (scp or SAMBA).
+ Make sure you are comfortable using a text-based editor such as vim,
  emacs or nano (recommended).
+ We will use R---not RStudio.
+ Mention workshop packet (but do not distribute link).

## Instructor in-class setup

+ Clean up Desktop.
+ Use Terminal, not iTerm.
+ Use a font that better distinguishes commas and periods.
+ Distribute Yubikeys.

## Initial in-class setup

+ Give instructions for Yubikeys (if necessary).
+ WiFi.
+ Etherpad.
+ Connecting to midway2.

## Part 1: (Title goes here)

Create two sessions on midway2: one for loading up an R environment,
and a second for developing code (e.g., in emacs).

Create an interactive session for 2 hours on midway2. It is useful to
create a screen session in case you lose your connection at any
point. *Also motivate use of sinteractive by running htop on login
node.*

```bash
screen -S workshop
sinteractive --partition=broadwl --time=2:00:00 --reservation=rworkshop
module load R/3.4.1
R
```

Develop script `pca.regmap.R` from scratch, while trying out code
interactively in R.

## Part 2: 

## Other notes

+ See here about reasons to use Rscript:
  https://tinyurl.com/y73cnf38
