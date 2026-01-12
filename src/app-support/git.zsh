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
    local feature_branch="${1}"
    local base_branch="${2:-origin/main}"

    if [ -z "$feature_branch" ]; then
        echo "❌ Usage: review-branch <feature-branch> [base-branch]"
        echo "   Example: review-branch origin/my-feature"
        echo "   Example: review-branch origin/my-feature origin/develop"
        return 1
    fi

    # Fetch latest changes
    echo "🔄 Fetching latest from origin..."
    git fetch origin

    # Generate filename: origin-my-feature-origin-main-2026.01.12-14.56.33.diff.txt
    local timestamp=$(date +"%Y.%m.%d-%H.%M.%S")
    local feature_clean=$(echo "$feature_branch" | sed 's/\//-/g')
    local base_clean=$(echo "$base_branch" | sed 's/\//-/g')
    local filename="${feature_clean}-${base_clean}-${timestamp}.diff.txt"
    local filepath="$HOME/Desktop/${filename}"

    echo "📝 Generating code review diff..."
    echo ""

    # Create diff file with structured sections
    {
        echo "=== CODE REVIEW DIFF ==="
        echo "Feature Branch: ${feature_branch}"
        echo "Base Branch: ${base_branch}"
        echo "Generated: $(date)"
        echo "Repository: $(basename $(git rev-parse --show-toplevel))"
        echo ""
        echo "=== COMMITS (unique to feature branch) ==="
        git log ${base_branch}..${feature_branch} --oneline
        echo ""
        echo "=== FILE STATISTICS ==="
        git diff ${base_branch}...${feature_branch} --stat
        echo ""
        echo "=== FULL DIFF ==="
        git diff ${base_branch}...${feature_branch}
    } > "$filepath"

    echo "✅ Code review diff saved to:"
    echo "   ${filepath}"
    echo ""
    echo "📋 File copied to clipboard!"
    echo "$filepath" | pbcopy
    echo ""
    echo "💡 Next steps:"
    echo "   1. Open Claude Code in this repo"
    echo "   2. Paste the path (already in clipboard)"
    echo "   3. Say: 'Review this code review diff in ask mode'"
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
