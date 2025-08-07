################################################################################
# $1: organization, e.g.: pagopa
# $2: repositoty, e.g.: idpay-portal-users-frontend
# $3: ruleset name, e.g.: develop
# $4: list of allowed merge methods, e.g.: merge squash rebase
################################################################################
if [ "$#" -lt 4 ]; then
	echo "❌ Illegal number of parameters"
	exit 1
fi

org=$1
repo=$2
ruleset=$3
shift 3

echo "🔵 Organization: $org"
echo "🔵 Repositorty: $repo"
echo "🔵 Ruleset name: $ruleset"
echo "🔵 List of allowed merge methods: $@"

################################################################################
# Find the ruleset url to change.
################################################################################
ruleset_url=$( \
	curl --no-progress-meter \
		-L \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer $GITHUB_TOKEN" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/$org/$repo/rulesets | \
	jq --arg ruleset "$ruleset" \
		'.[] | select(.name == $ruleset and .target == "branch") | ._links.self.href' | \
	tr -d \" \
)
if [ $? -ne 0 ]; then
    echo "❌ Something went wrong"
	exit 1
fi
echo "✅ Ruleset URL: $ruleset_url"

################################################################################
# Retrieve the ruleset definition.
################################################################################
original_ruleset=$( \
	curl --no-progress-meter \
		-L \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer $GITHUB_TOKEN" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		$ruleset_url \
)
if [ $? -ne 0 ]; then
	echo "❌ Something went wrong"
	exit 1
fi
echo "✅ Original ruleset:"
echo $original_ruleset

################################################################################
# Prepare allowed merge methods string.
################################################################################
allowed_merge_methods=$(printf '%s\n' "$@" | jq -R . | jq -s .)
if [ $? -ne 0 ]; then
	echo "❌ Something went wrong"
	exit 1
fi
echo "✅ Allowed merge methods........: $allowed_merge_methods"

################################################################################
# Change the ruleset definition.
################################################################################
new_ruleset=$( \
	echo $original_ruleset | \
	jq --argjson allowed_merge_methods "$allowed_merge_methods" \
		'(.rules[] | select(.type == "pull_request")).parameters.allowed_merge_methods = $allowed_merge_methods' | \
	jq '{ name: .name, target: .target, enforcement: .enforcement, bypass_actors: .bypass_actors, conditions: .conditions, rules: .rules }' \
)
if [ $? -ne 0 ]; then
	echo "❌ Something went wrong"
	exit 1
fi
echo "✅ New ruleset:"
echo $new_ruleset

################################################################################
# Update the ruleset definition.
################################################################################
current_ruleset=$(\
	curl --no-progress-meter \
		-L \
		-X PUT \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer $GITHUB_TOKEN" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		-d "$new_ruleset" \
		$ruleset_url \
)
if [ $? -ne 0 ]; then
	echo "❌ Something went wrong"
	exit 1
fi
echo "✅ Current ruleset:"
echo $current_ruleset
exit 0
