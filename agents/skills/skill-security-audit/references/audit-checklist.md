# Audit Checklist

Copy this checklist when starting an audit. Check items off as completed.

## Pre-Flight

```
- [ ] Clone repo to /tmp/ (isolated from workspace)
- [ ] List all files, note hidden directories and unexpected file types
- [ ] Check git history depth (single commit repos may hide squashed malice)
- [ ] Note repo age, star count, contributor count for trust signals
```

## Automated Scans

```
- [ ] Run scan-repo.sh against target
- [ ] Run detect-hidden-chars.py against target
- [ ] Review and triage all findings
```

## Manual Review — AI Instruction Files

```
- [ ] .claude-plugin/ or similar AI plugin metadata
- [ ] SKILL.md, AGENTS.md, CLAUDE.md, CURSORRULES
- [ ] README.md (check for hidden instructions in markdown)
- [ ] Any YAML frontmatter in markdown files
- [ ] HTML comments in markdown (<!-- hidden content -->)
- [ ] Commit messages and PR descriptions
```

## Manual Review — Executable Code

```
- [ ] Shell scripts (.sh, .bash) — check for downloads, evals, encoded payloads
- [ ] Provisioning scripts (Vagrantfile, Dockerfile, cloud-init)
- [ ] CI/CD pipelines (.github/workflows/, .gitlab-ci.yml)
- [ ] Package install hooks (npm preinstall/postinstall, setup.py)
- [ ] Makefile targets
- [ ] Git hooks (.git/hooks/ or .husky/)
```

## Manual Review — Configuration

```
- [ ] ansible.cfg — host_key_checking, become settings
- [ ] SSH config — permissive settings
- [ ] Dependency files — pinned versions, unusual registries
- [ ] Docker configs — privileged mode, host network, volume mounts
- [ ] Environment files (.env) — leaked secrets
```

## Manual Review — Code Patterns

```
- [ ] Dynamic code execution (eval, exec, Function constructor)
- [ ] Network calls to hardcoded external hosts
- [ ] File system access outside expected paths
- [ ] Subprocess spawning with user-controlled input
- [ ] Deserialization of untrusted data (pickle, yaml.load, JSON.parse of user input)
```

## Encoding & Obfuscation

```
- [ ] Zero-width Unicode characters (detect-hidden-chars.py)
- [ ] Bidi override characters
- [ ] Base64 blobs that decode to executable content
- [ ] Hex-encoded strings
- [ ] String concatenation to avoid pattern matching
- [ ] Variable indirection (eval $var, ${!var})
```

## Report

```
- [ ] All findings classified by severity (CRITICAL/HIGH/MEDIUM/LOW)
- [ ] Context provided for each finding (lab-only vs production concern)
- [ ] Explicit note if any concealment instructions were found
- [ ] Clean bill if nothing found, with scope noted
```

## Severity Guide

| Severity | Criteria | Examples |
|----------|----------|---------|
| CRITICAL | Active exploitation or concealment | Reverse shells, exfil, prompt injection hiding findings |
| HIGH | Security weakened or credentials exposed | Disabled firewalls in prod, hardcoded real passwords |
| MEDIUM | Risky but context-dependent | Disabled security in Vagrant, weak SSH config in lab |
| LOW/INFO | Noteworthy but not actionable | BOM markers, verbose error output, debug flags |
