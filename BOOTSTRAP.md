# Bootstrap

Getting a fresh machine to the point where `ansible-pull` can apply a profile.

## Prerequisites

- **git** and **ansible-core** installed via the distro package manager:
  - Arch: `sudo pacman -S git ansible`
  - Fedora: `sudo dnf install git ansible-core`
- The machine's **hostname must equal its inventory name** (`optiplex`, `bigboi`,
  `arbiter`). `ansible-pull` limits the run to the current host by hostname, and
  that name is how group/host vars attach.

## One-time per machine: install the collection

`ansible-pull` clones the repo and runs the playbook, but it does **not** install
Galaxy collections for you. `community.general` provides the package backends for
pacman/zypper/apk/xbps/portage, so install it once, up front:

```sh
ansible-galaxy collection install community.general ansible.posix
```

(Or, from an existing checkout: `ansible-galaxy collection install -r requirements.yml`.)

## Apply a profile (pinned to a tag)

```sh
REPO=https://github.com/<you>/dots.git
DEST=~/.local/share/dots

# preview — change nothing
ansible-pull -U "$REPO" -C v0.1.0 -d "$DEST" -i inventory local.yml -- --check --diff

# apply
ansible-pull -U "$REPO" -C v0.1.0 -d "$DEST" -i inventory local.yml
```

- `-C v0.1.0` pins to a release tag (reproducible state).
- `-d "$DEST"` is the **permanent** checkout — the symlinks the roles create point
  into it, so don't delete or move it.
- Everything after `--` is passed through to `ansible-playbook`.

## Profile selection

- **Group** membership sets the default profile (`group_vars/<group>.yml`).
- **Host** override wins: `host_vars/<hostname>.yml`. During bring-up `optiplex`
  is pinned to `minimal`; delete that line to let it inherit `htpc` from its group.

## Cutting a release

Pulls target tags, not `main`, so publish a tag when a state is ready:

```sh
git commit -am "..."
git tag v0.1.0
git push origin v0.1.0
```

To re-point an existing tag during early iteration:

```sh
git tag -f v0.1.0 && git push -f origin v0.1.0
```
