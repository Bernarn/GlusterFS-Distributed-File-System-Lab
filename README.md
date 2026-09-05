# GlusterFS Distributed File System Lab

A hands-on Distributed File System (DFS) project that evaluates several DFS technologies and implements a replicated **GlusterFS** volume across two Ubuntu virtual machines.

This repository is based on the **DST 4010 – Project Two: DFS Implementation** coursework at United States International University-Africa.

## Project Goals

The project focuses on the classic distributed file system challenges identified in the report:

- **Data consistency** across replicated locations
- **Concurrent access control** when multiple clients read or write files
- **Synchronization and replication** between storage nodes
- **Scalability** through a distributed, scale-out architecture
- **Fault tolerance and high availability**
- **Security** through authentication, authorization, and encryption capabilities

## DFS Technologies Considered

| Feature | GlusterFS | CephFS | MooseFS | LizardFS |
|---|---|---|---|---|
| Architecture | Decentralized / shared-nothing | Metadata Server + distributed OSDs | Master + chunkservers | Master + chunkservers |
| Consistency | Strong consistency with replicated volumes | Strong consistency | Strong consistency | Strong consistency |
| Synchronization | Replication with self-healing | CRUSH-based internal replication | Master-directed replication | Similar to MooseFS |
| Concurrent Access | File-level locking | Distributed locking through MDS | File-level locking | File-level locking |
| Complexity | Low to moderate | High | Low | Low |

## Why GlusterFS?

GlusterFS was selected because it provides:

- A decentralized architecture without a dedicated metadata server
- Replicated volumes for data redundancy
- Automatic File Replication (AFR)
- File-level locking for concurrent access
- POSIX-style file system behavior
- Horizontal scalability by adding storage nodes
- Self-healing capabilities after node or replica recovery

## Lab Architecture

```mermaid
flowchart LR
    C[Client / Mount Point] -->|GlusterFS mount| S1[Server 1\nGlusterFS Brick]
    C -->|GlusterFS mount| S2[Server 2\nGlusterFS Brick]
    S1 <-->|Replica 2 synchronization| S2

    S1 --> B1[/data/brick/gv0]
    S2 --> B2[/data/brick/gv0]
```

The implementation uses two Ubuntu virtual machines connected through a host-only network. Each server contributes a GlusterFS brick, and both bricks form a replicated volume named `gv0`.

## Suggested Environment

Each Ubuntu VM should have approximately:

- 2 CPU cores
- 2 GB RAM
- 20 GB storage
- Root or `sudo` access
- A host-only network adapter
- Network connectivity between both servers

Example hostnames used throughout this repository:

```text
server1
server2
```

Example private IP addresses:

```text
192.168.56.101 server1
192.168.56.102 server2
```

Replace these values with the actual addresses assigned to your VMs.

## Repository Structure

```text
glusterfs-distributed-file-system-lab/
├── README.md
├── .gitignore
├── docs/
│   ├── DFS_Report.pdf
│   └── implementation-notes.md
├── scripts/
│   ├── 01-install-glusterfs.sh
│   ├── 02-configure-hosts.sh
│   ├── 03-create-replicated-volume.sh
│   ├── 04-mount-volume.sh
│   └── 05-test-replication.sh
└── screenshots/
    └── README.md
```

## Quick Start

### 1. Configure networking

Determine each machine's IP address:

```bash
ip addr show | grep inet
```

Make sure `server1` and `server2` can resolve one another. You can use the included helper script:

```bash
sudo ./scripts/02-configure-hosts.sh 192.168.56.101 192.168.56.102
```

Test connectivity:

```bash
ping -c 4 server2
ping -c 4 server1
```

### 2. Install GlusterFS on both servers

Run on **both** machines:

```bash
chmod +x scripts/*.sh
sudo ./scripts/01-install-glusterfs.sh
```

### 3. Create the trusted storage pool

From **server1**:

```bash
sudo gluster peer probe server2
sudo gluster peer status
```

### 4. Create the replicated volume

Create the brick directory on both servers:

```bash
sudo mkdir -p /data/brick/gv0
```

Then, from **server1**:

```bash
sudo ./scripts/03-create-replicated-volume.sh server1 server2
```

Verify:

```bash
sudo gluster volume info gv0
```

### 5. Mount the distributed volume

On a client or one of the servers:

```bash
sudo ./scripts/04-mount-volume.sh server1
```

The volume will be mounted at:

```text
/mnt/glusterfs
```

### 6. Test replication

Create a test file through the mounted GlusterFS volume:

```bash
sudo ./scripts/05-test-replication.sh
```

Then verify the file exists in the brick directory on the other server:

```bash
ls -la /data/brick/gv0
```

## Useful GlusterFS Commands

Check peer status:

```bash
sudo gluster peer status
```

Check volume information:

```bash
sudo gluster volume info gv0
```

Check volume status:

```bash
sudo gluster volume status gv0
```

Start a volume:

```bash
sudo gluster volume start gv0
```

Stop a volume:

```bash
sudo gluster volume stop gv0
```

## Verification Scenario

A successful test should demonstrate that:

1. A file is created from the mounted GlusterFS directory.
2. The file becomes visible on the underlying brick storage.
3. The replicated copy is available across the configured storage nodes.
4. The GlusterFS volume remains available through the client mount point.

## What This Project Demonstrates

This lab provides practical experience with:

- Distributed storage architecture
- Node-to-node networking
- Replicated file systems
- Storage pools and bricks
- Data replication
- Consistency and concurrency concepts
- Linux administration
- Fault-tolerant system design

## Original Report

The full group report used for this project is available here:

```text
docs/DFS_Report.pdf
```

## Contributors

- Bernard Godonou
- Seline Atieno Ochieng
- Pauline Sindayo
- Boum Nkot

## Course

**DST 4010 — Fall 2025**  
United States International University-Africa

---

> This repository is intended for academic and learning purposes. Test the setup in a controlled virtual-machine environment before adapting it to production infrastructure.
