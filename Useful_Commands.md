
# Useful Commands 
These are all commands that are useful and common that sometimes I forget. There is no judgement here. 

<br>

<br>

## User 
Regular commands **not** needing sudo. Useful for almost everyone 

<br> 

### OS Cheat-sheet

| Command | Description | 
|---------|-------------|
| `^<LINE>^<REPLACE>` | Replace a word from the previous command with another then execute |
| `${<VARIABLE>%<PATTERN>}` | Modify a variable's content by including a `%` for removing the end |
| `${<VARIABLE>#<PATTERN>}` | Modify a variable's content by including a `#` for removing the beginning |
| `<ESC>+<.>` | allows you to insert the argument from the last command into a new one |
| `strace <COMMAND>` | Trace a command's actions as it executes to try to troubleshoot error messages. |
| `curl -Is <IP/Webpage>` | Simple check to see if a remote webpage is accessible from a system. More useful if the system does not have a GUI and you want to check the connectivity |
| `rpm -qf <FILE>` | Determine what package(s) use/installed the specified file. |
| `cp <file>{, <extension>}` | Quickly create a copy of a file with an added extension |
| `egrep -v '^\s*\\#' <FILE> \| sed '/^\s*$/d'` | Read a file and remove standard comment lines # and blank lines to quickly read the config of it. |
| `openssl s_client -connect <HOST> : <PORT> -tls1` | Open an ssl connection to HOST |
| `openssl s_client -connect <HOST/IP>: <PORT> -tls1_1 -quiet` | Check if Insecure TLS 1.1 responds |
| `testssl -E <URI/HOST> : <PORT>` | Check the response of a server for what protocols, cypher, and order the server responds with |
| `<COMMAND> &> <FILE>` | Redirect both regular (`stdout`) and error messages (`stderr`) from a command, script, or program into a file. |
| `<COMMAND> 2>&1` | Redirect (`stderr`) to (`stdout`). It makes grep's easier as it will not let errors to be their own message |
| `<COMMAND> 1> /dev/null` | Send `stdout to NULL so you only get errors | |grep -Eo <REGEX> <FILE> | grep a file and ONLY return what matched the regex, not the line | 
| `export LESS="-ImNQRsX"` | Default less to: I Case Insensitive, `m` prompt verbose with percent in file, `N` Show line numbers (`-n` forces no line), `Q` terminal bell is never rung, `R` try to interpret colors, `s` "squeeze" consecutive blank lines into one, `X` Dont send termcap init/de-init | 
| `vim -R` | Force vim to open file in read-only (`!` **can still override** ) |
| `export <VARIABLE>=${<VARIABLE>:-<VALUE>}` | If `<VARIABLE>` is **NOT** set, then it will default to `<VALUE>` |
| `findmnt --target <DIR/FILE>` | When you give it a path, the OS will try to find where at path is mounted by searching its parent. |

<br> 

### Git Cheat-sheet 

| Command/Item | Description |
|--------------|-------------|
| `git status` | Show what is going on with the current branch |
| `git clone -b <BRANCH> <URL> --depth 1` | Only clone the most recent commit with no history |
| `git log` | Show commit history |
| `export EDITOR='</path/to/editor>'` | When rebasing or merging, resolve conflicts with your editor of choice like VS Code |
| `git pull` | Perform a fetch, then merge into branch using `merge` or `rebase` |
| `git branch -D <BRANCH>` | Delete a local branch | 
| `git reflog expire --expire=4.weeks.ago` | Expire history older than 4 weeks |
| `git gc` | "Garbage Collecting" Clean the current working directory and remove old references, prune loose objects older than 2 weeks, and compress objects. (obsolete if maintenance is on) | 
| `git repack && git prune-packed` | Review all changes in current working dir and repack them, then prune packs that no longer exist. (obsolete if maintenance is on) 
| `git maintenance start` | Instead of manually running cleanup commands, this runs a cleanup cron every HOUR in the background. This helps git run a lot faster. The maintenance that it performs is: <br> - **gc:** disabled <br> - **commit-graph:** hourly <br> - **pre-fetch:** hourly <br> - **loose-objects:** daily <br> - **incremental-repack:** daily <br> - **pack-refs:** none | 
| `git config --global alias.<NAME> <COMMAND W/O "git">` | Create a git alias that allows you to perform a command. DONT put the `git` keyword in the command portion. Run with `git <ALIAS>` | 
| `git config --global alias.<NAME> '!<SCRIPT/COMMAND>'` | Run a script or an external bash command using the git command | 
| `git config --global column.ui auto` | Set the default to show branches in a column view | 
| `git config --global branch.sort -committerdate` | Set the default to sort branches by when committed (most recent on top) | 
| `git config --global fetch-writeCommitGraph true` | Every time that a fetch is performed, update the commit graph to make fetch's faster. (obsolete if maintenance is on) | 
| `git config --global core.untrackedcache true` <br> `git config --global core.fsmonitor true` | Turn on filesystem monitor that watches inodes for changes in files so that subsequent `git status` are faster because it only looks at local *changes* instead of scanning. | 

<br>

#### git aliases 
Dont forget to start each with `git config --global` 
| Alias | Truncated Command | Description | 
|-------|-------------------|-------------|
| `alias.staash` | `'stash --all'` | Stash all uncommitted changes | 
| `alias.del` | `'branch -D'` | Delete a local branch. Supply branch name at the end 
| `alias.delr` | `'push origin --delete'` | Delete a **REMOTE** branch. Supply branch name at the end | 
| `alias.polish` | `'!git repack; git prune-packed; git gc'` | Do a full cleanup of the current branch | 
| `alias.expire` | `'reflog expire --expire=4.weeks.ago'` | Do a reflog on the current repo | 
| `alias.ls` | `'branch'` | List the local tracked branches | 
| `alias. lsr` | `'branch -r'` | List the remote branches | 
| `alias.undo` | `'reset --soft HEAD~1'` | Undo the LAST commit while preserving all changes done before committing | 
| `alias.co` | `'checkout'` | Checkout a local or remote **tracked** branch | 
| `alias. BB` | `'blame -w -C -C -C'` | "BIG BLAME": In-depth blame of a single file or line. It follows the commits to show who actually made changes IN the file. You can supply a single file or for specific lines: `git BB <START_LINE>,<END_LINE> <FILE>` | 
| `alias.BBL` | `'blame -w -C -C -C -L'` | "BIG BLAME" for specific lines in a file: `git BBL <START_LINE>, <END_LINE> <FILE>` | 
| `alias.wdiff` | `'diff --word-diff'` | Instead of showing *lines* of the diff, only show specific **items** that were changed in the location of the file |
| `alias.red` | `'rebase -i development'` | Rebase the specified branch from development | 

<br>

Use this in your `.bashrc` to do a full checkout from a development branch for a **NEW** branch locally that exists remotely. This ensures that the checkout is clean. 
To run, `gco <BRANCH>` 

```bash 
cat << EOF >> ~/.bashrc
function gco(){
git checkout development
git pull
git remote set-branches --add origin $1
git fetch
git branch -r
git checkout $1
}
EOF
```

<br>

### Generating .crt .key and .rsa from a .p12 or pfx

1. Copy the .p12 or .pfx certificate file to your home directory 
2. Generate an encryption key: `openssl pkcs12 -info -in <CERTIFICATE>. [pfx|p12] -nocerts -nodes -out <NAME>.key` 
3. Generate a signing certificate: `openssl pkcs12 -in <CERTIFICATE>.pfx -clcerts -nokeys -out <NAME>_certificate.crt`
  * for p12 -> pem: `openssl pkcs12 -in <CERTIFICATE>.p12 -c1certs -nokeys -out <NAME>_certificate.pem` 
4. Generate a RSA encryption key: `openssl rsa -in <NAME>_encryption.key -out <NAME>_encryption.rsa`

<br>

<br>

## Admin
Commands that are used to administrate a system. Probably needs Root

<br>

### Cheat-sheet 

<br> 

***Linux & Bash*** 

| Command | Description | 
|---------|-------------|
| `rpm2cpio <PATH_TO_RPM>.rpm \| cpio -idv` | **EXTRACT** all contents of an RPM to see what files/settings get added to the system into **CURRENT DIR** |
| `chronyc sources -v` | Get current NTP servers that chronyd is pointed to |
| `chronyc tracking` | Get stats for chrony config (/etc/chrony.conf) |
| `chronyc makestep` | Force chrony to step to accurate time |
| `openssl s_client -connect <SERVERNAME>: <PORT> -showcerts` | Check the certificates of a remote or local server by specifying a port. This shows you if the certificates are installed, and the client is able to verify the server cert. |
| `journalctl -axe` | look at logs even if it has very long lines (`-a`) with explanation text if available (`-x`) and go to the most recent line (`-e`) |
| `journalctl -u <SERVICE>` | Show journal for a unit/service (Can be combined with any other argument) |
| `journalctl -axf -u <SERVICE>` | Follow (`-f`) a service even during service restart |
| `journalctl -b <BOOT ID>` | View all logs from specific boot (`-b`); `-1` for previous boot, and `0` for current. (list with `--list-boots`) |
| `journalctl -k` | Show only kernel messages from the most recent boot |
| `journalctl -axe -p 0..3` | Show a single/range priority (`-p`) of log level: <br> - "emerg" (0) <br> - "alert" (1) <br> -  "crit" (2) <br> - "err" (3) <br> - "warning" (4) <br> - "notice" (5) <br> - "info" (6) <br> - "debug" (7) |
| `journalctl -ax _COMM=splunk + _UID=1000` | Show logs filtered by the value of a field. If the separator "+" is used, two expressions may be combined in a logical **OR**. Common Fields are: <br> `MESSAGE=` (Human readable message) <br> `_PID=` <br> `_UID=` <br> `_GID=` <br> `_COMM=` (Process name instead of PID) |
| `nfsstat -lc4` | Show NFSv4 Client statistics |
| `nfsstat -m` | Show nfs mounts |
| `nfsiostat-sysstat -h` | Show nfs I/O stats |
| `rpcdebug` | NFS Server/Client debug utility that prints nfs debug logs into the system log files |
| `rpcdebug -m nfsd -s proc` | Using the nfs-server module (`-m nfsd`), set (`-s`) process-level (proc) debug logs. You can also use "all" as a flag. To clear: `-m nfsd -c proc` |
| `yum history list` | List all recent yum transactions |
| `yum history info <ID_NUMBER>` | Get detailed info of what was installed/upgraded. |
| `yum history rollback <ID_NUMBER>` | Revert all installed/modified packages to a previous state. |
| `sar <SWITCH> -f /var/log/sa/<DAY_OF_MONTH>` | SA is a process that stores machine statistics into files every 10 minutes. Switches are: <br> `-A` Parse all stats <br> `-b` Parse I/O transactions <br> `-d` Parse Disk Utilization <br> `-n` Parse Network usage <br> `-u` Parse CPU statistics <br> `-r` Parse RAM max usage |
| `df -i` | List inode usage statistics per mount (including network mounts) |
|`openssl x509 -in <CERTIFICATE .pem> -noout -text` | Read the contents of a certificate file in PEM format|
| `openssl rsa -in <CERTIFICATE KEY> -noout -text` | Read the contents of a certificate key in RSA |
| `nc -zv <IP> <PORT>` | use NetCat to determine if a port is reachable on a remote host |
| `dd if=/dev/zero of=/dev/<DISK> bs=1M` | Write all zeros to a disk to completely wipe it (1 MB increments). Perfect for corrupt virtual volumes that are not the primary disk and all other actions have failed. <br> **"I'm Not Playing Around"** |
| `firewall-cmd --set-log-denied=all` | Turn on firewall dropped packets logging (Logs stored in `/var/log/firewalld_drop/`) |
| `cat /proc/net/dev` | Lowest level of checking for all connected network interfaces. Also works in rescue or emergency mode. |
| `lsblk` | List all block devices and connected mounts |
| `Ishw` | Show all hardware attached to system and driver info |
| `lspci` | Show all devices connected to PCI/PCIe |
| `lscpu` | Show CPU info including make/model/cores/speed |
| `multipath -11` | List number of HBA LUN/Volume Connections |
| `blkid` | Get the UUID of all block level devices including partitions |


<br>

### Partition Standard Disks
1. `parted -s /dev/<BLOCK_DEVICE> mklabel gpt`
2. `parted -s /dev/<BLOCK_DEVICE> mkpart primary 1MiB 100%`
3. `mkdir <MOUNT_POINT>`
4. `chown -Rf <USER>:<GROUP> <MOUNT_POINT>`
5. `chmod -Rf <NNN> <MOUNT_POINT>`
6. `echo "UUID=$(blkid -s UUID -o value /dev/<BLOCK_DEVICE>1)     <MOUNT_POINT>    defaults,nodev,nosuid  1 2" >> /etc/fstab`
7. `mount -a`

<br>

### LVM
LVM Commands:
* `` :
* `pvcreate` : Create a physical volume. 
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` : 
* `` :
* `` :
* `` :
* `` :
* `` :
* `` :
* `` : 

Quick Partition:
1. `pvcreate -f /dev/<BLOCK_DEVICE>`
2. `vgcreate -f vg_<NAME> /dev/<BLOCK_DEVICE>`
3. `lvcreate -l 100%FREE -n lv_<NAME> vg_<NAME>`
4. `mkfs.xfs /dev/mapper/vg_<NAME>-lv_<NAME>`
5. `mkdir <MOUNT_POINT>`
6. `chown -Rf <USER>:<GROUP> <MOUNT_POINT>`
7. `chmod -Rf <NNN> <MOUNT_POINT>`
8. `echo "UUID=$(blkid -s UUID -o value /dev/mapper/vg_<NAME>-lv_<NAME>)     <MOUNT_POINT>   xfs    defaults,nodev,nosuid  1 2" >> /etc/fstab`
9. `mount -a`


<br>

### Linux Self-Rescue
On RHEL 7/8 Perform the below actions if the system is unable to start the OS. **Make sure you know the GRUB password** otherwise you will have to manually rescue the device using an external ISO/Disk
1. When system is booting select the kernel you wish to booth from and hit `e`
2. You will be prompted for the GRUB password (if one has been implemented)
3. Look for the line in the Kernel that has "`linux16`" or "`linux`"; on that line append to the end `rd.break`
4. Hit `<Ctrl>+x` to start Kernel using specified settings
5. Mount the root volume: `mount -o remount rw /sysroot`
6. Change environment to use the root volume: `chroot /sysroot`
7. Perform whatever actions you want. When done you need to force the OS to "re-read" the system files
8. `touch /.autorelabel`
9. Reboot

<br>

### fsck all partitions 
1. Mount a CentOS 7 ISO
2. Power on and boot from disk
  - "Troubleshooting" 
  - "Rescue a Centos System"
3. Go directly to a shell (Select 3)
4. Scan LVM disks: `pvs`
5. Activate volume groups: `vgchange -ay`
6. Scan logical volumes: `lvs`
7. List logical volume partitions `ls -lah /dev/mapper/centos*`
8. Force fsck scan and fix:
  - For a simple journal and inode check and fix: `e2fsck -fpv /dev/mapper/centos <VOLUME>` 
  - For a badblock read/write test and fix: `e2fsck -fyccv /dev/mapper/centos <VOLUME>` 
