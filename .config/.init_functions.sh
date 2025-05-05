function next_work_tree() {
    # Function to jump to next worktree path

    # Split the paths into an array
    local paths=($(git worktree list | awk '{print $1}')) # Use awk to extract the first column

    # Get the current directory
    local current_dir=$(pwd)

    # Find the index of the current directory in the paths array
    local index=-1
    for i in "${!paths[@]}"; do
        if [[ "${paths[$i]}" == "$current_dir" ]]; then
            index=$i
            break
        fi
    done

    # If the current directory was found in the list
    if [[ $index -ne -1 ]]; then
        # Calculate the next index
        local next_index=$(( (index + 1) % ${#paths[@]} ))

        # Jump to the next directory
        cd "${paths[$next_index]}"
        echo "Moved to ${paths[$next_index]}"
    else
        echo "Current directory is not in the list."
    fi
}


