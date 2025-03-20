#!/bin/bash

mkdir -p geoip
./mosdns v2dat unpack-ip -o ./geoip/ geoip.dat
list=($(ls ./geoip | sed 's/geoip_//g' | sed 's/\.txt//g'))
for ((i = 0; i < ${#list[@]}; i++)); do
	sed -i 's/^/        "/g' ./geoip/geoip_${list[i]}.txt
	sed -i 's/$/",/g' ./geoip/geoip_${list[i]}.txt
	sed -i '1s/^/{\n  "version": 1,\n  "rules": [\n    {\n      "ip_cidr": [\n/g' ./geoip/geoip_${list[i]}.txt
	sed -i '$ s/,$/\n      ]\n    }\n  ]\n}/g' ./geoip/geoip_${list[i]}.txt
	mv ./geoip/geoip_${list[i]}.txt ./geoip/${list[i]}.json
	./sing-box rule-set compile "./geoip/${list[i]}.json" -o ./geoip/${list[i]}.srs
done

list=($(./sing-box geosite list | sed 's/ (.*)$//g'))
mkdir -p geo-lite/geosite
for ((i = 0; i < ${#list[@]}; i++)); do
	if [[ "${list[i]}" == "category-pt" || "${list[i]}" == "category-pt@!cn" ]]; then
		./sing-box geosite export ${list[i]} -o ./geo-lite/geosite/${list[i]}.json
		./sing-box rule-set compile ./geo-lite/geosite/${list[i]}.json -o ./geo-lite/geosite/${list[i]}.srs
	fi
done
