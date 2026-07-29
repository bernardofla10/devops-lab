# Day 04 - Semgrep SAST Security Gate

## Goal

Add Static Application Security Testing to the CI pipeline and block Docker builds when insecure patterns are detected.

## SAST

SAST analyzes source code without executing the application.

It can detect potentially insecure patterns early in the development lifecycle.

## Semgrep

Semgrep uses rules to describe patterns that should be detected.

This lab uses local rules instead of a remote ruleset to make the security gate deterministic.

## Custom rules

The rules detect:

- `child_process.exec`
- JavaScript `eval`

## Rule testing

Custom rules include positive and negative examples.

This protects against:

- false negatives
- false positives
- accidental rule regressions

## Reports

The scan generates:

- text
- JSON
- SARIF

The reports are uploaded as workflow artifacts.

## Security gate

The report scan does not block the pipeline.

A second scan uses:

```bash
--error
```

This converts findings into a non-zero exit code.

## Pipeline dependency

The Docker build depends on:

- application quality
- Semgrep SAST

If the security scan fails, the image is not built.

## Vulnerability

The initial code passed untrusted input into:

```js
exec(operation)
```

This invokes a shell and creates a command-injection risk.

## Remediation

The secure implementation uses:

- `execFile`
- `shell: false`
- allowlisted operations
- explicit arguments
- rejection of unknown operations

## False positives

A finding must be reviewed in context.

A broad rule may detect legitimate uses.

Possible responses include:

- fixing the code
- refining the rule
- adding negative rule tests
- documenting an acceptable risk
- using a targeted suppression only when justified

## Important lessons

- Passing functional tests does not prove security.
- Security findings need evidence and triage.
- Reports and gates serve different purposes.
- A gate should run before image publication or deployment.
- Custom rules should have automated tests.
- Security reports should be preserved after failures.
- SARIF provides interoperability between scanning tools and GitHub.
- Broad suppressions can hide real vulnerabilities.
- Remediation is preferable to ignoring a finding.

## Next step

Add Trivy dependency and container-image vulnerability scanning.