# Get date/time

GitHub Action to get the date and/or time that the action was built at.

## How it works

The action uses a Docker image from Ubuntu which provides the `date` command that the script gets the output from.

However, the `date` command may differ on different operating systems (e.g. the Linux version supporting the `--debug` option which macOS/UNIX does not provide)

## Inputs

See the [action.yml](./action.yml) file for all of the inputs.

## Outputs

Currently, this action only outputs one output - the date as a string.

This can be accessed with the `date` ID.

See the [action.yml](./action.yml) file for all of the outputs.

## Environment variables

This action supports the `TZ` environment variable that allows for a custom timezone to be specified.

See the [Linux manpage for `date`](http://man7.org/linux/man-pages/man1/date.1.html#EXAMPLES) or the [BSD manpage for `date`](https://www.freebsd.org/cgi/man.cgi?date) (for macOS) for more info.

## Secrets

No secrets are required for this action.
