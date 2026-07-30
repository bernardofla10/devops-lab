# Branch Protection Checklist

## Target branch

```text
main
```

## Pull requests

- [ ] Require a pull request before merging
- [ ] Require conversation resolution
- [ ] Do not permit direct pushes

## Reviews

Solo repository:

- [ ] Do not require approvals yet
- [ ] Do not require Code Owner approval yet

Repository with collaborators:

- [ ] Require at least one approval
- [ ] Dismiss stale approvals after new commits
- [ ] Require approval of the most recent push
- [ ] Require Code Owner review for sensitive files

## Status checks

- [ ] Require status checks before merging
- [ ] Require `Required - Hardened CI`
- [ ] Require the branch to be up to date before merging
- [ ] Confirm the check source is GitHub Actions

## History

- [ ] Require linear history when using squash or rebase merges
- [ ] Do not allow force pushes
- [ ] Do not allow branch deletion

## Administrator behavior

- [ ] Apply rules to administrators when appropriate
- [ ] Avoid permanent bypass users
- [ ] Record any bypass event

## GitHub Actions settings

- [ ] Default workflow permission is read-only
- [ ] Actions cannot approve pull requests
- [ ] Actions must use full commit SHAs
- [ ] Fork workflows do not receive secrets
- [ ] Fork workflows do not receive write tokens
- [ ] First-time contributor workflows require approval

## Validation

```bash
./scripts/audit-repository-settings.sh
```