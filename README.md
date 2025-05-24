# Multi-Distro Docker Package Test

This project demonstrates equivalent package installation and usage across different
Linux distributions using Docker. It includes Dockerfiles for multiple
distributions that install the same core utilities and a test framework to verify
their functionality.

## Included Packages

Each Docker image includes these essential tools:
- `bash` - Bourne Again Shell
- `curl` - Command line tool for transferring data
- `jq` - Command-line JSON processor
- `git` - Version control system
- `python3` - Python programming language interpreter
- `make` - Build automation tool
- `zip/unzip` - Archive compression tools

Additional utilities with distribution-specific names:
| Functionality | Ubuntu | Alpine | Fedora | openSUSE |
|--------------|--------|---------|---------|-----------|
| Text Search | silversearcher-ag | the_silver_searcher | the_silver_searcher | the_silver_searcher |
| Which Command | debianutils | which | which | coreutils |
| Network Tools | net-tools | iproute2 | iproute | iproute2 |
| Process Utils | psmisc | procps | procps-ng | procps |

## Supported Distributions

- Ubuntu 22.04
- Alpine 3.19
- Fedora 39
- openSUSE Leap 15.5

## Requirements

- Docker
- GNU Make
- Bash shell

## Usage

### Building Images

Build all distribution images:
```bash
make build
```

Build a specific distribution image:
```bash
make image-ubuntu    # For Ubuntu
make image-alpine    # For Alpine
make image-fedora    # For Fedora
make image-opensuse  # For openSUSE
```

### Running Tests

The test suite verifies that all installed packages are working correctly by:
1. Using `curl` to download JSON data from GitHub's API
2. Using `git` to create a repository and commit the file
3. Using `jq` to process and extract information from the JSON
4. Using `python3` to read and process the JSON file
5. Creating and running a simple `Makefile`

Run tests for all distributions:
```bash
make test
```

Test a specific distribution:
```bash
make test-ubuntu    # For Ubuntu
make test-alpine    # For Alpine
make test-fedora    # For Fedora
make test-opensuse  # For openSUSE
```

## Project Structure

```
.
├── README.md
├── Makefile                # Build and test automation
├── Dockerfile.ubuntu       # Ubuntu image definition
├── Dockerfile.alpine       # Alpine image definition
├── Dockerfile.fedora       # Fedora image definition
└── Dockerfile.opensuse     # openSUSE image definition
```

## Makefile Features

- Automatic discovery of Dockerfiles
- Parallel build support
- Consistent naming conventions
- Automated testing
- Distribution-agnostic test suite

## Adding New Distributions

To add support for a new distribution:

1. Create a new `Dockerfile.[distro]` file
2. Install the required packages using the distribution's package manager
3. The Makefile will automatically detect and include the new distribution

The new distribution will automatically be included in build and test targets.
