# Day 02 - Linux Permissions, Users and Groups

## Goal

Understand how Linux permissions work and why they matter for DevOps workflows.

## Why permissions matter in DevOps

Permissions affect:

- deployment scripts
- SSH keys
- environment files
- logs
- service configuration files
- Docker volumes
- CI/CD runners
- production servers

A wrong permission can cause a deploy to fail, expose secrets or prevent a service from starting.

## Permission model

Linux permissions are divided into:

- user
- group
- others

Each category can have:

- read (`r`)
- write (`w`)
- execute (`x`)

## Numeric permissions

- `r = 4`
- `w = 2`
- `x = 1`

Examples:

- `755`: owner can read/write/execute, group and others can read/execute
- `644`: owner can read/write, group and others can read
- `600`: only owner can read/write

## Commands practiced

- `ls -la`
- `chmod`
- `chown`
- `whoami`
- `id`
- `groups`
- `sudo`

## Important lessons

- A script needs execute permission to run.
- Secrets should not be readable by everyone.
- `sudo` should be used carefully.
- File ownership matters as much as file permissions.

## Next step

Study Linux processes and basic service management.