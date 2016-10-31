SXAPI Console
=============

[![Travis](https://travis-ci.org//startxfr/sxapi-console.svg?branch=master)](https://travis-ci.org/startxfr/sxapi-console)

***SXAPI*** is a microservice framework optimized for building simple and extensible API efficiently. SXAPI Console provide graphical or command line to help developper start and manage their sxapi microservices.


Getting Started
---------------

SXAPI console have 2 components

* sxapi-cli : commande line interface for starting and managing an sxapi project
* sxapi-wcs : web console for managing and monitoring of sxapi instances


### Installing CLI

#### Using sxapi-installer

The command line is available right after an installation using [sxapi-installer](https://github.com/startxfr/sxapi-installer/).

#### Manual installation

If you don't want to use sxapi-installer, you can manually install sxapi-cli by running the following commands

```
curl --silent -L https://raw.githubusercontent.com/startxfr/sxapi-console/v0.0.5/cli.sh > /usr/local/bin/sxapi-cli
chmod +x /usr/local/bin/sxapi-cli
```

### Troubleshooting

If you run into difficulties installing or running sxapi-cli or sxapi-wcs, please report [issue for console](https://github.com/startxfr/sxapi-console/issues/new) or  [issue for sxapi](https://github.com/startxfr/sxapi-core/issues/new).

License
-------

SXAPI is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/).