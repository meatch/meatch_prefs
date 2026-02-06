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

    if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
        echo "❌ Branch not found: $branch"
        return 1
    fi

    echo "📍 Current branch: $original_branch"
    if [ "$original_branch" = "$branch" ]; then
        echo "✅ Already on $branch"
    else
        echo "🔁 Checking out branch: $branch"
        git checkout "$branch" || return 1
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
