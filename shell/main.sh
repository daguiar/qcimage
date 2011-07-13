function qcimage_apply {
    repo_reset
    apply_diff
    boot_windows
}

function qcimage_reclone {
    clone_new_machine
    boot_windows
}

function qcimage_diff {
    init_player_key
    generate_diff
    boot_windows
}

function qcimage_reset {
    repo_reset
    boot_windows
}