# Publish the contract

For Tracks B and C, the issue is the contract's home, so approvers read it
there and a later session can resume from it. The contract sits in a marked
section of the issue body; the rest of the body stays as written.

## When

- **Issue work:** the first time, ask "Update issue #N with this contract?".
- **Local work:** ask "Create an issue holding this contract?".
- After a yes, republish without asking whenever the revision changes. After a
  no, keep the contract in the conversation and the change request, and do not
  ask again for this task.

## How

Write the contract to a file outside the checkout, then run the script from
the repository:

```sh
scripts/issue-contract.sh write 123 /path/to/contract.md
scripts/issue-contract.sh create "Notify after webhook retries" /path/to/contract.md
scripts/issue-contract.sh read 123
```

`scripts/` is relative to this skill's folder. The script picks `gh` or `glab`
from the `origin` remote; set `START_WORK_HOST=github` or `gitlab` for a host
it cannot recognize. `create` prints the new issue's URL; use its number from
then on.

Without the script (no POSIX shell), do the same by hand: read the body
(`gh issue view N --json body -q .body` or
`glab issue view N -F json --jq .description`), replace the text between
`<!-- start-work-lite:contract -->` and `<!-- /start-work-lite:contract -->`,
or append both markers with the contract between them, then write the body
back with `gh issue edit N --body-file FILE` or
`glab issue update N --description "$(cat FILE)"`.

After publishing, link the issue in the gate message.
