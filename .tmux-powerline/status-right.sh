#!/usr/bin/env bash
# This script prints a string will be evaluated for text attributes (but not shell commands) by tmux. It consists of a bunch of segments that are simple shell scripts/programs that output the information to show. For each segment the desired foreground and background color can be specified as well as what separator to use. The script the glues together these segments dynamically so that if one script suddenly does not output anything (= nothing should be shown) the separator colors will be nicely handled.

# The powerline root directory.
cwd=$(dirname $0)

# Source global configurations.
source "${cwd}/config.sh"

# Source lib functions.
source "${cwd}/lib.sh"

segments_path="${cwd}/${segments_dir}"

# Segment
# Comment/uncomment the register function call to enable or disable a segment.

declare -A cpu
cpu+=(["script"]="${segments_path}/cpu.sh")
cpu+=(["foreground"]="colour150")
cpu+=(["background"]="colour235")
cpu+=(["separator"]="${separator_left_bold}")
register_segment "cpu"

declare -A load
load+=(["script"]="${segments_path}/load.sh")
load+=(["foreground"]="colour235")
load+=(["background"]="colour150")
load+=(["separator"]="${separator_left_bold}")
register_segment "load"

declare -A date_day
date_day+=(["script"]="${segments_path}/date_day.sh")
date_day+=(["foreground"]="colour58")
date_day+=(["background"]="colour235")
date_day+=(["separator"]="${separator_left_bold}")
register_segment "date_day"

declare -A date_full
date_full+=(["script"]="${segments_path}/date_full.sh")
date_full+=(["foreground"]="colour235")
date_full+=(["background"]="colour136")
date_full+=(["separator"]="${separator_left_bold}")
date_full+=(["separator_fg"]="default")
register_segment "date_full"

declare -A time
time+=(["script"]="${segments_path}/time.sh")
time+=(["foreground"]="colour136")
time+=(["background"]="colour235")
time+=(["separator"]="${separator_left_bold}")
time+=(["separator_fg"]="default")
register_segment "time"

# Print the status line in the order of registration above.
print_status_line_right

exit 0
