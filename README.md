# Usage

Create at least two droplets in DO: `kuber-master`, `kuber-node-01`, ...

On a **master** node run:
- `cd /opt/kuber/master`
- `/bin/bash install.sh`
- copy the join command to paste it later to the nodes
- `/bin/bash user.sh`

On **the nodes**:
- `cd /opt/kuber/master`
- `/bin/bash install.sh`
- `/bin/bash user.sh`
- still as root run:
- previously copied join command
- if you haven't copied the join command do below:
   - `kubeadm token create --print-join-command`
   - paste and execute