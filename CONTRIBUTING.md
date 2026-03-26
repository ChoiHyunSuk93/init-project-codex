# Contributing

Thanks for taking the time to contribute.

## Workflow

Please do not push directly to `main`. Create a branch for your work and open a pull request.

1. Fork the repository.
2. Create a branch from the latest `main`.
3. Make your changes.
4. Open a pull request against `main`.

Example:

```bash
git checkout main
git pull origin main
git checkout -b short-description-of-change
```

## Pull Requests

- Keep pull requests small and focused.
- Explain what changed and why.
- Include testing notes, even if no tests were run.
- Update documentation when the change affects how the project is used or understood.

## Versioning

This repository uses semantic version tags in the `vMAJOR.MINOR.PATCH` format.

- Start public releases at `v0.1.0`.
- Create release tags only from commits already merged into `main`.
- Treat release tags as immutable. Do not move, recreate, or delete a published release tag.
- Use `PATCH` for fixes and small behavior-preserving maintenance updates.
- Use `MINOR` for additive changes that keep existing usage and repository outputs compatible.
- Use `MAJOR` for breaking changes to skill behavior, generated control structure, or documented upgrade expectations.
- Use prerelease tags such as `v0.2.0-rc.1` only when maintainers want a testable release candidate before the final tag.

Release flow:

```bash
git checkout main
git pull origin main
git tag vX.Y.Z
git push origin vX.Y.Z
```

## Welcome Changes

The following contributions are a good fit for this repository:

- bug fixes
- documentation improvements
- tests
- focused usability improvements
- small features that fit the project scope

If you want to propose a larger change, open an issue first so the direction can be discussed before implementation.

## Collaboration

Be respectful, assume good intent, and keep discussion constructive. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
