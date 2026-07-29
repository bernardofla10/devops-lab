# Day 05 - Trivy Dependency and Image Scanning

## Goal

Add dependency and container-image vulnerability scanning to the CI pipeline.

## SCA

Software Composition Analysis identifies known vulnerabilities in third-party components.

## Filesystem scanning

The filesystem scan analyzes application dependency files.

For Node.js, the lock file provides exact package versions.

## Image scanning

The image scan analyzes:

- operating-system packages
- language libraries
- installed versions
- known fixed versions

## Report versus gate

The report records every relevant finding.

The gate applies the blocking policy.

## Severity

The lab uses:

- UNKNOWN
- LOW
- MEDIUM
- HIGH
- CRITICAL

## Fixed and unfixed

A fixed vulnerability has an upgrade or patched version available.

An unfixed vulnerability still requires analysis, but may need mitigation instead of an immediate upgrade.

## Dependency policy

Block:

- HIGH
- CRITICAL
- fixed vulnerabilities

## Image policy

Block:

- CRITICAL
- fixed vulnerabilities

## Vulnerable dependency exercise

The initial project used an intentionally vulnerable Lodash version.

The security gate stopped the image build.

After upgrading the package and lock file, the pipeline continued.

## Reports

The pipeline generates:

- table reports
- JSON reports
- SARIF reports

## SARIF

SARIF can be uploaded to GitHub code scanning when the repository supports it.

The reports are also retained as artifacts.

## Exceptions

A `.trivyignore` entry is a risk decision, not merely a technical workaround.

Every exception needs:

- justification
- owner
- expiration
- compensating controls
- review record

## Important lessons

- Dependency versions must be locked.
- Functional tests do not detect known vulnerable components.
- Source scanning and image scanning cover different layers.
- Image scanning should happen after the build.
- A security report and a blocking gate have different purposes.
- Unfixed does not mean harmless.
- Security exceptions should expire.
- The image should only be tested after passing its vulnerability policy.
- CI policies should be explicit and documented.

## Next step

Harden the GitHub Actions pipeline with branch protection, pinned actions and least-privilege permissions.