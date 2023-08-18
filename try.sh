# https://news.ycombinator.com/item?id=30713151
# Retries a command a with backoff.
#
# The retry count is given by ATTEMPTS (default 100), the
# initial backoff timeout is given by TIMEOUT in seconds
# (default 5.)
#
# Successive backoffs increase the timeout by ~33%.
#
# Beware of set -e killing your whole script!
function try_till_success {
  local max_attempts=${ATTEMPTS-2}
  local timeout=${TIMEOUT-5}
  local attempt=0
  local exitCode=0

  while [[ $attempt < $max_attempts ]]
  do
    oldopt=$-
    set +e
    "$@"
    exitCode=$?
    set -$oldopt

    if [[ $exitCode == 0 ]]
    then
      break
    fi

    echo "Failure! Retrying in $timeout.." 1>&2
    sleep "$timeout"
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 40 / 30 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "You've failed me for the last time! ($*)" 1>&2
  fi

  return $exitCode
}
