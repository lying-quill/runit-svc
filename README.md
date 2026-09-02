# runit-svc
This is an opinionated runit service template that i've been using for some time
and i've decided to turn it into a package with a tiny utility script

## Installation
Clone the repository and run:
```sh
make install
```
then you should be able to invoke the utility script:
```sh
# the default value for SVDIR is /etc/runit/sv
# i suggest using a different SVDIR for system services to prevent
# conflict with os packages (e.g. /etc/runit/svc)
export SVDIR=/home/user/.config/service
runit-svc create your-service-name [--with-check] [--down] [--editor]
```
let's break it down:
- __your-service-name__: required. the name of your service, which will also be
  the name of its sv directory. this is limited to `[a-z0-9-_]`
- __--with-check (-c)__: optional. creates a "check" hook for your service. it is
  recommended to only use this if you have set up an actual check logic in your
  service config file. since the default behavior is to always return 0!
- __--down (-d)__: optional. creates a "down" flag that prevents runit from
  automatically running it.
- __--editor (-e)__: optional. opens the $EDITOR (or `nano` if that variable isn't
  declared) with the service's config file as input.

__NOTE__: right now combined short args (e.g. `-ecd`) don't work. use `-e -c -d`
instead.

## How does it work?
The install script copies the base template into your system (whether installing
it system-wide or local). the template directory includes a bunch of shell
scripts that runit uses to manage the service with. the scripts that are
common between services are symlinked.

the only two files that are copied are
"conf" and "down" (this one's optional). the configuration template is full of
comments and every variable's purpose is explained. take a look
[here](package/share/runit-svc/conf).

## Development
Required tools:
- [shellcheck](https://github.com/koalaman/shellcheck) (>=0.10.0)
- [shfmt](https://github.com/mvdan/sh) (>=3.13.1)

run this command to register the git hook and run a version check for the
aforementioned tools:
```sh
make dev
```

## License
Currently licensed under the [MIT license](https://mit-license.org/).
There's a copy of the [license](LICENSE) available along with the source code.
