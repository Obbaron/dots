# dots

Personal, distro-agnostic machine config in the `ansible-pull` model: each host
checks out this repo at a pinned tag and configures **itself** — no control
node, no swarm.

## How selection works

1. `ansible-pull` limits the run to the machine's own hostname.
2. The `inventory` file maps that hostname to a local connection.
3. `host_vars/<hostname>.yml` sets `profile:` for the host.
4. `group_vars/all.yml` maps that profile to a list of roles.

## First-time setup on a host

```sh
ansible-galaxy collection install -r requirements.yml
```

## Apply (pinned to a tag)

```sh
ansible-pull -U https://github.com/you/dots.git -C v0.1.0 -i inventory local.yml
```

- `-C v0.1.0` — checkout tag: your version pinning.
- `-o` — add this so a scheduled run only fires when the tag moved.

## Preview (dry run)

```sh
ansible-pull -U <repo> -C v0.1.0 -i inventory --check --diff local.yml
```

## Test locally from a clone

```sh
ansible-playbook -i inventory --limit "$(hostname)" --check --diff local.yml
```

Use `--limit "$(hostname)"` so a manual run targets only this box, not every
host in the inventory.

## Adding a slice

- Create `roles/<name>/` with `tasks/main.yml` (+ `vars/` for distro names).
- Add `<name>` to the relevant profile in `group_vars/all.yml`.
- Override package names per OS only where they diverge (`vars/RedHat.yml`, …).
