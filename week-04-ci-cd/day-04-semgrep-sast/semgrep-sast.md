# Semgrep SAST Fundamentals

## Scan

```bash
semgrep scan \
  --config semgrep-rules/rules \
  app/src
```

## Blocking scan

```bash
semgrep scan \
  --config semgrep-rules/rules \
  --error \
  app/src
```

## Reports

```bash
semgrep scan \
  --config semgrep-rules/rules \
  --text-output=reports/semgrep.txt \
  --json-output=reports/semgrep.json \
  --sarif-output=reports/semgrep.sarif \
  app/src
```

## Test custom rules

```bash
semgrep scan \
  --test \
  --config semgrep-rules/rules \
  semgrep-rules/tests
```

## Rule structure

```yaml
rules:
  - id: rule-id
    message: Explain the problem and remediation.
    severity: HIGH
    languages:
      - javascript
    pattern: dangerousFunction(...)
```

## Test annotations

```js
// ruleid: rule-id
dangerousFunction(input);

// ok: rule-id
safeFunction(input);
```

## Exit codes

```text
semgrep scan
  returns 0 after a successful scan
  even when findings exist

semgrep scan --error
  returns 1 when findings exist
```

## SAST gate

```text
report scan
  preserves findings

blocking scan
  controls pipeline continuation
```

## SARIF

SARIF reports can be:

- uploaded to GitHub code scanning
- stored as workflow artifacts
- consumed by security platforms
- retained for audit evidence

## Triage

For each finding:

1. inspect the matched code
2. understand data flow
3. confirm exploitability
4. determine severity
5. fix code or refine the rule
6. document justified suppressions