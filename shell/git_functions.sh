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
}

## Diff Functions

function generate_diff {
    git diff --binary > $DIFF
}

function apply_diff {
    cd $WINDOWS_DIR
    git reset --hard
    git apply $DIFF
}

# Misc Helper Functions

function reload {
   . /etc/profile.d/qcimage.sh
}

function boot_windows {
   grub2-reboot "Chainload Windows"
   #reboot
   echo "Ready to reboot!"
}

