# Library functions.

segments_dir="segments"
declare entries

if [ -n "$USE_PATCHED_FONT" -a "$USE_PATCHED_FONT" == "true" ]; then
    # Separators (patched font required)
    separator_left_bold="⮂"
    separator_left_thin="⮃"
    separator_right_bold="⮀"
    separator_right_thin="⮁"
else
    # Alternative separators in the normal Unicode table.
    separator_left_bold=""
    separator_left_thin=""
    separator_right_bold=""
    separator_right_thin=""
fi

# Make sure that grep does not emit colors.
#export GREP_OPTIONS="--color=never"

# Register a segment.
register_segment() {
    segment_name="$1"
    entries[${#entries[*]}]="$segment_name"

}

print_status_line_right() {
    local prev_bg="green"
    for entry in ${entries[*]}; do
	local script=$(eval echo \${${entry}["script"]})
	local foreground=$(eval echo \${${entry}["foreground"]})
	local background=$(eval echo \${${entry}["background"]})
	local separator=$(eval echo \${${entry}["separator"]})
	local separator_fg=""
	if [ $(eval echo \${${entry}["separator_fg"]+_}) ];then
	    separator_fg=$(eval echo \${${entry}["separator_fg"]})
	fi

	# Can't be declared local if we want the exit code.
	output=$(${script})
	local exit_code="$?"
  if [ "$DEBUG_MODE" != "false" ]; then
      if [ "$exit_code" -ne 0 ]; then
	        echo "Segment ${script} exited with code ${exit_code}. Aborting."
    	    exit 1
    	elif [ -z "$output" ]; then
	      continue
    	fi
  fi
	echo -n "#[fg=$background,bg=$prev_bg]$separator#[fg=$foreground,bg=$background] $output" 
	prev_bg="$background"
    done
    # End in a clean state.
    echo -n "#[default]"
}

print_status_line_left() {
    prev_bg="colour148"
    for entry in ${entries[*]}; do
	local script=$(eval echo \${${entry}["script"]})
	local foreground=$(eval echo \${${entry}["foreground"]})
	local background=$(eval echo \${${entry}["background"]})
	local separator=$(eval echo \${${entry}["separator"]})
	local separator_fg=""
	if [ $(eval echo \${${entry}["separator_fg"]+_}) ];then
	    separator_fg=$(eval echo \${${entry}["separator_fg"]})
	fi

	local output=$(${script})
	echo -n "#[fg=$prev_bg,bg=$background]$separator#[fg=$foreground,bg=$background] $output" 
	prev_bg="$background"
    done
    echo -n  "#[fg=$prev_bg,bg=green]$separator_right_bold"
    # End in a clean state.
    echo -n "#[default]"
}

# Get the current path in the segment.
get_tmux_cwd() {
    local env_name=$(tmux display -p "TMUXPWD_#I_#P")
    local env_val=$(tmux show-environment | grep "$env_name")
    # The version below is still quite new for tmux. Uncommented this in the future :-)
    #local env_val=$(tmux show-environment "$env_name" 2>&1)

    if [[ ! $env_val =~ "unknown variable" ]]; then
	local tmux_pwd=$(echo "$env_val" | sed 's/^.*=//')
	echo "$tmux_pwd"
    fi
}

