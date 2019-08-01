
# Bash Cheat Sheet

This is a cheatsheet of some of my frequent shell commands so I don't have to scour StackOverflow each time.


## Mounting USB Drive

Finding device and seeing usage
```bash
df -h
```
Or `lsblk`

Mount
```bash
sudo mount /dev/sda1 /media/usb
```

Unmount
```bash
sudo umount /media/usb
```

## Background tasks

Starting task
```bash
nohup long-running-command &
```

Viewing output
```bash
tail -f nohup.out
```

Getting task PID
```bash
pgrep 'nohup|curl|Down'
```

Killing task
```bash
kill 000 000
```

## Speedtest

### LAN

On server:
```bash
iperf -s
```

On client:
```bash
iperf -c 192.168.0.14 -p 5001 -d
```

### WLAN

Speedtest.net (requires Python)
```bash
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
```

## Find process that uses file

```bash
lsof | grep filename
```

## Benchmark HDD

Calculate the actual result by diving bytes copied by real time
```bash
time sh -c "dd if=/dev/zero of=testfile bs=100k count=1k && sync"
```

## Clean old Ubuntu kernels

```bash
echo $(dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p') $(dpkg --list | grep linux-headers | awk '{ print $2 }' | sort -V | sed -n '/'"$(uname -r | sed "s/\([0-9.-]*\)-\([^0-9]\+\)/\1/")"'/q;p') | xargs sudo dpkg --purge
```

## Find inode count

```bash
sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -n
```

## Quick proxy server to other ip/port

```bash
sudo socat TCP-LISTEN:<PORT>,reuseaddr,fork,su=nobody TCP:<IP>:<PORT>
```
