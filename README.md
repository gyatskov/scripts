# Overview #
This repo contains scripts created for different use-cases that came up during software development.

It collects different kinds of utilities and is more like a reference/toolset than a user-friendly,
integrated application.

# Goals #
## Portability ##
Since `bash` is the greatest common divisor of most Linux-based development systems, all of the scripts
provided here are written in bash.

The scripts provided here do not aim for POSIX compliance of any sort; they are supposed to work on
"most modern Linux" systems and have been mainly tested on Ubuntu setups.

While Python or Ruby are modern approaches, their minimum installations can be regarded as
"more" than just bash.

## Modularity ##
Each of the scripts shall get one task done and be testable and provide some value on its own.
Without too much effort, each of these scripts can be integrated into more elaborate environments
(Makefiles, Visual Studio Code Tasks, external scripts, etc.)

# Points to be improved #
* Robustness by
    * not relying on absolute paths
    * not relying on environment variables
    * apply general best practices of error handling

* Usability by
    * using better arguments
    * offering usage help and examples
    * providing configuration templates (as already done for [./gerrit](./gerrit) and [./jenkins](./jenkins))


# Notes #
Some of these scripts were taken from or heavily influenced by StackOverflow articles.
References to the respective forum entries are inserted in each of the scripts, otherwise
an issue/e-mail can be issues at any time.
