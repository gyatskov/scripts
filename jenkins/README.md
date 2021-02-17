# Jenkins #
Helpers for talking to a Jenkins instance using
 * REST API (works for services mapped to the API)
 * HTTP requests (works for everything else, e.g. retriggering)

# Requirements #
All powered by bash and:
 * curl
 * jq

# Usage #
1. Create a Jenkins API token
2. Copy the `config.ini.tpl` template to a `config.ini` file and configure according to your Jenkins server settings and the generated token.
3. Copy the `false-positives.json.tpl` template to a `false-positives.json` file and configure according to your pipeline and node settings.
4. Use any of the scripts in this directory, e.g.:
```bash
# Restart a jenkins job in the 'ci-review' pipeline
retrigger-job.sh ci-review 123456

# Analyze a build, discarding any configured "false positives"
analyze-build.sh ci-review 100321 false-positives-sv.json

# Pipe the complete build log of a job into your editor of choice
get-full-console-log.sh ci-review 108088 | nvim -

# Retrieve all nodes in a build and pretty print just the names
get-nodes.sh ci-review 108088 | jq -r 'map(.displayName)[]'

# Combine with gerrit scripts, jq and become creative
cd myrepo
path/to/jenkins/get-nodes.sh $(path/to/gerrit/get-last-build.sh | jq -r .job_name) $(path/to/gerrit/get-last-build.sh | jq -r .job_id) | jq 'map({displayName, result})'
```
