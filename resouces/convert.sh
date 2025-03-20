#!/bin/bash

list=($(./sing-box geosite list | sed 's/ (.*)$//g'))
mkdir -p geo/geosite
for ((i = 0; i < ${#list[@]}; i++)); do
	if [[ "${list[i]}" == "category-pt" || "${list[i]}" == "category-pt@!cn" ]]; then
		./sing-box geosite export ${list[i]} -o ./geo/geosite/${list[i]}.json
		./sing-box rule-set compile ./geo/geosite/${list[i]}.json -o ./geo/geosite/${list[i]}.srs
	fi
done
