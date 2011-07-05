## Repo Functions

function repo_init {
    git init .
    git add .
    git commit -m "Initial import"
    git tag diff-base
}

function repo_reset {
    git reset --hard diff-base
}

## Diff Functions

function generate_diff {
    # Expects two args: handle and output path
    output_path=$2/$1-`player_hash $1`.diff
    git diff diff-base > $output_path
}

function apply_diff {
    # Expects path to diff as arg
    patch -p1 < $1
}

# Misc Helper Functions

function player_hash {
    echo $1 |md5sum |awk '{print $1}'
}