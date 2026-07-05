# Herdr

## Remote access over Tailscale

Herdr remote access rides on normal SSH. Tailscale only provides the private
network path; Herdr does not connect directly to Tailscale.

Official docs:

- https://herdr.dev/docs/how-to-work/#remote-work-through-normal-ssh
- https://herdr.dev/docs/persistence-remote/#remote-attach-over-ssh

### Host-side setup

Check that this Mac is online in Tailscale:

```sh
tailscale status
tailscale ip -4
```

Check whether Tailscale SSH is enabled:

```sh
tailscale debug prefs | rg '"RunSSH"'
```

If `RunSSH` is `false`, enable Tailscale SSH while preserving the current DNS
and route settings:

```sh
tailscale up --accept-routes=true --accept-dns=true --ssh=true
```

This creates a persistent SSH entry point through the tailnet. Only do this
when the tailnet ACLs are acceptable for SSH access to the Mac.

### Client-side attach

From another machine on the same tailnet, attach to the Herdr session through
SSH:

```sh
herdr --remote <user>@<tailscale-hostname>
```

The direct Tailscale IP also works:

```sh
herdr --remote <user>@<tailscale-ip>
```

For repeat use, put the Tailscale host in `~/.ssh/config`:

```sshconfig
Host herdr-mac
  HostName <tailscale-hostname>
  User <user>
```

Then attach with:

```sh
herdr --remote herdr-mac
```

If a normal SSH client is preferred, SSH first and run Herdr on the host:

```sh
ssh <user>@<tailscale-hostname>
herdr
```
