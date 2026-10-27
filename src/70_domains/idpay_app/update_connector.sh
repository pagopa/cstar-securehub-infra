#!/bin/bash
url=$1
config_file=$2
curl -v -X PUT -H "Content-Type: application/json" --data @"$config_file" "$url"
