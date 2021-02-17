# Gerrit #
Helpers for talking to the Gerrit SSH API.

# Requirements #
All powered by bash and:
 * curl
 * jq

# Usage #
1. Make sure your SSH key is correctly configured in Gerrit
2. Create a `config.ini` file by copying from the template `config.ini.tpl` and use the configuration of your server.
3. Use any of the scripts in this directory, e.g.:
```bash
# Retrieve change ID of current commit
get-change-id.sh

# Get last build metadata from last build of current change
get-last-build.sh

# Get last build metadata from last build of any change
get-last-build.sh I0987654321abcdefg

# Get reviewer comments for all patchsets of current change
get-review-comments.sh | jq .

# Get reviewer comments for all patchsets of any change
get-review-comments.sh 'Ic94a3738660e5f98f16e5f85db913a74d4660206'  | jq .
```
