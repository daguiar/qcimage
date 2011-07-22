## Repo Functions

function repo_init {
    cd $WINDOWS_DIR
    git init .
    cp -u /qcimage/windows_root/.gitignore .
    mv .git $REPO_DIR
    echo "gitdir: $REPO_DIR" > .git
    git add .
    git commit -m "Initial import"
}

function repo_update {
    cd $WINDOWS_DIR
    git add .
    git commit -m""
}

function repo_reset {
    cd $WINDOWS_DIR
    if [ -e $WINDOWS_DIR/.qcimage/reset ]; then
	rm $WINDOWS_DIR/.qcimage/reset
    fi
    git reset --hard
    git clean -f
}

## Diff Functions

function generate_diff {
    cd $WINDOWS_DIR
    git diff --binary > $DIFF
}

function apply_diff {
    cd $WINDOWS_DIR
    repo_reset
    git apply $DIFF
}

# Misc Helper Functions

function reload {
   . /etc/profile.d/qcimage.sh
}

function boot_windows {
   grub2-reboot "Windows"
   reboot
   echo "Ready to reboot!"
}

