# Multi-Distro Docker Package Test (YS Implementation)

This project demonstrates equivalent package installation and usage across different
Linux distributions using Docker, implemented using YS (YAML Script).
It generates Dockerfiles for multiple distributions that install the same core
utilities and provides a test framework to verify their functionality.

## Project Structure

```
.
├── README.md              # This documentation
├── Dockerfile.ys          # YS script to generate Dockerfiles
├── make-dockerfile.ys     # YS module for Dockerfile generation
├── distros.yaml          # Distribution base image definitions
├── package-map.yaml      # Package name mappings across distros
└── Makefile              # Build and test automation
```

## Supported Distributions

The following distributions are supported via `distros.yaml`:
- Ubuntu 22.04
- Alpine 3.19
- Fedora 39
- openSUSE Leap 15.5

## Core Packages

Each Docker image includes these essential tools:
- `bash` - Bourne Again Shell
- `curl` - Command line tool for transferring data
- `jq` - Command-line JSON processor
- `git` - Version control system
- `python3` - Python programming language interpreter
- `make` - Build automation tool
- `zip/unzip` - Archive compression tools
- `ag` - The Silver Searcher for text searching
- `which` - Command location utility
- `net-tools` - Network utilities
- `process-tools` - Process management utilities

## YS Implementation

The project uses YS to generate Dockerfiles dynamically. Key components:

### Dockerfile.ys
The main entry point that specifies required packages and calls the Dockerfile
generator.

### make-dockerfile.ys
Contains the logic for:
- Loading distribution configurations
- Package name mapping across distributions
- Distribution-specific installation commands
- Dockerfile template generation

### Package Mapping
`package-map.yaml` handles distribution-specific package names. For example:
- Text Search: `silversearcher-ag` (Ubuntu) → `the_silver_searcher` (others)
- Process Utils: `psmisc` (Ubuntu) → `procps` (Alpine) → `procps-ng` (Fedora)

## Requirements

- Docker
- GNU Make
- YS (YAML Script) interpreter
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

## Adding New Distributions

To add support for a new distribution:

1. Add the base image to `distros.yaml`:
   ```yaml
   newdistro: organization/image:tag
   ```

2. Add package mappings to `package-map.yaml` if needed:
   ```yaml
   some-package:
     newdistro: distribution-specific-name
   ```

3. Add installation command to `make-dockerfile.ys`:
   ```yaml
   defn run-newdistro(packages): |
     # Distribution-specific installation commands
   ```

The new distribution will automatically be included in build and test targets.
