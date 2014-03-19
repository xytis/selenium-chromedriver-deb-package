# Synopsis

This project is meant to automate debian package for selenium chromedriver
It will automatically download selenium chromedriver from google code
file repository and package it (it will deploy to /usr/bin/chromedriver)

# Builing

In order to build the debian package just run

  $ ./build.sh pkg [version]

Then it will be found in pkg sub directory

To remove the build package:

  $ ./build.sh clean

