Minit
=====
Minit is a [make][2]-based [init][3] system for services.  It's simple and
doesn't do much.

The name rhymes with "in it."

Why
===
I worked with a homebrewed `init` system at Bloomberg that was written mostly
in Perl, and I always wondered whether it could be simplified by leveraging
[make][2] for dependency tracking and parallel job execution.

What
====
`minit` is a script and a set of conventions that allow a system of
interdependent services (processes) to be started and stopped cleanly.

It is similar to, but _not_ an implementation of, the
[Linux Standard Base's init system][1].

`minit` is mostly a Makefile with `start` and `stop` targets, together with
shell script glue for deducing make rules and recipes from a prescribed
directory structure of configurations.

How
===
`minit start` starts all services.  `minit stop` stops all services.

A service is a directory containing two files:

    etc/minit/services/
                       weatherd/
                                init
                                deps

`weatherd` is the name of the service (maybe a daemon that provides weather
forecasts).

`weatherd/init` is an executable that accepts a single command line argument:
either "start" or "stop".
- `init start` starts the service, or does nothing if it's already started.
- `init stop` stops the service, or does nothing if it's already stopped.
- In either case, the script exits with a zero status on success, or a nonzero
  status if an error occurs.

`weatherd/deps` is a file containing the names of all of the services on which
`weatherd` depends, separated by whitespace (including newlines).  For example,
`weatherd/deps` might look like this:

    routerd
    redis
    procmgr
    locationd

or, equivalently, like this:

    routerd redis procmgr locationd

When `weatherd/init start` is executed, its output is written to the two files:

    var/log/minit/$(date --utc +%s.%N).start/weather/{stdout,stderr}

The directory `$(date --utc +%s.%N)` is shared by all services for that
particular invocation of `minit start` (i.e. the name of the directory is
calculated only once per `minit` invocation).  Similarly for `minit stop`.

### Install
`make install` will copy files into the directory tree rooted at `PREFIX`.  If
the `PREFIX` variable is not set, then it defaults to `/usr/local`.  You might
need to run the command with `sudo` if you don't have write permissions under
`PREFIX`.

`make uninstall` removed the previously installed files and directories,
including any logs previously produced by `minit`.

More
====
Minit is a toy that doesn't do any of the following important things:
- [runlevels][4]
- timeouts
- different flavors of dependencies (e.g. `Should-Stop`, `Default-Start`)
- sensible error reporting (`make` will just fart at you)

It would not suffice at all as an `init` system for a real Linux distribution.
However, if you have a subsystem of interrelated processes, such as a bunch
of GRPC services, database proxies, etc., then `minit` might be a viable place
to start.

[1]: https://refspecs.linuxbase.org/LSB_3.0.0/LSB-PDA/LSB-PDA/iniscrptact.html
[2]: https://www.gnu.org/software/make/
[3]: https://en.wikipedia.org/wiki/Init
[4]: https://en.wikipedia.org/wiki/Runlevel