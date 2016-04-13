#!/bin/sh

battery_level="$(cat /sys/class/power_supply/BATC/capacity)"
charge_status="$(cat /sys/class/power_supply/BATC/status)"

if [[ ${charge_status} == 'Discharging' ]];then
	charge_status='V'
else
	charge_status='^'
fi

echo "${charge_status}|${battery_level}"

