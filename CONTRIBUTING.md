# Contributing to Teil Packages

## Things you will need

- Linux, Mac OS X, or Windows.
- [git](https://git-scm.com) (used for source version control).
- An ssh client (used to authenticate with GitHub).
- An IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/).

## Forking & cloning the repository

- Ensure all the dependencies described in the previous section are installed.
- Fork `https://github.com/voll-labs/teil_packages` into your own GitHub account. If
  you already have a fork, and are now installing a development environment on
  a new machine, make sure you've updated your fork so that you don't use stale
  configuration options from long ago.
- If you haven't configured your machine with an SSH key that's known to github, then
  follow [GitHub's directions](https://help.github.com/articles/generating-ssh-keys/)
  to generate an SSH key.
- `git clone git@github.com:<your_name_here>/teil_packages.git`
- `git remote add upstream git@github.com:voll-labs/teil_packages.git` (So that you
  fetch from the master repository, not your clone, when running `git fetch`
  et al.)

## Environment Setup

Teil Packages uses [Melos](https://github.com/invertase/melos) to manage the project and dependencies.

To install Melos, run the following command from your SSH client:

```bash
dart pub global activate melos
```

Next, at the root of your locally cloned repository bootstrap the projects dependencies:

```bash
melos bootstrap
```

The bootstrap command locally links all dependencies within the project without having to
provide manual [`dependency_overrides`](https://dart.dev/tools/pub/pubspec). This allows all
plugins, examples and tests to build from the local clone project.

> You do not need to run `flutter pub get` once bootstrap has been completed.

> If you're using [fvm](https://fvm.app/) you might need to specify the sdk-path: `melos bs --sdk-path=/Users/user/fvm/default/`

### Using Melos

To help aid developer workflow, Melos provides a number of commands to quickly run
tests against plugins. For example, to run all tests across all packages at once,
run the following command from the root of your cloned repository:

```bash
melos run test
```

A full list of all commands can be found within the [`melos.yaml`](./melos.yaml)
file.

## Opening a Pull Request

Our team uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when coding and creating PRs. This standard makes it easy for our team to review and identify commits in our repo quickly and auto generate [CHANGELOG](./CHANGELOG.md).

PR titles should follow the format below:

```jsx
<type>(optional scope): <description>
```

1. **fix:** a commit of the _type_ `fix` patches a bug in the codebase.
2. **feat:** a commit of the _type_ `feat` introduces a new feature to the codebase.
3. _types_ other than `fix:` and `feat:` are allowed, recommends `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, and others.

## Publishing a new version

Only maintainers can publish a new version of the package. To do so, follow these steps:

1. Make sure you have the latest changes from the `main` branch.
2. Run `melos version` and follow the instructions.
3. Run `melos publish --no-dry-run` to publish all packages.
4. Push the changes to the `main` branch and create a new release on GitHub.
