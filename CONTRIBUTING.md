# Contributing to koompi-nimmit

Thank you for considering contributing to KOOMPI Nimmit!

## How to Contribute

### Reporting Bugs

1. Check existing issues first
2. Use the bug report template
3. Include:
   - OS and version
   - Install method (interactive vs non-interactive)
   - Full error messages
   - Steps to reproduce

### Suggesting Features

1. Check existing issues and feature requests
2. Use the feature request template
3. Describe the use case clearly
4. Consider if it fits the project's scope

### Submitting Code

1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Follow the code style below
4. Commit with conventional commits: `feat:`, `fix:`, `docs:`, `test:`, `chore:`
5. Push to your fork
6. Open a pull request

## Code Style

### Shell scripts
- Use `shellcheck` for linting
- Follow the existing style in `install.sh`
- Use `set -euo pipefail`
- Quote all variables

### Markdown
- Use `markdownlint` for linting
- Keep lines under 80 characters
- Use proper heading hierarchy

## Testing

Test your changes:
```bash
# Shellcheck
shellcheck install.sh

# Markdown lint
markdownlint README.md CONTRIBUTING.md

# Test install (dry-run)
bash install.sh --help
```

## Project Structure

```
koompi-nimmit/
├── install.sh          # Main installer
├── brain/              # AI brain template
├── config/             # Configuration templates
├── skills/             # User-facing skills
├── systemd/            # Service files
├── templates/          # App templates
└── worker/             # Background workers
```

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
