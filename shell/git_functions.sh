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

function repo_reset {
    cd $WINDOWS_DIR
    git reset --hard
}

## Diff Functions

function generate_diff {
    # Expects two args: handle and output path
    # Requires that diff-base tag is set in repo
    output_path=$2/$1-`player_hash $1`.diff
    git diff --binary > $output_path
}

function apply_diff {
    # Expects path to diff as arg
    cd $WINDOWS_DIR
    git reset --hard
    git apply $1
}

# Misc Helper Functions

function player_hash {
    echo $1 |md5sum |awk '{print $1}'
}

function reload {
   . /etc/profile.d/qcimage.sh
}


