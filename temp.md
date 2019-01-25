## Getting started

1. Download or clone this repository on the RCC cluster.

2. Optionally, add the bash commands found [here](add_to_bashrc) to
   your `~/.bashrc` file (see
   [here](https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work)
   for an explanation of the `.bashrc` file and what it is for. These
   commands will give you more informative output from running
   `squeue` and `sacct`.

3. Request a compute node on the RCC cluster.

   ```bash
   screen -S rcc_workshop
   sinteractive --partition=broadwl --time=2:00:00
   echo $HOSTNAME
   ```

4. Start up the R programming environment, 

   ```bash
   module load R/3.4.1
   R
   ```

5. Make sure that your R working directory is the code
   subdirectory in this repository:

   ```R
   getwd()
   # [1] "/home/pcarbo/git/R-large-scale/code"
   ```

