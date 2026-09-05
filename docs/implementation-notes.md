# Implementation Notes

## Problem Context

The project evaluates distributed file system options for an environment that needs consistent replicated data, synchronized storage nodes, concurrent file access, scalability, and fault tolerance.

## Selected Technology

GlusterFS was selected for the implementation because of its decentralized, scale-out architecture and replicated-volume model.

## Topology

- `server1`: Ubuntu VM running GlusterFS
- `server2`: Ubuntu VM running GlusterFS
- Brick path on both nodes: `/data/brick/gv0`
- Volume name: `gv0`
- Replica count: `2`
- Client mount point: `/mnt/glusterfs`

## Implementation Sequence

1. Create two Ubuntu virtual machines.
2. Add a host-only network interface.
3. Configure hostname resolution in `/etc/hosts`.
4. Verify connectivity with `ping`.
5. Install and enable the GlusterFS server service.
6. Probe `server2` from `server1`.
7. Create `/data/brick/gv0` on both nodes.
8. Create a replicated GlusterFS volume.
9. Start the volume.
10. Mount it on a client or one of the servers.
11. Create a file through the mounted volume.
12. Confirm that the file is present on the replicated storage.

## Notes

The IP addresses in the scripts are examples. Use the actual private addresses assigned to your virtual machines.
