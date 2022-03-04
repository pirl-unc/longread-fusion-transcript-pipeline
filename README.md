This repository is a collection of modules written in bash that are used to run the simulated longread fusion transcript detector.

Each module contains two files (e.g. badread.sh and badread_helper.sh). The "helper" file contains the main commands of the tool, while the "regular" file simply contains code to run it a certain number of times on lbg's SLURM.

These files are currently not going to work out of the box as many of the commands are specific for my user configuration. It's purpose is to show which commands are being fed into the tools and for general version control.
