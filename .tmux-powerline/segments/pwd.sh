#/usr/bin/env bash
# Print the current working directory (trimmed to max length).
# NOTE The trimming code's stolen from the web. Courtesy to who ever wrote it.

pwdmaxlen=40		# Max output length.

segment_cwd=$(dirname $0)
source "$segment_cwd/../lib.sh"

# Truncate from the left.
tcwd=$(get_tmux_cwd)
dir=${tcwd##*/}
echo "$dir"

exit 0
