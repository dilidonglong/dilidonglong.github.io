---
title: CPU性能排查笔记
date: 2021-03-22 21:24:23
categories: linux
tags:
---

## 1.平均负载

平均负载load average：是单位时间内的平均活跃进程数，它和 CPU 使用率并没有直接关系

活跃进程数：系统处于**可运行状态**和**不可中断状态**的进程数

可运行状态进程：*正在使用 CPU* 或者*正在等待 CPU*的进程

不可中断状态的进程：正处于内核态关键流程中的进程，并且这些流程是不可打断的，比如最常见的是等待硬件设备的 I/O 响应

```bash
[root@ecs-M79hl ~]# uptime
 21:39:02 up 30 days,  9:30,  1 user,  load average: 0.05, 0.09, 0.04
或
[root@ecs-M79hl ~]# watch -d uptime
```

<!--more-->

<br>

### 1.1 平均负载与CPU使用率的区别

CPU使用率高，平均负载就会高；平均负载高不一定就表示CPU使用率高。因为影响平均负载的除了可运行状态进程，还有不可中断状态的进程。

<br>

### 1.2 命令

#### 1.2.1 查看CPU核数

平均负载最理想的情况是等于 CPU 个数，当平均负载比 CPU 个数还大的时候，系统已经出现了过载。

```bash
grep 'model name' /proc/cpuinfo | wc -l2
```

当平均负载高于 CPU 数量 70% 的时候，就应该分析排查负载高的问题了。一旦负载过高，就可能导致进程响应变慢，进而影响服务的正常功能。

<br>

#### 1.2.2 mpstat查看整体CPU使用率变化情况

mpstat可以查看CPU使用率情况，其中-P ALL 表示监控所有CPU，后面数字5表示间隔5秒后输出一组数据

```bash
[root@ecs-u4x ~]# mpstat -P ALL 5
Linux 5.4.11-1.el7.elrepo.x86_64 (ecs-u4x) 	03/22/2021 	_x86_64_	(1 CPU)

09:48:23 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
09:48:28 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.20    0.00    0.00   99.80
09:48:28 PM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.20    0.00    0.00   99.80

09:48:28 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
09:48:33 PM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
09:48:33 PM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00

```

user（通常缩写为 us），代表用户态 CPU 时间。注意，它不包括下面的 nice 时间，但包括了 guest 时间。

nice（通常缩写为 ni），代表低优先级用户态 CPU 时间，也就是进程的 nice 值被调整为 1-19 之间时的 CPU 时间。这里注意，nice 可取值范围是 -20 到 19，数值越大，优先级反而越低。

system（通常缩写为 sys），代表内核态 CPU 时间。

idle（通常缩写为 id），代表空闲时间。注意，它不包括等待 I/O 的时间（iowait）。

iowait（通常缩写为 wa），代表等待 I/O 的 CPU 时间。

irq（通常缩写为 hi），代表处理硬中断的 CPU 时间。

softirq（通常缩写为 si），代表处理软中断的 CPU 时间。

steal（通常缩写为 st），代表当系统运行在虚拟机中的时候，被其他虚拟机占用的 CPU 时间。

guest（通常缩写为 guest），代表通过虚拟化运行其他操作系统的时间，也就是运行虚拟机的 CPU 时间。

guest_nice（通常缩写为 gnice），代表以低优先级运行虚拟机的时间。

<br>

#### 1.2.3 pidstat查看具体进程的CPU使用率情况

pidstat -u 5 1表示间隔5秒后输出一组数据

```bash
[root@ecs-u4x ~]# pidstat -u 5 1
Linux 5.4.11-1.el7.elrepo.x86_64 (ecs-u4x) 	03/22/2021 	_x86_64_	(1 CPU)

09:51:48 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
09:51:53 PM     0      3498    0.20    0.00    0.00    0.20     0  tuned
09:51:53 PM     0     28812    0.00    0.20    0.00    0.20     0  kworker/0:2-events_power_efficient
09:51:53 PM     0     30799    0.00    0.20    0.00    0.20     0  pidstat

Average:      UID       PID    %usr %system  %guest    %CPU   CPU  Command
Average:        0      3498    0.20    0.00    0.00    0.20     -  tuned
Average:        0     28812    0.00    0.20    0.00    0.20     -  kworker/0:2-events_power_efficient
Average:        0     30799    0.00    0.20    0.00    0.20     -  pidstat

```

<br>

## 2.CPU上下文切换

根据任务的不同，CPU 的上下文切换就可以分为**进程上下文切换**、**线程上下文切换**以及**中断上下文切换**。

如果系统的上下文切换次数比较稳定，那么从数百到一万以内，都应该算是正常的。但当上下文切换次数超过一万次，或者切换次数出现数量级的增长时，就很可能已经出现了性能问题。



### 2.1 命令

#### 2.1.1 vmstat查看整体CPU的上下文切换情况

vmstat 是一个常用的系统性能分析工具，主要用来分析系统的内存使用情况，也常用来分析 CPU 上下文切换和中断的次数。vmstat 只给出了系统总体的上下文切换情况，要想查看每个进程的详细情况，就需要使用我们前面提到过的 pidstat 。

vmstat 5表示每5秒输出一组数据

```
[root@ecs-u4x ~]# vmstat 5
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0  17808     24 330528    0    0     0     4   12   17  1  1 97  0  1
 0  0      0  16816     24 330552    0    0     0     0  113  284  3  4 89  0  4
```

cs（context switch）是每秒上下文切换的次数。

in（interrupt）则是每秒中断的次数。

r（Running or Runnable）是就绪队列的长度，也就是正在运行和等待 CPU 的进程数。

b（Blocked）则是处于不可中断睡眠状态的进程数。

<br>

#### 2.1.2 pidstat查看每个进程上下文切换

pidstat -w -u 1表示每隔1秒输出1组数据，-w参数表示输出进程切换指标，而-u参数则表示输出CPU使用指标

```bash
[root@ecs-u4x ~]# pidstat -w -u 1
Linux 5.4.11-1.el7.elrepo.x86_64 (ecs-u4x) 	03/22/2021 	_x86_64_	(1 CPU)
10:22:57 PM   UID       PID    %usr %system  %guest    %CPU   CPU  Command
10:22:58 PM     0      5016    0.00    1.00    0.00    1.00     0  pidstat

10:22:57 PM   UID       PID   cswch/s nvcswch/s  Command
10:22:58 PM     0         9      2.00      0.00  ksoftirqd/0
10:22:58 PM     0        10      4.00      0.00  rcu_sched
10:22:58 PM     0      1544     20.00      0.00  xfsaild/dm-0
10:22:58 PM     0      1702     13.00      0.00  kworker/0:0-events_power_efficient
10:22:58 PM     0      4988      1.00      0.00  sshd
10:22:58 PM     0      5016      1.00      0.00  pidstat
10:22:58 PM     0     20461      1.00      0.00  kworker/u2:0-events_unbound
```

cswch ：表示每秒自愿上下文切换（voluntary context switches）的次数，自愿上下文切换是指进程无法获取所需资源，导致的上下文切换。如 I/O、内存等系统资源不足时，就会发生自愿上下文切换。

nvcswch：表示每秒非自愿上下文切换（non voluntary context switches）的次数。非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。如大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换。

自愿上下文切换变多了，说明进程都在等待资源，有可能发生了 I/O 等其他问题；非自愿上下文切换变多了，说明进程都在被强制调度，也就是都在争抢 CPU，说明 CPU 的确成了瓶颈

<br>

#### 2.1.3 pidstat查看线程上下文切换

 pidstat -wt 1表示每隔1秒输出一组数据，-wt 参数表示输出线程的上下文切换指标

```bash
[root@ecs-u4x ~]# pidstat -wt 1
Linux 5.4.11-1.el7.elrepo.x86_64 (ecs-u4x) 	03/22/2021 	_x86_64_	(1 CPU)

10:26:58 PM   UID      TGID       TID   cswch/s nvcswch/s  Command
10:26:59 PM     0         9         -      4.95      0.00  ksoftirqd/0
10:26:59 PM     0         -         9      4.95      0.00  |__ksoftirqd/0
10:26:59 PM     0        10         -     10.89      0.00  rcu_sched
10:26:59 PM     0         -        10     10.89      0.00  |__rcu_sched
10:26:59 PM     0        16         -      0.99      0.00  kauditd
10:26:59 PM     0         -        16      0.99      0.00  |__kauditd
10:26:59 PM     0      1544         -     19.80      0.00  xfsaild/dm-0
10:26:59 PM     0         -      1544     19.80      0.00  |__xfsaild/dm-0
10:26:59 PM     0      1613         -      0.99      0.00  systemd-journal
10:26:59 PM     0         -      1613      0.99      0.00  |__systemd-journal
10:26:59 PM     0      2621         -      0.99      0.00  auditd
10:26:59 PM     0         -      2621      0.99      0.00  |__auditd
10:26:59 PM     0         -      3718      0.99      0.00  |__tuned
10:26:59 PM     0         -      3511      1.98      0.00  |__in:imjournal
10:26:59 PM     0         -      3512      0.99      0.00  |__rs:main Q:Reg
10:26:59 PM     0      5624         -     10.89      0.00  kworker/0:2-events
10:26:59 PM     0         -      5624     10.89      0.00  |__kworker/0:2-events
10:26:59 PM     0      5672         -      1.98      2.97  sshd
10:26:59 PM     0         -      5672      1.98      2.97  |__sshd
10:26:59 PM    74      5673         -      4.95      0.00  sshd
10:26:59 PM    74         -      5673      4.95      0.00  |__sshd
10:26:59 PM     0      5691         -      0.99      0.99  pidstat
10:26:59 PM     0         -      5691      0.99      0.99  |__pidstat

```

<br>

#### 2.1.4 查看中断次数

/proc/interrupts 提供了一个只读的中断使用情况。中断次数变多了，说明 CPU 被中断处理程序占用，还需要通过查看 /proc/interrupts 文件来分析具体的中断类型。

```
[root@ecs-u4x ~]# watch -d cat /proc/interrupts
           CPU0       
  1:          9   IO-APIC   1-edge      i8042
  6:          3   IO-APIC   6-edge      floppy
  8:          0   IO-APIC   8-edge      rtc0
  9:          0   IO-APIC   9-fasteoi   acpi
 10:     233149   IO-APIC  10-fasteoi   virtio6
 11:         35   IO-APIC  11-fasteoi   uhci_hcd:usb1
 12:         15   IO-APIC  12-edge      i8042
 14:          0   IO-APIC  14-edge      ata_piix
 15:          0   IO-APIC  15-edge      ata_piix
 24:          0   PCI-MSI 49152-edge      virtio0-config
 25:   10886181   PCI-MSI 49153-edge      virtio0-input.0
 26:   12166434   PCI-MSI 49154-edge      virtio0-output.0
 27:          0   PCI-MSI 65536-edge      virtio1-config
 28:          0   PCI-MSI 65537-edge      virtio1-input.0
 29:        123   PCI-MSI 65538-edge      virtio1-output.0
 30:          0   PCI-MSI 98304-edge      virtio3-config
 31:         26   PCI-MSI 98305-edge      virtio3-virtqueues
 32:          0   PCI-MSI 114688-edge      virtio4-config
 33:    1067884   PCI-MSI 114689-edge      virtio4-req.0
 34:          0   PCI-MSI 131072-edge      virtio5-config
 35:         67   PCI-MSI 131073-edge      virtio5-req.0
 36:          0   PCI-MSI 81920-edge      virtio2-config
 37:          0   PCI-MSI 81921-edge      virtio2-control
 38:          0   PCI-MSI 81922-edge      virtio2-event
 39:        256   PCI-MSI 81923-edge      virtio2-request
 
NMI:          0   Non-maskable interrupts
LOC:  132529595   Local timer interrupts
SPU:          0   Spurious interrupts
PMI:          0   Performance monitoring interrupts
IWI:          0   IRQ work interrupts
RTR:          0   APIC ICR read retries
RES:          0   Rescheduling interrupts
CAL:          0   Function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
DFR:          0   Deferred Error APIC interrupts
MCE:          0   Machine check exceptions
MCP:       7117   Machine check polls
HYP:          0   Hypervisor callback interrupts
HRE:          0   Hyper-V reenlightenment interrupts
HVS:          0   Hyper-V stimer0 interrupts
ERR:          0
MIS:          0
PIN:          0   Posted-interrupt notification event
NPI:          0   Nested posted-interrupt event
PIW:          0   Posted-interrupt wakeup event
```

<br>

## 3.短时应用排查

### 3.1命令

```bash
# 记录性能事件，等待大约15秒后按 Ctrl+C 退出
$ perf record -g
# 查看报告
$ perf report
```

