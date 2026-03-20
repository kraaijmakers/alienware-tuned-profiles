#!/bin/bash
if [[ "$1" == "start" ]]; then
    echo "\_SB.AMW1.WMAX 0 0x15 {0x1,${TUNED_FAN_SPEED},0x0,0x00}" > /proc/acpi/call
fi
