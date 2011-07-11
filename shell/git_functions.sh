## Repo Functions

function repo_init {
    cd $WINDOWS_DIR
    git init .
    cp -u /qcimage/windows_root/.gitignore .
    git add .
    git commit -m "Initial import"
}

function update_repo {
   # Expects commit message as arg
   cd $WINDOWS_DIR
   git add .
   git commit -m $1
}

function set_diff_tag {
    cd $WINDOWS_DIR
    git tag diff-base
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
    git diff diff-base > $output_path
}

function apply_diff {
    # Expects path to diff as arg
    cd $WINDOWS_DIR
    git checkout -b diff-tmp diff-base
    patch -p1 < $1
    git commit -m "diff applied"
    git rebase master
    git branch -d diff-tmp
}

# Misc Helper Functions

function player_hash {
    echo $1 |md5sum |awk '{print $1}'
}

function reload {
   . /etc/profile.d/qcimage.sh
}


