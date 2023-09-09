---
title: tshark使用方法
date: 2019-04-26 00:10:34
categories: linux
tags:     
---

# tshark使用方法

[tshark官方文档](<https://www.wireshark.org/docs/man-pages/tshark.html>)

## 1.介绍

**TShark** is a network protocol analyzer. It lets you capture packet data from a live network, or read packets from a previously saved capture file, either printing a decoded form of those packets to the standard output or writing the packets to a file. **TShark**'s native capture file format is **pcapng** format, which is also the format used by **wireshark** and various other tools.

**TShark**是一个网络分析工具。它能帮你在实时网络中捕获数据包，或是从预先保存好的捕获文件中读取数据包，或是打印出这些数据包的解码形式到标准输出，再或是把数据包写入到一个文件中。**TShark**的本地捕获文件格式是pcapng格式，这种pcapng格式也被**wireshark**和多种其他工具使用。

<!--more-->

Without any options set, **TShark** will work much like **tcpdump**. It will use the pcap library to capture traffic from the first available network interface and displays a summary line on the standard output for each received packet.

如果没有设置任何选项，**TShark**将像**tcpdump**一样工作。它使用pcap库，从第一个可使用的网络接口捕获流量。并且为每个接收到的包展示其摘要行到标准输出上。



When run with the **-r** option, specifying a capture file from which to read, **TShark** will again work much like **tcpdump**, reading packets from the file and displaying a summary line on the standard output for each packet read. **TShark** is able to detect, read and write the same capture files that are supported by **Wireshark**. The input file doesn't need a specific filename extension; the file format and an optional gzip compression will be automatically detected. Near the beginning of the DESCRIPTION section of wireshark(1) or <https://www.wireshark.org/docs/man-pages/wireshark.html> is a detailed description of the way **Wireshark** handles this, which is the same way **Tshark** handles this.

当使用-r选项，会从我们指定的文件中读取数据包信息。**TShark**将再次像**tcpdump**一样工作，从文件中读取数据包并且把读取的数据包在标准输出上展示其摘要行。**TShark**可以检测，读取和写入同一份捕获文件，这些操作在**Wireshark**中也是支持的。输出文件不需要一个指定的文件扩展名；它将动态检测文件格式和可选的gzip压缩。在**Wireshark**的开始描述部分附近或是在链接https://www.wireshark.org/docs/man-pages/wireshark.html 中，介绍了关于**Wireshark**处理这些问题的方法细节描述，这些方法同样适用于**TShark**。



Compressed file support uses (and therefore requires) the zlib library. If the zlib library is not present when compiling **TShark**, it will be possible to compile it, but the resulting program will be unable to read compressed files.

支持压缩文件要使用（因此需要）zlib库。如果编译**TShark**时zlib库不存在，也可以编译它，但是最终程序将不可读取压缩文件。



When displaying packets on the standard output, **TShark** writes, by default, a summary line containing the fields specified by the preferences file (which are also the fields displayed in the packet list pane in **Wireshark**), although if it's writing packets as it captures them, rather than writing packets from a saved capture file, it won't show the "frame number" field. If the **-V** option is specified, it instead writes a view of the details of the packet, showing all the fields of all protocols in the packet. If the **-O** option is specified, it will only show the full details for the protocols specified, and show only the top-level detail line for all other protocols. Use the output of "**tshark -G protocols**" to find the abbreviations of the protocols you can specify. If the **-P** option is specified with either the **-V** or **-O** options, both the summary line for the entire packet and the details will be displayed.

当在标准输出显示数据包时，默认情况下**TShark**输出摘要行信息，摘要行里包含首选项文件指定的字段（这些字段也展示在wireshark中的包列表窗），但是如果在捕获流量时输出数据包而不是在保存的文件中输出数据包的话，将不会显示“帧编号”字段。如果指定了**-V**选项，这将输出数据包的细节信息视图，展示了数据包中所有协议的所有字段信息。如果指定了**-O**选项，它将仅显示指定协议的完整详细信息，并仅显示所有其他协议的顶级详细信息行。在命令行中输入“**tshark -G protocols**”可以查找指定的协议缩写。如果**-P**选项和**-V**或**-O**一起使用，将会展示整个包的摘要行和细节信息。



Packet capturing is performed with the pcap library. That library supports specifying a filter expression; packets that don't match that filter are discarded. The **-f** option is used to specify a capture filter. The syntax of a capture filter is defined by the pcap library; this syntax is different from the read filter syntax described below, and the filtering mechanism is limited in its abilities.

数据包捕获时使用pcap库。pcap库支持指定的过滤表达式；数据包没有匹配上过滤表达式则会被丢弃。**-f**选项被用来指定捕获过滤表达式。捕获过滤的语法在pcap库中定义；这些捕获过滤的语法不同于以下所描述的显示过滤器语法，并且其过滤机制的能力有限。



Read filters in **TShark**, which allow you to select which packets are to be decoded or written to a file, are very powerful; more fields are filterable in **TShark** than in other protocol analyzers, and the syntax you can use to create your filters is richer. As **TShark** progresses, expect more and more protocol fields to be allowed in read filters. Read filters use the same syntax as display and color filters in **Wireshark**; a read filter is specified with the **-R** option.

在**TShark**中的显示过滤器允许你选择哪一个包被解码或是把该数据包写入到一个文件，这是很强大的功能；**TShark**相比于其他协议分析器可以过滤出更多的字段，并且你能使用并创建的过滤器语法更为丰富。随着**TShark**的发展，期待更多协议字段被允许出现在显示过滤器中。显示过滤器使用与**wireshark**中的展示和色彩过滤器一样的语法；使用**-R**选项来指定显示过滤器。



Read filters can be specified when capturing or when reading from a capture file. Note that that capture filters are much more efficient than read filters, and it may be more difficult for **TShark** to keep up with a busy network if a read filter is specified for a live capture, so you might be more likely to lose packets if you're using a read filter.

当正在捕获或是从一个捕获文件中读取时是可以指定显示过滤器的。需要注意的是捕获过滤器比显示过滤器会更有效率；并且在一个繁忙的网络中如果进行实时捕获时使用了显示过滤器，那么**TShark**可能更难跟上这个繁忙网络，同时你要是使用了显示过滤器还可能会丢失数据包。



A capture or read filter can either be specified with the **-f** or **-R** option, respectively, in which case the entire filter expression must be specified as a single argument (which means that if it contains spaces, it must be quoted), or can be specified with command-line arguments after the option arguments, in which case all the arguments after the filter arguments are treated as a filter expression. If the filter is specified with command-line arguments after the option arguments, it's a capture filter if a capture is being done (i.e., if no **-r** option was specified) and a read filter if a capture file is being read (i.e., if a **-r** option was specified).

捕获或是显示过滤器能分别使用**-f**或是**-R**选项来指定。在这种情况下，整个过滤表达式必须作为一个参数被指定（这意味着如果含有空格，就需要使用“ ”被引用）；或者是在选项参数之后使用命令行参数被指定，在这种情况下，所有在过滤器参数之后的参数会被视为过滤表达式。如果在选项参数后，使用命令行参数来指定过滤器，那么捕获正在进行时它就是捕获过滤器（即，没有-r选项）；如果捕获文件正在被读取，那么它就是显示过滤器（即，**-r**选项是被指定的）。



If the **-w** option is specified when capturing packets or reading from a capture file, **TShark** does not display packets on the standard output. Instead, it writes the packets to a capture file with the name specified by the **-w** option.

当正在捕获数据包，或是从一个捕获文件中读取时，如果使用了-w选项，那么**TShark**不会在标准输出上显示数据包。相反，它将把数据包写入捕获文件，其名称由**-w**选项指定。



If you want to write the decoded form of packets to a file, run **TShark** without the **-w** option, and redirect its standard output to the file (do *not* use the **-w** option).

如果要将解码后的数据包形式写入文件，那么使用**TShark**时不要带上-w选项，同时会将其标准输出重定向到文件。（不要使用**-w**选项）



If you want the packets to be displayed to the standard output and also saved to a file, specify the **-P** option in addition to the **-w** option to have the summary line displayed, specify the **-V** option in addition to the **-w** option to have the details of the packet displayed, and specify the **-O** option, with a list of protocols, to have the full details of the specified protocols and the top-level detail line for all other protocols to be displayed. If the **-P** option is used together with the **-V** or **-O** option, the summary line will be displayed along with the detail lines.

如果你想数据包在标准输出上显示并且还能保存到一个文件中，那么除了-w选项还需要指定-P选项来显示摘要行。使用**-w**选项及**-V**选项将展示数据包的细节。如果再加上**-O**选项，带上了列出的协议，将显示指定协议的所有细节以及所有其他协议的顶层细节行。如果**-P**选项和**-V**或是**-O**选项一起使用，那么摘要行将会和细节信息一起展示。



When writing packets to a file, **TShark**, by default, writes the file in **pcapng** format, and writes all of the packets it sees to the output file. The **-F** option can be used to specify the format in which to write the file. This list of available file formats is displayed by the **-F** option without a value. However, you can't specify a file format for a live capture.

当把数据包写入一个文件，**TShark**默认情况下会使用**pcapng**格式，并将其所有看到的包写入到输出文件。使用**-F**选项可以指定输出文件的格式。使用**-F**选项不带任何参数值，将显示可以得到的文件格式列表。但是对于实时捕获，你不能指定其文件格式。



When capturing packets, **TShark** writes to the standard error an initial line listing the interfaces from which packets are being captured and, if packet information isn't being displayed to the terminal, writes a continuous count of packets captured to the standard output. If the **-q** option is specified, neither the continuous count nor the packet information will be displayed; instead, at the end of the capture, a count of packets captured will be displayed. If the **-Q** option is specified, neither the initial line, nor the packet information, nor any packet counts will be displayed. If the **-q** or **-Q** option is used, the **-P**, **-V**, or **-O** option can be used to cause the corresponding output to be displayed even though other output is suppressed.

当正在捕获数据包时，**TShark**把捕获到数据包接口的初始化行写入到标准错误中。如果数据包信息没有被展示在终端，则将写入连续的捕获数据包统计到标准输出。如果**-q**选项被指定，则不管是连续统计还是数据包信息都不会被展示出来；相反，在捕获结束后，被捕获的数据包统计将会显示出来。如果**-Q**选项被指定，初始化行、数据包信息或是任何一个数据包统计都不会被展示。如果使用**-q**或**-Q**选项，则可以使用**-P**，**-V**或**-O**选项来显示相应的输出，即使其他输出被抑制也是如此。



When reading packets, the **-q** and **-Q** option will suppress the display of the packet summary or details; this would be used if **-z** options are specified in order to display statistics, so that only the statistics, not the packet information, is displayed.

读取数据包时，**-q**和**-Q**选项将禁止显示数据包摘要或详细信息;如果指定**-z**选项以显示统计信息，那么只有统计信息会被展示，而不会展示数据包信息。



The **-G** option is a special mode that simply causes **Tshark** to dump one of several types of internal glossaries and then exit.

**-G**选项是一种特殊模式，它只会导致**TShark**转储几种类型的内部词汇表中的一种，然后退出。

------



## 2.选项概要

**Capture interface:**

```bash
 -i <interface>               # name or idx of interface (def: first non-loopback)
 -f <capture filter>          # packet filter in libpcap filter syntax
 -s <snaplen>                 # packet snapshot length (def: 262144)
 -p                           # don't capture in promiscuous mode
 -I                           # capture in monitor mode, if available
 -B <buffer size>             # size of kernel buffer (def: 4MB)
 -y <link type>               # link layer type (def: first appropriate)
 -D                           # print list of interfaces and exit
 -L                           # print list of link-layer types of iface and exit
```

 

**Capture stop conditions:**

```bash
-c <packet count>             # stop after n packets (def: infinite)
-a <autostop cond.> ...  
​                             duration:NUM - stop after NUM seconds
​                             filesize:NUM - stop this file after NUM KB
​                             files:NUM - stop after NUM files
```

 

**Capture output:**

```bash
-b <ringbuffer opt.> ... 

​                            duration:NUM - switch to next file after NUM secs
​                            filesize:NUM - switch to next file after NUM KB
​                            files:NUM - ringbuffer: replace after NUM files
```



**Input file:**

```bash
-r <infile>                  # set the filename to read from (no stdin!)
```



**Processing:**

```bash
-2                           # perform a two-pass analysis
-R <read filter>             # packet Read filter in Wireshark display filter syntax
-Y <display filter>          # packet displaY filter in Wireshark display filter syntax
-n                           # disable all name resolutions (def: all enabled)
-N <name resolve flags>      # enable specific name resolution(s): "mnNtC"
-d <layer_type>== <selector>,<decode_as_protocol> ...
                             # "Decode As", see the man page for details
                             # Example: tcp.port==8888,http
-H <hosts file>         
​            read a list of entries from a hosts file, which will  then be written to a capture file. (Implies -W n)
```

 

**Output:**

```bash
-w <outfile|->               # write packets to a pcap-format file named "outfile"
                             # (or to the standard output for "-")
                             
-C <config profile>          # start with specified configuration profile
-F <output file type>        # set the output file type, default is pcapng
                             # an empty "-F" option will list the file types
                             
-V                           # add output of packet tree (Packet Details)
-O <protocols>               # Only show packet details of these protocols, comma                                        separated

-P                           # print packet summary even when writing to a file
-S <separator>               # the line separator to print between packets
-x                           # add output of hex and ASCII dump (Packet Bytes)
-T pdml|ps|psml|text|fields  # format of text output (def: text)

-e <field>                   # field to print if -Tfields selected (e.g. tcp.port,                                      col.Info);this option can be repeated to print multiple                                  fields

-E<fieldsoption>=<value>     # set options for output when -Tfields selected:
     header=y|n                 switch headers on and off
     separator=/t|/s|<char>     select tab, space, printable character as separator
     occurrence=f|l|a           print first, last or all occurrences of each field
     aggregator=,|/s|<char>     select comma, space, printable character as  aggregator
     quote=d|s|n                select double, single, no quotes for values
     
-t a|ad|d|dd|e|r|u|ud        # output format of time stamps (def: r: rel. to first)
-u s|hms                     # output format of seconds (def: s: seconds)
-l                           # flush standard output after each packet
-q                           # be more quiet on stdout (e.g. when using statistics)
-Q                           # only log true errors to stderr (quieter than -q)
-g                           # enable group read access on the output file(s)
-W n                         # Save extra information in the file, if supported.
                             # n = write network address resolution information
  
-X <key>:<value>             # eXtension options, see the man page for details
-z <statistics>              # various statistics, see the man page for details
```



**Miscellaneous:**

```bash
-h                           # display this help and exit
-v                           # display version info and exit
-o <name>:<value> ...        # override preference setting
-K <keytab>                  # keytab file to use for kerberos decryption
-G [report]                  # dump one of several available reports and exit
                             # default report="fields"  
                             # use "-G ?" for more help
```



 

------



## 3.选项细节

### 3.1 Capture interface:捕获接口

#### -i		指定接口

```bash
-i <interface>               # name or idx of interface (def: first non-loopback)
```

Set the name of the network interface or pipe to use for live packet capture.

为实时数据包捕获设置网络接口或管道的名称。



Network interface names should match one of the names listed in "**tshark -D**" (described above); a number, as reported by "**tshark -D**", can also be used. If you're using UNIX, "**netstat -i**", "**ifconfig -a**" or "**ip link**" might also work to list interface names, although not all versions of UNIX support the **-a** option to **ifconfig**.

网络接口名称应该是使用“**tshark -D**”命令后显示的接口名称列表中的一个。当然也可以使用“**tshark -D**”展示的列表中的数字。如果你使用UNIX系统，“**netstat -i**”，“**ifconfig -a**”或是“**iplink**”也可以显示出接口名称，尽管不是所有的NUIX版本都支持在**ifconfig**中使用**-a**参数。

{% asset_img 1553424287090.png This is an test image %}



If no interface is specified, **TShark** searches the list of interfaces, choosing the first non-loopback interface if there are any non-loopback interfaces, and choosing the first loopback interface if there are no non-loopback interfaces. If there are no interfaces at all, **TShark** reports an error and doesn't start the capture.

如果没有接口被指定，**TShark**寻找接口列表，若在列表中存在多个非回环接口，将选择第一个非回环接口。若在列表中没有非回环接口，则选择第一个回环接口。如果设备没有一个接口，那**TShark**会报告一个错误，并且不会开始捕获数据。



Pipe names should be either the name of a FIFO (named pipe) or "-" to read data from the standard input. On Windows systems, pipe names must be of the form "\\\pipe\\.\pipename". Data read from pipes must be in standard pcapng or pcap format. Pcapng data must have the same endianness as the capturing host.

管道名称（此处略）



This option can occur multiple times. When capturing from multiple interfaces, the capture file will be saved in pcapng format.

这个选项可以出现多次。当从多个接口进行数据捕获，捕获文件将被保存为pcapng格式。

{% asset_img 1553424388817.png This is an test image %}



#### -f		设置捕获时的过滤条件

```bash
-f <capture filter>            # packet filter in libpcap filter syntax
```

Set the capture filter expression.设置捕获过滤器表达式

This option can occur multiple times. If used before the first occurrence of the **-i** option, it sets the default capture filter expression. If used after an **-i** option, it sets the capture filter expression for the interface specified by the last **-i** option occurring before this option. If the capture filter expression is not set specifically, the default capture filter expression is used if provided.

这个选项可以多次出现。如果在第一次出现**-i**选项之前使用，则会设置默认的捕获过滤器表达式。如果在**-i**选项之后使用，则会为最后一个**-i**选项指定的接口设置捕获过滤器表达式。如果捕获过滤器表达式没有设置指定，则使用默认的捕获过滤表达式（如果提供的话）



Pre-defined capture filter names, as shown in the GUI menu item Capture->Capture Filters, can be used by prefixing the argument with "predef:". Example: **tshark -f "predef:MyPredefinedHostOnlyFilter"**

通过在参数前面添加前缀"predef:"可以使用预定义捕获过滤器名称，就像在GUI菜单选项 Capture->Capture Filters中一样。举个例子：**tshark -f "predef:MyPredefinedHostOnlyFilter"**

{% asset_img 1553424447858.png This is an test image %}



ps：捕获过滤器条件写法参考自己之前做的总结文档





#### -s		设置捕获的数据包长度

```bash
-s <snaplen>                # packet snapshot length (def: 262144)
```

Set the default snapshot length to use when capturing live data. No more than *snaplen* bytes of each network packet will be read into memory, or saved to disk. A value of 0 specifies a snapshot length of 262144, so that the full packet is captured; this is the default.

当在捕获实时数据时，设置一个默认的快照长度。每个网络数据包的快照字节将会读入到内存或是保存在硬盘中。

数值0指定了快照长度是262144字节，以便捕获完整数据包；这个也是默认的。



This option can occur multiple times. If used before the first occurrence of the **-i** option, it sets the default snapshot length. If used after an **-i** option, it sets the snapshot length for the interface specified by the last **-i** option occurring before this option. If the snapshot length is not set specifically, the default snapshot length is used if provided.

这个选项能出现多次。如果在第一次出现**-i**选项前使用，则将设置默认的快照长度。如果在**-i**选项后使用，则将为最后一个出现的**-i**选项所指定的接口设置快照长度。如果快照长度没有被指定，则使用默认的快照长度（如果被提供的话）

{% asset_img 1553424534932.png This is an test image %}



#### -p		设置接口为非混杂模式

```bash
-p                        # don't capture in promiscuous mode
```

*Don't* put the interface into promiscuous mode. Note that the interface might be in promiscuous mode for some other reason; hence, **-p** cannot be used to ensure that the only traffic that is captured is traffic sent to or from the machine on which **TShark** is running, broadcast traffic, and multicast traffic to addresses received by that machine.

不让接口成为混杂模式。



This option can occur multiple times. If used before the first occurrence of the **-i** option, no interface will be put into the promiscuous mode. If used after an **-i** option, the interface specified by the last **-i** option occurring before this option will not be put into the promiscuous mode.

这个选项能出现多次。如果在第一次出现-i选项前使用，那么没有接口会被设置为混杂模式。如果在**-i**选项后被使用，那么在**-p**选项前的最后一个**-i**选项指定的接口将不会被设置为混杂模式。





#### -I		为IEEE802.11设置监控模式

```bash
-I                          # capture in monitor mode, if available
```

Put the interface in "monitor mode"; this is supported only on IEEE 802.11 Wi-Fi interfaces, and supported only on some operating systems.

设置为监控模式；这仅在IEEE802.11 Wi-Fi接口和某些操作系统上支持。





#### -B		设置捕获缓冲区大小

```bash
-B <buffer size>                 # size of kernel buffer (def: 4MB)
```

Set capture buffer size (in MiB, default is 2 MiB). 

设置捕获缓冲区大小，TSshark官方文档中说默认是2MB。在我这台Linux服务器显示是4MB





#### -y		设置数据链路类型

```bash
-y <link type>                 # link layer type (def: first appropriate)
```

Set the data link type to use while capturing packets. The values reported by **-L** are the values that can be used.

当在捕获数据包时，设置数据链路类型。能够使用的值在**-L**参数中被展示

{% asset_img 1553424590831.png This is an test image %}

{% asset_img 1553424678354.png This is an test image %}



This option can occur multiple times. If used before the first occurrence of the **-i** option, it sets the default capture link type. If used after an **-i** option, it sets the capture link type for the interface specified by the last **-i** option occurring before this option. If the capture link type is not set specifically, the default capture link type is used if provided.





#### -D		输出接口列表

```bash
-D                        # print list of interfaces and exit
```

{% asset_img 1553424287090.png This is an test image %}



#### -L		显示数据链路类型

```bash
-L                        # print list of link-layer types of iface and exit
```



------

### 3.2 Capture stop conditions:捕获停止选项

#### -c 在N个数据包后停止捕获

```bash
-c <packet count>         # stop after n packets (def: infinite)
```

Set the maximum number of packets to read when capturing live data. If reading a capture file, set the maximum number of packets to read.

在捕获实时数据时，设置一个最大的数据包读取数。如果是在读取捕获文件，依旧是要设置一个读取数据包的数量。第一张图是实时捕获的情况，第二张图是读取http_google.pcap文件只看前3个包的情况。

{% asset_img 1553424792984.png This is an test image %}



#### -a 设置停止捕获条件

```bash
-a <autostop cond.> ...  

​                           duration:NUM - stop after NUM seconds
​                           filesize:NUM - stop this file after NUM KB
​                           files:NUM - stop after NUM files       
```

Specify a criterion that specifies when **TShark** is to stop writing to a capture file. The criterion is of the form ***test:value***, where *test* is one of:

指定一个标准，指定**TShark**何时停止写入捕获文件。标准的写法是test：value，其中test是以下之一



**duration**:*value*   Stop writing to a capture file after *value* seconds have elapsed. Floating point values (e.g. 0.5) are allowed.

**duration**:*value*    经过value秒后停止捕获文件。duration是持续时间的意思。浮点数值也是被允许的（比如0.5）。下图测试，确实在1s后停止捕获，同时还告诉你6个包被捕获到了

{% asset_img 1553424874791.png This is an test image %}



**files**:*value*        Stop writing to capture files after *value* number of files were written.

**files**:*value*        在捕获value个文件后，就停止捕获



**filesize**:*value*    Stop writing to a capture file after it reaches a size of *value* kB. If this option is used together with the -b option, **TShark** will stop writing to the current capture file and switch to the next one if filesize is reached. When reading a capture file, **TShark** will stop reading the file after the number of bytes read exceeds this number (the complete packet will be read, so more bytes than this number may be read). Note that the filesize is limited to a maximum value of 2 GiB.

**filesize**:*value*    在达到value kB的大小后停止写入捕获文件。如果此选项与-b选项一起使用，则**TShark**将停止写入当前捕获文件，并在达到文件大小时切换到下一个文件。读取捕获文件时，**TShark**将在读取的字节数超过此数字后停止读取该文件（因为要读取完整数据包，所以可能会读取出超出这个数值的字节数）。请注意，文件大小限制为2 GiB。

{% asset_img 1553425008635.png This is an test image %}



------

### 3.3 Capture output:捕获输出

#### -b 设置循环写入多个数据包条件

```bash
-b <ringbuffer opt.> ... 
​                            duration:NUM - switch to next file after NUM secs
​                            filesize:NUM - switch to next file after NUM KB
​                            files:NUM - ringbuffer: replace after NUM files
```

Cause **TShark** to run in "multiple files" mode. In "multiple files" mode, **TShark** will write to several capture files. When the first capture file fills up, **TShark** will switch writing to the next file and so on.

导致**TShark**使用“多文件”模式运行。在“多文件”模式下，**TShark**将写入多个捕获文件。当第一个捕获文件写满，**TShark**将切换写入到下一个文件，以此类推。



The created filenames are based on the filename given with the **-w** option, the number of the file and on the creation date and time, e.g. outfile_00001_20190714120117.pcap, outfile_00002_20190714120523.pcap, ...

被创建的这些文件名是基于**-w**选项所给出的“文件名，文件的编号以及在创建时的数据和时间”。例如 outfile_00001_20190714120117.pcap，outfile_00002_20190714120523.pcap, ...



With the *files* option it's also possible to form a "ring buffer". This will fill up new files until the number of files specified, at which point **TShark** will discard the data in the first file and start writing to that file and so on. If the *files* option is not set, new files filled up until one of the capture stop conditions match (or until the disk is full).

使用files选项还可以形成“环形缓冲区”。这将填充新文件直到所指定的文件数。在这一点上，**TShark**将丢弃在第一个文件中的数据并开始把数据写入另一个文件中，以此类推。如果files选项没有被设置，则将填满新文件，直到其中一个捕获停止条件匹配为止（或是直到硬盘被填满）。



The criterion is of the form *key:value*, where *key* is one of:

标准格式是*key:value*，*key*是以下参数中的一个：



**duration**:*value*   switch to the next file after *value* seconds have elapsed, even if the current file is not completely filled up. Floating point values (e.g. 0.5) are allowed.

**duration**:*value*    在经过*value*秒后切换到下一个文件，即便现在的文件没有被完全填满。浮点数值（例如0.5）也是可以使用的。

{% asset_img 1553317134423.png This is an test image %}



**files**:*value*     begin again with the first file after *value* number of files were written (form a ring buffer). This value must be less than 100000. Caution should be used when using large numbers of files: some filesystems do not handle many files in a single directory well. The **files** criterion requires either **duration**, **interval** or **filesize** to be specified to control when to go to the next file. It should be noted that each **-b** parameter takes exactly one criterion; to specify two criterion, each must be preceded by the **-b** option.

**files**:*value*    在*value*个文件数被写入后，再次从第一个文件开始（形成环形缓冲区）。这个数值必须小于100000。当使用大量的文件数时，需要谨慎使用：因为一些文件系统不能在当个的目录下处理好大量的文件。文件标准要求指定持续时间，间隔或文件大小以控制何时转到下一个文件。需要注意的是每个**-b**参数只使用一个标准；想要使用两个标准，那么每个标准前都要加上**-b**参数

{% asset_img 1553317668809.png This is an test image %}



**filesize**:*value*   switch to the next file after it reaches a size of *value* kB. Note that the filesize is limited to a maximum value of 2 GiB.

**filesize**:*value*     在到达*value* kB后，切换到下一个文件。需要注意的是文件大小被限制在2GB以下。



------



### 3.4 Input file:读取本地文件

#### -r 

```bash
-r <infile>                  # set the filename to read from (no stdin!)
```

{% asset_img 1553318042410.png This is an test image %}



------



### 3.5 Processing:处理过程

#### -2 执行2次分析

```bash
-2                           # perform a two-pass analysis
```

执行两次分析





#### -R 设置显示过滤器

```bash
-R <read filter>             # packet Read filter in Wireshark display filter syntax
```

Cause the specified filter (which uses the syntax of read/display filters, rather than that of capture filters) to be applied during the first pass of analysis. Packets not matching the filter are not considered for future passes. Only makes sense with multiple passes, see -2. For regular filtering on single-pass dissect see -Y instead.

在第一遍分析中使用指定过滤器（该过滤器使用的是读取/显示过滤器的语法，而不是捕获过滤器的语法）。没有匹配过滤器的数据包将不会在后续展示。**-R**对于数据包进行多次分析才有意义，可以参考**-2**。对于单次的常规分析详见**-Y**。





#### -Y 设置显示过滤器（单次分析）

```bash
-Y <display filter>          # packet displaY filter in Wireshark display filter syntax
```

Cause the specified filter (which uses the syntax of read/display filters, rather than that of capture filters) to be applied before printing a decoded form of packets or writing packets to a file. Packets matching the filter are printed or written to file; packets that the matching packets depend upon (e.g., fragments), are not printed but are written to file; packets not matching the filter nor depended upon are discarded rather than being printed or written.

在输出数据包的解码形式或写入数据包到文件前，使用指定的过滤器（过滤器使用读取/显示过滤器的语法，而不是捕获过滤器）。匹配过滤的数据包将输出或是写入到文件；基于匹配的数据包（例如：数据段），将不会输出但是会写入到文件；不匹配过滤器的数据包被丢弃而不是被打印或写入。



Use this instead of -R for filtering using single-pass analysis. If doing two-pass analysis (see -2) then only packets matching the read filter (if there is one) will be checked against this filter.

对于过滤时使用-R将进行单次分析。如果做2次分析（见-2），那么只有数据包匹配了读取过滤器（如果有的话），将会针对这个过滤器再次检查。





#### -n 设置不做名称解析

```bash
-n                           # disable all name resolutions (def: all enabled)
```

Disable network object name resolution (such as hostname, TCP and UDP port names); the **-N** option might override this one.

关闭所有名称解析（例如主机名，TCP和UDP的端口名）；**-N**选项将覆盖-n选项。





#### -N 设置只为特定情况做名称解析

```bash
-N <name resolve flags>      # enable specific name resolution(s): "mnNtC"
```

Turn on name resolving only for particular types of addresses and port numbers, with name resolving for other types of addresses and port numbers turned off. This option overrides **-n** if both **-N** and **-n** are present. If both **-N** and **-n** options are not present, all name resolutions are turned on.

只为特定的地址和端口号类型打开名称解析，对于没有指定的则不进行地址解析。如果**-N**和**-n**选项同时出现，则会覆盖**-n**选项。如果**-N**和**-n**选项都没出现，则名称解析会被开启。



The argument is a string that may contain the letters:

参数是包含以下字母的字符串



**d** to enable resolution from captured DNS packets

从捕获的DNS数据包中开始解析

**m** to enable MAC address resolution

开启MAC地址解析

**n** to enable network address resolution

开启网络地址解析

**N** to enable using external resolvers (e.g., DNS) for network address resolution

使用外部解析器（如DNS）来对网络地址进行解析

**t** to enable transport-layer port number resolution

开启传输层端口号解析

**v** to enable VLAN IDs to names resolution

开启VLAN ID的名称解析





#### -d 设置解码格式

```bash
-d <layer_type>== <selector>,<decode_as_protocol> ...
                             # "Decode As", see the man page for details
                             # Example: tcp.port==8888,http
```

Like Wireshark's **Decode As...** feature, this lets you specify how a layer type should be dissected. If the layer type in question (for example, **tcp.port** or **udp.port** for a TCP or UDP port number) has the specified selector value, packets should be dissected as the specified protocol.

类似于Wireshark的**Decode As...**这个功能让你指定如何对每层类型进行分析。如果请求的层次类型（如TCP或是UDP端口号中的**tcp.port** 、**udp.port** ）有指定的选择值，则数据包将会使用指定的协议进行分析。



Example: **tshark -d tcp.port==8888,http** will decode any traffic running over TCP port 8888 as HTTP.

例如：**tshark -d tcp.port==8888,http**将会解码每一个TCP端口号是8888的流量为HTTP协议。



Example: **tshark -d tcp.port==8888:3,http** will decode any traffic running over TCP ports 8888, 8889 or 8890 as HTTP.

例如：**tshark -d tcp.port==8888:3,http**将会解码每一个TCP端口号是8888，8889,8890的流量为HTTP协议。



Example: **tshark -d tcp.port==8888-8890,http** will decode any traffic running over TCP ports 8888, 8889 or 8890 as HTTP.

含义同上，只是写法有区别



Using an invalid selector or protocol will print out a list of valid selectors and protocol names, respectively.

使用无效的解析器或协议将会分别打印出有效解析器和协议名称的表。



Example: **tshark -d .** is a quick way to get a list of valid selectors.

例如：**tshark -d .**以最快的方式列出有效解析器



Example: **tshark -d ethertype==0x0800.** is a quick way to get a list of protocols that can be selected with an ethertype.

例如：**tshark -d ethertype==0x0800.**以最快的方式获取能选择的以太网类型的协议列表





#### -H  

```bash
-H <hosts file>         
​            read a list of entries from a hosts file, which will  then be written to a capture file. (Implies -W n)
```

Read a list of entries from a "hosts" file, which will then be written to a capture file. Implies **-W n**. Can be called multiple times.

从“hosts”文件中读取条目列表，然后将其写入捕获文件。也可以使用**-W n**。可以多次调用。

------



### 3.6 Output:输出

#### -w  写入文件

```bash
-w <outfile|->               # write packets to a pcap-format file named "outfile"
                             # (or to the standard output for "-")
```

Write raw packet data to *outfile* or to the standard output if *outfile* is '-'.

在标准输出或是输出文件中写入原始数据包



NOTE: -w provides raw packet data, not text. If you want text output you need to redirect stdout (e.g. using '>'), don't use the **-w** option for this.

注意：**-w**提供的是原始数据包，而非文本。如果你想输出文本，你需要重定向（例如使用‘>’），而非使用-w选项。





#### -F  设置写入文件格式

```bash
-F <output file type>        # set the output file type, default is pcapng
                             # an empty "-F" option will list the file types
```

Set the file format of the output capture file written using the **-w** option. The output written with the **-w** option is raw packet data, not text, so there is no **-F** option to request text output. The option **-F** without a value will list the available formats.

使用**-w**选项设置输出捕获文件写入的文件格式。使用**-w**选项写入的输出是原始数据包而非文本。**-F**选项后不接值，则将列出可获得的格式。





#### -V（大写V，显示数据包细节）

```bash
-V                           # add output of packet tree (Packet Details)
```

Cause **TShark** to print a view of the packet details.

{% asset_img 1553425274015.png This is an test image %}



#### -O 显示此选项指定的协议的详细信息

```bash
-O <protocols>               # Only show packet details of these protocols, comma                                        separated
```

Similar to the **-V** option, but causes **TShark** to only show a detailed view of the comma-separated list of *protocols* specified, and show only the top-level detail line for all other protocols, rather than a detailed view of all protocols. Use the output of "**tshark -G protocols**" to find the abbreviations of the protocols you can specify.

类似于**-V**，只是**TShark**仅显示指定协议的以逗号分隔开的协议细节。同时仅为其他的协议显示顶层细节行，而非全体细节。使用 "**tshark -G protocols**" 你可以获得可以指定的协议列表。





#### -T 与-e一起使用，显示相应的特定内容

```bash
-T pdml|ps|psml|text|fields  # format of text output (def: text)
```

Set the format of the output when viewing decoded packet data. The options are one of:

当在查看解码数据包数据时设置输出格式。选项可以为以下之一（我只列出常用的）：



**fields** The values of fields specified with the **-e** option, in a form specified by the **-E** option. For example,

**fields**  使用**-e**选项指定字段的值，采用-E选项指定格式。例如，

```bash
  tshark -T fields -E separator=, -E quote=d
```

{% asset_img 1553425343018.png This is an test image %}



#### -e

```bash
-e <field>                   # field to print if -Tfields selected (e.g. tcp.port,                                      col.Info);this option can be repeated to print multiple                                  fields
```

Add a field to the list of fields to display if **-T ek|fields|json|pdml** is selected. This option can be used multiple times on the command line. At least one field must be provided if the **-T fields** option is selected. 

如果选择了**-T ek|fields|json|pdml**，则添加一个字段来显示字段列表。在命令行，这个选项可以使用多次。如果使用的是 **-T fields** ，则至少要提供一个字段。



Example: **tshark -e frame.number -e ip.addr -e udp **

例如：**tshark -e frame.number -e ip.addr -e udp **



Giving a protocol rather than a single field will print multiple items of data about the protocol as a single field. Fields are separated by tab characters by default. **-E** controls the format of the printed fields.

给定一个协议而不是单个字段，将会打印出这个协议作为单个字段的多个项目数据。字段默认情况下会被制表符分隔。**-E**控制打印字段的格式。







#### -E 设置控制字段打印的选项

```bash
-E<fieldsoption>=<value>     # set options for output when -Tfields selected:
     header=y|n                 switch headers on and off
     separator=/t|/s|<char>     select tab, space, printable character as separator
     occurrence=f|l|a           print first, last or all occurrences of each field
     aggregator=,|/s|<char>     select comma, space, printable character as  aggregator
     quote=d|s|n                select double, single, no quotes for values
```





#### -t 设置时间显示格式

```bash
-t a|ad|d|dd|e|r|u|ud        # output format of time stamps (def: r: rel. to first)
```





#### -u  设置秒的类型

```bash
-u s|hms                     # output format of seconds (def: s: seconds)
```

Specifies the seconds type. Valid choices are:

**s** for seconds

**hms** for hours, minutes and seconds





#### -W n

```bash
-W n                         # Save extra information in the file, if supported.
                             # n = write network address resolution information
```

Save extra information in the file if the format supports it. For example,

如果格式支持，则保存额外的信息到文件中。例如，使用如下命令

```bash
  tshark -F pcapng -W n
```

will save host name resolution records along with captured packets.

则将保存主机名称解析的解码到捕获数据包中。



Future versions of **Tshark** may automatically change the capture format to **pcapng** as needed.

未来版本的**Tshark**可能会根据需要自动将捕获格式更改为pcapng。



The argument is a string that may contain the following letter:

**n** write network address resolution information (pcapng only)

参数可以是以下的字符串：

**n** 写入网络地址解析信息(仅限pcapng)





#### -q与-z 获取各种统计信息（只挑选了部分常用的）

```bash
-q                           # be more quiet on stdout (e.g. when using statistics)
-z <statistics>              # various statistics, see the man page for details
```

Get **TShark** to collect various types of statistics and display the result after finishing reading the capture file. Use the **-q** option if you're reading a capture file and only want the statistics printed, not any per-packet information.

让**TShark**收集统计的各种类型，并且在完成读取的捕获文件后展示出来。如果你正在读取捕获文件，并只想打印出统计信息，而不是每个包的信息，则使用**-q**选项。



Note that the **-z proto** option is different - it doesn't cause statistics to be gathered and printed when the capture is complete, it modifies the regular packet summary output to include the values of fields specified with the option. Therefore you must not use the **-q** option, as that option would suppress the printing of the regular packet summary output, and must also not use the **-V** option, as that would cause packet detail information rather than packet summary information to be printed.

注意的是**-z proto**有不同之处。当在捕获完成时，它不会收集统计信息并打印出来，而是修改常规数据包汇总输出，包括选项中指定字段的数值。因此，你不能使用**-q**选项，因为该选项会禁止打印常规数据包的汇总输出。同时，也不能使用**-V**选项，因为这会导致数据包的细节信息被打印出来，而非数据包的汇总信息。



Currently implemented statistics are:目前实现的统计有如下内容：

- **-z help**

  Display all possible values for **-z**.

  显示所有可能的数值

  

- **-z afp,srt[,*filter*]**

  Show Apple Filing Protocol service response time statistics.

  显示AFP服务器响应时间统计

  

- **-z conv,*type*[,*filter*]**

  Create a table that lists all conversations that could be seen in the capture. *type* specifies the conversation endpoint types for which we want to generate the statistics; currently the supported ones are:

  创建一个表，里面包含了所有统计信息，这些信息可以在捕获中看到。*type*指定了我们想要生成的统计信息的会话终端类型。目前支持的内容如下：

  ```bash
  "bluetooth"               Bluetooth addresses
  "eth"                     Ethernet addresses
  "fc"                      Fibre Channel addresses
  "fddi"                    FDDI addresses
  "ip"                      IPv4 addresses
  "ipv6"                    IPv6 addresses
  "ipx"                     IPX addresses
  "jxta"                    JXTA message addresses
  "ncp"                     NCP connections
  "rsvp"                    RSVP connections
  "sctp"                    SCTP addresses
  "tcp"                     TCP/IP socket pairs  Both IPv4 and IPv6 are supported
  "tr"                      Token Ring addresses
  "usb"                     USB addresses
  "udp"                     UDP/IP socket pairs  Both IPv4 and IPv6 are supported
  "wlan"                    IEEE 802.11 addresses
  ```

  If the optional *filter* is specified, only those packets that match the filter will be used in the calculations.

  如果指定了*filter*，则在计算时会使用匹配了过滤条件的这些数据包。

  The table is presented with one line for each conversation and displays the number of packets/bytes in each direction as well as the total number of packets/bytes. The table is sorted according to the total number of frames.

  这个表会为每个会话显示一行，并且显示每个方向的数据包/字节的数目及其总数。该表会依据数据帧数进行排序。

  {% asset_img 1553419331871.png This is an test image %}

  

- **-z bootp,stat[,*filter*]**

  Show DHCP (BOOTP) statistics.

  显示DHCP统计信息

  

- **-z dns,tree[,*filter*]**

  Create a summary of the captured DNS packets. General information are collected such as qtype and qclass distribution. For some data (as qname length or DNS payload) max, min and average values are also displayed.

  为捕获的DNS数据包创建一个汇总。核心信息包含了如qtype，qclass distribution。对于一些数据（如qname长度或是DNS负载）的最大，最小，平均值也会被显示出来。

  

- **-z endpoints,*type*[,*filter*]**

  Create a table that lists all endpoints that could be seen in the capture. *type* specifies the endpoint types for which we want to generate the statistics; currently the supported ones are:

  ```bash
  "bluetooth"               Bluetooth addresses
  "eth"                     Ethernet addresses
  "fc"                      Fibre Channel addresses
  "fddi"                    FDDI addresses
  "ip"                      IPv4 addresses
  "ipv6"                    IPv6 addresses
  "ipx"                     IPX addresses
  "jxta"                    JXTA message addresses
  "ncp"                     NCP connections
  "rsvp"                    RSVP connections
  "sctp"                    SCTP addresses
  "tcp"                     TCP/IP socket pairs  Both IPv4 and IPv6 are supported
  "tr"                      Token Ring addresses
  "usb"                     USB addresses
  "udp"                     UDP/IP socket pairs  Both IPv4 and IPv6 are supported
  "wlan"                    IEEE 802.11 addresses
  ```

  If the optional *filter* is specified, only those packets that match the filter will be used in the calculations（计算）.The table is presented with one line for each conversation and displays the number of packets/bytes in each direction as well as the total number of packets/bytes. The table is sorted according to the total number of frames.

  与**-z conv,*type*[,*filter*]**类似

  

- **-z expert \[*,error|,warn|,note|,chat|,comment*][*,filter*]**

  Collects information about all expert info, and will display them in order, grouped by severity.

  Example: **-z expert,sip** will show expert items of all severity for frames that match the sip protocol.

  This option can be used multiple times on the command line.

  收集所有的expert info专家信息，并按顺序及重要性分组来显示他们。

  例如: **-z expert,sip** 将显示与sip协议匹配的帧的所有重要专家项。

  

  If the optional *filter* is provided, the stats will only be calculated on those calls that match that filter.

  Example: **-z "expert,note,tcp"** will only collect expert items for frames that include the tcp protocol, with a severity of note or higher.

  如果提供了*filter*，则只会根据与该过滤器匹配的调用计算统计信息。

  例如：**-z "expert,note,tcp"** 将仅收集note或更高层级的包含了tcp协议的数据帧的专家项

  {% asset_img 1553419674561.png This is an test image %}

  

- **-z flow,*name*,*mode*,[*filter*]**

  Displays the flow of data between two nodes. Output is the same as ASCII format saved from GUI.

  *name* specifies the flow name. It can be one of:

  显示在两端的数据流。输出与从GUI保存的ASCII格式相同。

  ```bash
    any         All frames
    icmp        ICMP
    icmpv6      ICMPv6
    lbm_uim     UIM
    tcp         TCP
  ```

  *mode* specifies the address type. It can be one of:

  *mode* 指定了地址类型。可以是以下之一

  ```bash
    standard    Any address
    network     Network address
  ```

  Example: **-z flow,tcp,network** will show data flow for all TCP frame

  例如： **-z flow,tcp,network**将展示所有TCP帧的数据流

  

  

- **-z follow,*prot*,*mode*,*filter*[*,range*]**

  Displays the contents of a TCP or UDP stream between two nodes. 

  展示在两端的TCP或是UDP流的内容。

  *prot* specifies the transport protocol. It can be one of:

  ```bash
    tcp     TCP
    udp     UDP
    tls     TLS or SSL
  ```

  *mode* specifies the output mode. It can be one of:

  ```bash
    ascii    ASCII output with dots for non-printable characters
    ebcdic   EBCDIC output with dots for non-printable characters
    hex      Hexadecimal and ASCII data with offsets
    raw      Hexadecimal data
  ```

  

  *filter* specifies the stream to be displayed. UDP/TCP streams are selected with either the stream index or IP address plus port pairs. TLS streams are selected with the stream index. For example:

  ```
    ip-addr0:port0,ip-addr1:port1
    stream-index
  ```

  *range* optionally specifies which "chunks" of the stream should be displayed.

  

  Example: **-z "follow,tcp,hex,1"** will display the contents of the second TCP stream (the first is stream 0) in "hex" format.

  例如： **-z "follow,tcp,hex,1"**将会使用“hex”格式展示第二个TCP流的内容（第一个是stream 0）

  > ```
  > ===================================================================
  > Follow: tcp,hex
  > Filter: tcp.stream eq 1
  > Node 0: 200.57.7.197:32891
  > Node 1: 200.57.7.198:2906
  > 00000000  00 00 00 22 00 00 00 07  00 0a 85 02 07 e9 00 02  ...".... ........
  > 00000010  07 e9 06 0f 00 0d 00 04  00 00 00 01 00 03 00 06  ........ ........
  > 00000020  1f 00 06 04 00 00                                 ......
  > 00000000  00 01 00 00                                       ....
  > 00000026  00 02 00 00
  > ```

  {% asset_img 1553425530931.png This is an test image %}

  

  Example: **-z "follow,tcp,ascii,200.57.7.197:32891,200.57.7.198:2906"** will display the contents of a TCP stream between 200.57.7.197 port 32891 and 200.57.7.98 port 2906.

  例如：**-z "follow,tcp,ascii,200.57.7.197:32891,200.57.7.198:2906"**将会展示200.57.7.197的32891端口与200.57.7.98的2906端口的TCP流的内容

  > ```
  > ===================================================================
  > Follow: tcp,ascii
  > Filter: (omitted for readability)
  > Node 0: 200.57.7.197:32891
  > Node 1: 200.57.7.198:2906
  > 38
  > ...".....
  > ................
  > 4
  > ....
  > ```

  

- **-z hosts \[,ipv4][,ipv6]**

  Dump any collected IPv4 and/or IPv6 addresses in "hosts" format. Both IPv4 and IPv6 addresses are dumped by default.Addresses are collected from a number of sources, including standard "hosts" files and captured traffic.

  

  

- **-z http,stat,**

  Calculate the HTTP statistics distribution. Displayed values are the HTTP status codes and the HTTP request methods.

  {% asset_img 1553418861258.png This is an test image %}

  

- **-z** http,tree

  Calculate the HTTP packet distribution. Displayed values are the HTTP request modes and the HTTP status codes.

  {% asset_img 1553418910684.png This is an test image %}

  

- **-z http_srv,tree**

  Calculate the HTTP requests and responses by server. For the HTTP requests, displayed values are the server IP address and server hostname. For the HTTP responses, displayed values are the server IP address and status.

  {% asset_img 1553419156361.png This is an test image %}

  

- **-z** icmp,srt[,*filter*]

  Compute total ICMP echo requests, replies, loss, and percent loss, as well as minimum, maximum, mean, median and sample standard deviation SRT statistics typical of what ping provides.

  Example: **-z icmp,srt,ip.src==1.2.3.4** will collect ICMP SRT statistics for ICMP echo request packets originating from a specific host.This option can be used multiple times on the command line.

  计算总的ICMP回应请求，回复，丢失和百分比损失，以及ping提供的典型的最小值，最大值，平均值，中值和样本标准差SRT统计量。

  例如：**-z icmp,srt,ip.src==1.2.3.4**将收集源自特定主机的ICMP回送请求数据包的ICMP SRT统计信息。可以在命令行上多次使用此选项。

  {% asset_img 1553420285309.png This is an test image %}

  

- **-z io,phs[,*filter*]**

  Create Protocol Hierarchy Statistics listing both number of packets and bytes. If no *filter* is specified the statistics will be calculated for all packets. If a *filter* is specified statistics will only be calculated for those packets that match the filter.This option can be used multiple times on the command line.

  创建一个包含所有数据包和字节数的协议分层信息列表。

  {% asset_img 1553420404357.png This is an test image %}

  

- **-z io,stat,*interval*\[,*filter*]\[,*filter*][,*filter*]...**

  Collect packet/bytes statistics for the capture in intervals of *interval* seconds. *Interval* can be specified either as a whole or fractional second and can be specified with microsecond (us) resolution. If *interval* is 0, the statistics will be calculated over all packets.

  按时间间隔秒数收集捕获的数据包/字节数统计信息。时间间隔可以指定为整数或小数秒，并且可以使用微秒（us）。如果*interval*为0，则将计算所有数据包的统计信息。

  

  If no *filter* is specified the statistics will be calculated for all packets.If one or more *filters* are specified statistics will be calculated for all filters and presented with one column of statistics for each filter.

  This option can be used multiple times on the command line.

  如果没有指定过滤条件，则计算所有数据包的统计信息。如果一个或多个过滤条件被指定，那么会为所有的过滤条件来计算统计信息，并为每个过滤条件显示一列统计信息。可以在命令行上多次使用此选项。

  

  Example: **-z io,stat,1,ip.addr==1.2.3.4** will generate 1 second statistics for all traffic to/from host 1.2.3.4.

  例如： **-z io,stat,1,ip.addr==1.2.3.4** 将为所有进出主机1.2.3.4的流量生成1秒的统计信息

  

  Example: **-z "io,stat,0.001,smb&&ip.addr==1.2.3.4"** will generate 1ms statistics for all SMB packets to/from host 1.2.3.4.

  例如： **-z io,stat,1,smb&&ip.addr==1.2.3.4** 将为所有进出主机1.2.3.4的SMB流量生成1毫秒的统计信息

  

  The examples above all use the standard syntax for generating statistics which only calculates the number of packets and bytes in each interval.

  上面的示例都使用标准语法来生成统计信息，该统计信息仅计算每个间隔中的数据包和字节数。

  {% asset_img 1553422202759.png This is an test image %}

  

  {% asset_img 1553422247214.png This is an test image %}

  

  

- **-z io,stat,*interval*,"\[COUNT|SUM|MIN|MAX|AVG|LOAD](*field*)*filter*"**

  **io,stat** can also do much more statistics and calculate COUNT(), SUM(), MIN(), MAX(), AVG() and LOAD() using a slightly different filter syntax:

  **io,stat**还能做更多的统计和计算。如COUNT(), SUM(), MIN(), MAX(), AVG() and LOAD()，这些使用稍微不同的过滤器语法。

