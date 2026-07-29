# Multiple Jobs and Artifacts

## Independent jobs

Jobs without `needs` can execute in parallel.

```yaml
jobs:
  lint:
    # ...

  test:
    # ...
```

## Dependent jobs

```yaml
package:
  needs:
    - lint
    - test
```

## Matrix

```yaml
strategy:
  fail-fast: false

  matrix:
    node-version:
      - 22
      - 24
```

## Matrix expression

```yaml
node-version: "${{ matrix.node-version }}.x"
```

## Step output

```bash
echo "package_name=$package_name" >> "$GITHUB_OUTPUT"
```

## Job output

```yaml
outputs:
  package_name: ${{ steps.metadata.outputs.package_name }}
```

## Read job output

```yaml
${{ needs.metadata.outputs.package_name }}
```

## Upload artifact

```yaml
- name: Upload artifact
  uses: actions/upload-artifact@v7
  with:
    name: application-package
    path: dist/
```

## Download artifact

```yaml
- name: Download artifact
  uses: actions/download-artifact@v8
  with:
    name: application-package
    path: downloaded-package
```

## Always upload reports

```yaml
if: ${{ always() }}
```

## Artifacts versus cache

```text
cache
  speeds up repeated workflow runs
  example: npm package cache

artifact
  stores output created by a workflow
  example: package, report, logs
```

## Job summary

```bash
echo "# CI Summary" >> "$GITHUB_STEP_SUMMARY"
```

## Failure propagation

```text
lint fails
  ↓
package skipped
  ↓
verify skipped

summary
  still executes with always()
```