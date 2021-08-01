#!/bin/env bash

cd /src


#echo Test install R requirements
#R --no-save < R/install_packages.R

echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

echo Test 
bash Jenkins/run_test.sh

echo -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


echo -30-

