# Instructor notes

## Things to bring

+ Yubikeys.
+ Water bottle.
+ Adapter for connecting to projector.
+ Power cord for laptop.
+ Printout of slides with notes.

## Instructor in-class setup

+ Arrange chairs and tables, if necessary.
+ Clean up Desktop and quit applications (particularly Slack).
+ Download fresh copy of git repository.
+ Download fresh copy of data files.
+ Test reservation.
+ Use Terminal, not iTerm.
+ Use Basic Terminal theme (with Consolas font).
+ Fix midway2 prompt.
+ Arrange PDF of slides and R on screen.
+ Distribute Yubikeys.

```bash
scontrol create reservation=workshop users=-runesha \
  starttime=2019-11-19T13:00:00 duration=5:00:00 \
  partitionname=broadwl nodecnt=10
sinteractive -p broadwl --reservation=workshop
```
