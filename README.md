# SAM Cloud Lab

Browser-based development environment with code-server, Python, C/C++, Git, and QEMU software emulation.

## Deploy on Render

1. Push all project files to GitHub.
2. Open Render and select **New → Web Service**.
3. Connect the GitHub repository.
4. Select Docker as the runtime.
5. Add an environment variable:

   - Key: `PASSWORD`
   - Value: your own strong, unique password

6. Deploy the service.
7. Open its URL and enter your password.

Do not deploy this project as a Static Site.

## Use the IDE

Open the integrated terminal inside code-server.

Create a virtual machine disk:

```bash
vm-create debian-test 8G
```

Place a bootable Linux installer ISO in `/workspace/isos/`.

Launch the VM:

```bash
vm-run debian-test /workspace/isos/installer.iso 1024 1
```

Inspect its serial output:

```bash
tail -f /workspace/vms/debian-test.log
```

Stop it:

```bash
vm-stop debian-test
```

## Important limitations

- QEMU uses TCG software emulation; KVM is not required.
- Software emulation can be slow.
- This basic configuration provides a serial log, not a graphical VM console.
- Render may restart the service or limit background VM workloads.
- Container storage may be ephemeral. Attach supported persistent storage if available and keep backups.
- Guest networking does not automatically expose guest ports publicly.
- Actual availability and performance depend on your Render service plan and limits.
