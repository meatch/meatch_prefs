# --------------------------------------------------------------
# Git
# --------------------------------------------------------------
# Functions
function grhard {
    echo '>>>> Start clean, reset, and checkout';
    set -x;
    git clean -df;
    git reset --hard;
    git checkout .;
    echo '<<<< End clean, reset, and checkout';
}

function grib() {
    git rebase -i origin/$1
}

function removeLocalBranches() {
    # Usage: removeLocalBranches [--omit <branch1,branch2,...>]
    local omit_branches=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --omit)
                IFS=',' read -rA omit_branches <<< "$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: removeLocalBranches [--omit <branch1,branch2,...>]"
                return 1
                ;;
        esac
    done

    local current_branch
    current_branch=$(git symbolic-ref --short HEAD)

    local branches_to_delete=()
    while IFS= read -r branch; do
[[ "$branch" == "$current_branch" ]] && continue
        local skip=0
        for omit in "${omit_branches[@]}"; do
            [[ "$branch" == "$omit" ]] && skip=1 && break
        done
        [[ $skip -eq 1 ]] && continue
        branches_to_delete+=("$branch")
    done < <(git branch | grep -v '^\*' | sed 's/^[[:space:]]*//')

    if [[ ${#branches_to_delete[@]} -eq 0 ]]; then
        echo "No branches to delete."
        return 0
    fi

    echo "Branches to delete:"
    for b in "${branches_to_delete[@]}"; do
        echo "  $b"
    done
    echo ""
    echo -n "Proceed? [y/N] "
    read -r confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; return 0; }

    for b in "${branches_to_delete[@]}"; do
        git branch -D "$b"
    done
}

# Code review helper - generates diff file for Claude Code review
# Usage: review-branch [--branch <branch>] [--merge-to-branch <branch>]
# Options:
#   --branch          Branch to review (default: current branch)
#   --merge-to-branch   Rebase onto this branch before diffing (skipped if not provided)
# Examples:
#   review-branch
#   review-branch --branch origin/my-feature
#   review-branch --branch origin/my-feature --merge-to-branch origin/main
review-branch() {
    local branch=""
    local merge_to_branch=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --branch)
                branch="$2"
                shift 2
                ;;
            --merge-to-branch)
                merge_to_branch="$2"
                shift 2
                ;;
            *)
                echo "❌ Unknown option: $1"
                echo "   Usage: review-branch [--branch <branch>] [--merge-to-branch <branch>]"
                return 1
                ;;
        esac
    done

    echo "🔄 Fetching latest from origin..."
    git fetch origin --prune || return 1

    local original_branch
    original_branch=$(git symbolic-ref --short HEAD)

    # Default to current branch
    if [ -z "$branch" ]; then
        branch="$original_branch"
    fi

    # Normalize: strip origin/ prefix for local checkout
    local local_branch="${branch#origin/}"

    # Validate the remote ref exists
    if ! git rev-parse --verify "origin/$local_branch" >/dev/null 2>&1; then
        echo "❌ Branch not found: $branch"
        return 1
    fi

    echo "📍 Current branch: $original_branch"
    if [ "$original_branch" = "$local_branch" ]; then
        echo "✅ Already on $local_branch"
    else
        echo "🔁 Checking out branch: $local_branch"
        git checkout "$local_branch" || return 1
    fi

    # Rebase only if --merge-to-branch is provided
    if [ -n "$merge_to_branch" ]; then
        if ! git rev-parse --verify "$merge_to_branch" >/dev/null 2>&1; then
            echo "❌ Merge-to branch not found: $merge_to_branch"
            return 1
        fi

        echo "🧼 Rebasing $branch onto $merge_to_branch..."
        git rebase "$merge_to_branch" || {
            echo "❌ Rebase failed — aborting."
            git rebase --abort
            git checkout "$original_branch"
            return 1
        }
    else
        echo "⏩ Skipping rebase (no --merge-to-branch provided)"
    fi

    local diff_base="${merge_to_branch:-origin/main}"

    local timestamp
    timestamp=$(date +"%Y.%m.%d-%H.%M.%S")

    local branch_clean
    branch_clean=$(echo "$branch" | sed 's/\//-/g')

    local filename="${branch_clean}-PR-clean-${timestamp}.diff.txt"
    local filepath="$HOME/Desktop/${filename}"

    echo "📝 Generating PR-clean diff against $diff_base..."
    git diff "$diff_base"..HEAD > "$filepath"

    echo "📂 Opening diff in VS Code..."
    code "$filepath"

    echo ""
    echo "✅ PR-clean diff generated:"
    echo "   $filepath"
}


# Aliases
alias gst="git status"
alias gbv="git branch -vva"
alias gbvg="git branch -vva | grep -i $1"
alias gbvb="git for-each-ref --format='%(color:cyan)%(authordate:format:%m/%d/%Y %I:%M %p) %(align:25,left)%(color:yellow)%(authorname)%(end) %(color:reset)%(refname:strip=3)' --sort=authorname refs/remotes"
alias glo="git log --oneline"
alias gloa="git log --author=\"Mitch Gohman\" --oneline"
alias glow="git log --oneline --all --graph --decorate"
alias gfp="git fetch -p"
