# System Profile — 2026-03-12

## Executive summary
- **Host type:** Google Compute Engine VM (`Google Compute Engine`, `e2-medium`) in **asia-northeast3-a**.
- **OS:** Ubuntu 22.04.5 LTS (Jammy), kernel `6.8.0-1048-gcp`.
- **CPU:** 2 vCPU total, Intel Xeon @ 2.20 GHz (GCE metadata reports Broadwell platform).
- **Memory:** ~3.8 GiB RAM total, ~1.4 GiB available at capture time.
- **Swap:** none configured.
- **Disk:** 30 GiB persistent balanced disk, root ext4 filesystem with ~17 GiB free.
- **Current pressure:** disk is fine, but **RAM/CPU are the real constraints**. Load average was very high for a 2-vCPU VM due to active `bun`/`qmd` jobs.
- **Networking/cloud clues:** internal GCE network (`10.178.0.3`), external NAT IP present via metadata, Tailscale also installed.
- **Runtime stack:** Python 3.10.12, Node 22.22.1, npm 10.9.4, Bun 1.3.10, OpenClaw 2026.3.8.

## OS / platform
- `PRETTY_NAME="Ubuntu 22.04.5 LTS"`
- Kernel: `Linux 6.8.0-1048-gcp`
- Virtualization: `kvm`
- Hardware vendor/model: `Google` / `Google Compute Engine`
- Hostname: `instance-20260308-084403`

## Is this GCE?
Yes.

Evidence:
- `hostnamectl` reports `Hardware Vendor: Google`, `Hardware Model: Google Compute Engine`.
- DMI product name is `Google Compute Engine`.
- Metadata server is reachable enough to return instance JSON.
- Instance metadata identifies:
  - **machineType:** `e2-medium`
  - **zone:** `asia-northeast3-a`
  - **image:** Ubuntu 22.04 image from `ubuntu-os-cloud`
  - **external IP:** `34.64.201.153`
  - **disk type:** `PERSISTENT-BALANCED`
  - **preemptible:** `FALSE`
  - **onHostMaintenance:** `MIGRATE`

Note: a metadata HEAD request returned HTTP 405, so a naive connectivity probe printed `GCE_METADATA_FAIL`; the GET request succeeded and confirms GCE.

## CPU
From `lscpu` / metadata:
- Architecture: `x86_64`
- **CPU(s): 2**
- Topology: 1 socket, 1 core, 2 threads
- Model: `Intel(R) Xeon(R) CPU @ 2.20GHz`
- GCE CPU platform: `Intel Broadwell`

Operational meaning:
- This is a **small VM**.
- Parallel local builds, embeddings, indexing, or search over nontrivial corpora will saturate CPU quickly.

## Memory / swap
At capture time:
- **MemTotal:** 4,007,080 kB (~3.8 GiB)
- **MemAvailable:** 1,445,828 kB (~1.4 GiB)
- `free -h`: 2.2 GiB used / 117 MiB free / 1.5 GiB cache / 1.4 GiB available
- **SwapTotal:** 0 kB

Operational meaning:
- No swap means memory spikes are more dangerous; heavy indexers/build tools may be OOM-killed instead of slowing down.
- Safe working memory budget for ad hoc jobs is modest unless other services/processes are idle.

## Storage / filesystems
### Block devices
- Main disk: **`/dev/sda` 30G** (`PersistentDisk`)
- Root partition: `/dev/sda1` ext4, mounted at `/`
- EFI partition: `/dev/sda15` vfat, mounted at `/boot/efi`

### Filesystem usage
- Root `/`: **29G total / 13G used / 17G free / 44% used**
- EFI: 105M total / 6.1M used / 99M free

### Inode pressure
- Root `/`: **7% inode usage**

Operational meaning:
- **Disk capacity is currently comfortable** for source trees, package caches, and moderate local indexes.
- Filesystem pressure is low; storage is not the immediate bottleneck.

## Uptime / load / current contention
- Uptime: **3 days, 15.5 hours**
- Load average: **11.59 / 5.09 / 2.12**

For a 2-vCPU host, this indicates the machine was **severely CPU-contended at capture time**.

Top observed processes:
- `bun ... qmd.js query ...` consuming ~140% CPU and ~46% RAM
- another `bun ... qmd.js query ...` consuming ~26% CPU and ~40% RAM
- `openclaw-gateway` using additional CPU/RAM

Operational meaning:
- The machine can become overloaded even from a small number of local search/query jobs.
- Before kicking off indexing/build work, check whether memory-query/search processes are already active.

## Networking / cloud clues
Interfaces:
- `ens4`: `10.178.0.3/32`
- `tailscale0`: `100.86.95.86/32`
- loopback present as normal

Routes / naming clues:
- Default gateway via `10.178.0.1`
- Metadata route to `169.254.169.254`
- Resolver search domains include:
  - `asia-northeast3-a.c.openclawbmk.internal`
  - `c.openclawbmk.internal`
  - `google.internal`
  - Tailscale search suffix

Operational meaning:
- This host sits on a standard GCE VPC with external NAT.
- Tailscale is active, so private overlay connectivity is available.

## Toolchain / runtime versions
- **Python:** `Python 3.10.12`
- **python:** not installed as `python` shim/alias (`python: command not found`)
- **Node.js:** `v22.22.1`
- **npm:** `10.9.4`
- **Bun:** `1.3.10`
- **OpenClaw:** `OpenClaw 2026.3.8 (3caab92)`
- OpenClaw path: `/home/javajinx7/.npm-global/bin/openclaw`

## Notable running services
Observed running services include:
- `ssh.service`
- `cron.service`
- `chrony.service`
- `snapd.service`
- `tailscaled.service`
- `google-guest-agent.service`
- `google-osconfig-agent.service`
- `google-cloud-ops-agent-fluent-bit.service`
- `google-cloud-ops-agent-opentelemetry-collector.service`
- `systemd-resolved.service`
- `systemd-networkd.service`
- `unattended-upgrades.service`
- `openclaw-gateway` process active

Operational meaning:
- This is an actively managed cloud VM with GCE guest tooling, logging/metrics agents, SSH, Tailscale, and OpenClaw services already consuming a nontrivial baseline of RAM/CPU.

## Practical recommendations for local AI/search/indexing/build work
### Good fits
- Small to moderate code edits and builds
- Lightweight local search/query tasks
- Small embeddings/index updates in serialized batches
- Running one heavier task at a time while the machine is otherwise quiet

### Poor fits / caution
- Concurrent indexing + builds + memory search at once
- Large vector indexing jobs
- Large TypeScript/JS monorepo builds under load
- Running multiple Bun/Node workers in parallel on the same dataset
- Any workload that assumes swap exists or that 4+ cores are available

### Recommended operating constraints
1. **Serialize heavy jobs.** Treat this host as effectively a one-heavy-task-at-a-time machine.
2. **Avoid parallel index/query workers.** Existing `qmd`/Bun jobs already drive load very high.
3. **Watch memory headroom.** With no swap, keep at least ~1 GiB available before starting memory-hungry jobs.
4. **Prefer remote/off-box execution** for large indexing, batch embedding generation, large compiles, or anything likely to run >2 CPU cores effectively.
5. **Keep disk local, compute remote** when possible: storing repos/cache locally is fine; large-scale processing is not ideal here.
6. **If local heavy work becomes common, upgrades worth considering** are:
   - more RAM first (8 GiB+)
   - then more vCPU (4 vCPU+)
   - optional swap as a safety valve, though not a substitute for real RAM

## Bottom line
This is a **small but usable OpenClaw/GCE workstation VM**: good for orchestration, light coding, light local search, and single-stream background work. The limiting factors are **2 vCPU, ~4 GiB RAM, and zero swap**. Disk space is fine. For anything beyond modest local AI/search/index/build workloads, prefer **queueing/serialization or offloading to a larger machine**.
