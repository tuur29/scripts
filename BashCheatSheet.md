
# Bash Cheat Sheet

This is a cheatsheet of some of my frequent shell commands so I don't have to scour StackOverflow each time.


## Mounting USB Drive

Finding device and partition
```
lsblk
sudo blkid
sudo fdisk -l
```

Mount
```
sudo mount /dev/sda1 /media/usb
```

Unmount
```
sudo umount /media/usb
```

## Background tasks

Starting task
```
nohup long-running-command &
```

Viewing output
```
tail -f nohup.out
```

Getting task PID
```
pgrep -i 'nohup|curl|download'

```
Killing task
```
kill 000 000
```

## Speedtest

### LAN

On server:
```
iperf -s
```

On client:
```
iperf -c 192.168.0.14 -p 5001 -d
```

### WLAN

Speedtest.net (requires Python)
```
curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
```

## Find process that uses file

```
lsof | grep filename
```

## Benchmark HDD

Calculate the actual result by diving bytes copied by real time
```
time sh -c "dd if=/dev/zero of=testfile bs=100k count=1k && sync"
```
