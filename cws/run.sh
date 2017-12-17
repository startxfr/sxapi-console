#!/bin/bash
cd /usr/src/app
touch /usr/bin/git
npm test && npm $1