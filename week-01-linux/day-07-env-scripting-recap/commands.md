# Day 07 - Environment Variables, Shell Scripting and Week 01 Recap

## Environment Variables

```bash
echo $SHELL    # Display the current shell.
echo $PATH     # Show the executable search path.
echo $HOME     # Display the current user's home directory.
echo $USER     # Show the current username.
```

## Create and Export Variables

```bash
APP_ENV=development      # Create a shell variable.
echo $APP_ENV            # Display the variable value.

export APP_ENV=development   # Export the variable to child processes.
export APP_PORT=8080         # Export another environment variable.

echo $APP_ENV                # Display the exported variable.
echo $APP_PORT               # Display the exported variable.
```

## Inspect Environment

```bash
env | head          # Display the first environment variables.
printenv | head     # Print the first environment variables.
printenv APP_ENV    # Display the value of APP_ENV.
```

## Remove Variable

```bash
unset APP_ENV    # Remove the environment variable.
echo $APP_ENV    # Verify that the variable has been removed.
```

## Variable for One Command

```bash
APP_ENV=production bash -c 'echo "Environment: $APP_ENV"'   # Set a temporary variable for a single command.
```

## Load a `.env` File

```bash
set -a        # Automatically export all variables.
source .env   # Load variables from the .env file.
set +a        # Disable automatic export.
```

## Run Environment Demo

```bash
chmod +x env-demo.sh        # Make the script executable.
./env-demo.sh               # Run the demo script.
./env-demo.sh .env.example  # Run the script using a specific .env file.
```

## Run Nginx Operations Check

```bash
chmod +x nginx-ops-check.sh   # Make the script executable.
./nginx-ops-check.sh          # Run the Nginx health check script.
```

## Run Linux Operations Report

```bash
chmod +x linux-ops-report.sh   # Make the script executable.
./linux-ops-report.sh          # Generate the Linux operations report.
ls -la reports                 # List the generated report files.
```

## Useful Script Safety Options

```bash
set -euo pipefail    # Enable safer Bash script execution.
```

Meaning:

- `set -e` — Exit immediately if any command fails.
- `set -u` — Exit when using an undefined variable.
- `pipefail` — Return an error if any command in a pipeline fails.