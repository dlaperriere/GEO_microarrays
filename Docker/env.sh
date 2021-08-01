#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# name / version
name="ubuntu20_testenv_geoma"
version=1.0
export img_version=$version
export img_name=$name

# shared volumes
export src_dir=$dir/../


