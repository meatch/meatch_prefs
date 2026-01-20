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
# Usage: review-branch <feature-branch> [base-branch]
# Examples:
#   review-branch origin/my-feature
#   review-branch origin/my-feature origin/develop
review-branch() {
    local feature_branch="$1"
    local base_branch="${2:-origin/main}"

    if [ -z "$feature_branch" ]; then
        echo "❌ Usage: review-branch <feature-branch> [base-branch]"
        echo "   Example: review-branch origin/my-feature"
        return 1
    fi

    echo "🔄 Fetching latest from origin..."
    git fetch origin --prune || return 1

    if ! git rev-parse --verify "$feature_branch" >/dev/null 2>&1; then
        echo "❌ Feature branch not found: $feature_branch"
        return 1
    fi

    if ! git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
        echo "❌ Base branch not found: $base_branch"
        return 1
    fi

    local original_branch
    original_branch=$(git symbolic-ref --short HEAD)

    echo "📍 Current branch: $original_branch"
    echo "🔁 Checking out feature branch: $feature_branch"
    git checkout "$feature_branch" || return 1

    echo "🧼 Rebasing $feature_branch onto $base_branch..."
    git rebase "$base_branch" || {
        echo "❌ Rebase failed — aborting."
        git rebase --abort
        git checkout "$original_branch"
        return 1
    }

    local timestamp
    timestamp=$(date +"%Y.%m.%d-%H.%M.%S")

    local feature_clean
    feature_clean=$(echo "$feature_branch" | sed 's/\//-/g')

    local base_clean
    base_clean=$(echo "$base_branch" | sed 's/\//-/g')

    local filename="${feature_clean}-PR-clean-${timestamp}.diff.txt"
    local filepath="$HOME/Desktop/${filename}"

    echo "📝 Generating PR-clean diff..."
    git diff "$base_branch"..HEAD > "$filepath"

    echo "↩️  Returning to original branch: $original_branch"
    git checkout "$original_branch" || return 1

    echo "🗑️  Deleting local feature branch copy..."
    git branch -D "$feature_branch" >/dev/null 2>&1 || true

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
