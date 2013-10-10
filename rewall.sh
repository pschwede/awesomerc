#!/bin/bash

randfile() { echo $(eval echo \${$(($RANDOM%$#+1))} ) ; }
feh --bg-fill "$(randfile ~/Pictures/backgrounds/*/*)"
