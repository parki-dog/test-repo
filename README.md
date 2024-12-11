# Asclepyus Python Project Template

An internal Python project template for Asclepyus projects, featuring automated setup and release management.

## Features

- 🚀 Automatic project renaming and configuration
- 📦 Poetry for dependency management
- 📝 MkDocs for documentation
- 🔄 Automated releases with semantic versioning
- ✨ Pre-commit hooks for code quality
- 🧪 Ready for testing

## Prerequisites

1. GitHub Personal Access Token (PAT)
   - Must be stored as an organization secret named `Workflow_PAT`
   - Required permissions:
     - `repo` (Full control of private repositories)
     - `workflow` (Update GitHub Action workflows)
   - [How to create a PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)
   - [How to add organization secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-organization)

## Quick Start

1. Click the "Use this template" button at the top of this repository
2. Clone your new repository
3. The template will automatically configure itself on your first push:
   - Renames all placeholder references
   - Sets up the project structure
   - Configures GitHub Actions

## Development Setup

Run the setup script:
```bash
./setup.bat
```

## Creating Releases

Releases are automatically created when you push to main. The version bump is determined by PR labels and/or description:
- `major`: Breaking changes
- `minor`: New features
- `patch`: Bug fixes

## Documentation

- Run locally:
  ```bash
  poetry run mkdocs serve
  ```
- View at: http://localhost:8000

## Project Structure

```
├── .github/          # GitHub Actions workflows and templates
├── docs/            # Documentation
├── src/             # Source code
    └── package_name/ # Default package (will be renamed to your repository name)
└── tests/           # Test files
```

> **Note**: By default, the package name under `src/` will be set to your repository name. If you want to use a different name, make sure to also update the package name in the [release workflow](.github/workflows/release.yml#L34).

## License

This project is licensed under the MIT License - see the LICENSE file for details.