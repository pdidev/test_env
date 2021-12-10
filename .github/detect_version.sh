if [ "${GITHUB_EVENT_NAME}" == "pull_request" ]
then
	BRANCH_NAME="${GITHUB_HEAD_REF}"
else
	BRANCH_NAME="${GITHUB_REF/*\/}"
fi
echo "BRANCH_NAME=${BRANCH_NAME}"
set +e
if echo "${BRANCH_NAME}" | grep -qs '^v[0-9]*$' &> /dev/null
then
	image_version="$(echo "${BRANCH_NAME}" | sed 's%^v\([0-9]*\)$%\1%')"
else
	image_version="$(( 0$(git branch -r --merged | grep '^\s*origin/v[0-9]*\s*$' | sed 's%^\s*origin/v\([0-9]*\)\s*$%\1%' | sort -nu | head -n 1 ) +1 ))_${GITHUB_SHA}"
fi
echo "image_version=v${image_version}"
echo "image_version=v${image_version}" >> $GITHUB_ENV
