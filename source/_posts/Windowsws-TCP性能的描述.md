---
title: Windowsws_TCP性能的描述
date: 2022-05-04 22:22:23
categories: 小技巧
tags:
---

This article describes the TCP features in Windows.

Applies to:   Windows 10 – all editions, Windows Server 2012 R2

Original KB number:   [224829](https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/description-tcp-features)

**Summary**

This article describes the following TCP features in Windows:

- TCP window size（TCP窗口大小）

- TCP options now supported（现在支持的TCP选项）

- Windows scaling - RFC 1323（Windows 缩放-RFC1323）

- Timestamp - RFC 1323（时间戳-RFC1323）

- Protection against Wrapped Sequence Numbers (PAWS) （对包装序列号的保护PAWS）

- Selective Acknowledgments (SACKS) - RFC 2018 （选择性ACK（SACKS）-RFC2018）

- TCP retransmission behavior and fast retransmit (TCP重传行为及快速重传)

- The TCP features can be changed by changing the entries in the registry. 通过修改注册表可以改变TCP性能

  <!--more-->

**Important**

The following sections, methods, or tasks contain steps that tell you how to modify the registry. However, serious problems might occur if you modify the registry incorrectly. Therefore, make sure that you follow these steps carefully. For added protection, back up the registry before you modify it. Then, you can restore the registry if a problem occurs. 

以下各节、方法或是任务所包含的步骤将指导你怎么修改注册表。然而，如果你错误的修改注册表可能会导致各种问题。因此，你要确保仔细的遵守以下步骤。为了增加保护，你可以在修改他们之前备份注册表。如果当故障发生时，你可以还原注册表。

For more information about how to back up and restore the registry, click the following article number to view the article in the Microsoft Knowledge Base: 322756 How to back up and restore the registry in Windows

关于如何备份及还原注册表的更多信息，点击以下文章编号以学习在微软知识库中的内容：[322756](https://support.microsoft.com/help/322756) How to back up and restore the registry in Windows

<br>

## TCP window size

The TCP receive window size is the amount of receive data (in bytes) that can be buffered during a connection. The sending host can send only that amount of data before it must wait for an acknowledgment and window update from the receiving host. The Windows TCP/IP stack is designed to self-tune itself in most environments, and uses larger default window sizes than earlier versions.

TCP接收窗口大小是接收数据的数据量（以字节表示），它能在一个连接中进行缓存数据。发送主机在等待来自接收主机的ack和窗口更新信息之前，只能发送一定数量的数据。Windows TCP/IP协议栈被设计于在大多数环境下进行自我调整，并且使用了比早期版本较大的默认窗口大小。

Instead of using a hard-coded default receive window size, TCP adjusts to even increments of the maximum segment size (MSS). The MSS is negotiated during connection setup. Adjusting the receive window to even increments of the MSS increases the percentage百分比 of full-sized TCP segments used during bulk data transmissions.

不再使用硬编码默认的接收窗口大小，TCP调整到最大段长（MSS）的整数倍。MSS是在连接建立的过程中协商的。在批量传输数据期间，通过增加MSS来调整接收窗口将提高全尺寸的TCP段的百分比。

The receive window size is determined in the following manner:

决定接收窗口的大小如下：

1.     The first connection request sent to a remote host advertises a receive window size of 16K (16,384 bytes).

 第一个连接请求发送到了远端主机以通告一个16KB的接收窗口大小。

2.     When the connection is established, the receive window size is rounded up to an even increment of the MSS.

当连接建立成功，接收窗口大小将四舍五入到MSS的整数倍。

3.     The window size is adjusted to four times the MSS, to a maximum size of 64 K, unless the window scaling option (RFC 1323) is used.

除非windows 缩放选项（RFC1323）被使用，不然窗口大小将调整为MSS的4倍，最大大小为64KB。

 **Note**

See the "Windows scaling" section

查看windows scaling部分.

For Ethernet connections, the window size will normally be set to 17,520 bytes (16K rounded up to twelve 1460-byte segments). The window size may reduce when a connection is established to a computer that supports extended TCP head options, such as Selective Acknowledgments (SACKS) and Timestamps. These two options increase the TCP header size to more than 20 bytes, which results in less room for data.

对于以太网连接，窗口大小通常设置为17520字节（16K（16384字节）四舍五入到12个1460字节的段长度）。当与支持扩展TCP头部选项（例如SACKS和时间戳被设置）的电脑建立完一个连接，窗口大小可能会降低。以下两个选项将突破TCP头部大小20字节的限制，这也将导致数据空间部分的减少。

In previous versions of Windows NT, the window size for an Ethernet connection was 8,760 bytes, or six 1460-byte segments.

在windowsNT之前的版本，对于一个以太网连接，窗口大小是8760字节，即6个1460字节个段长。

To set the receive window size to a specific value, add the TcpWindowSize value to the registry subkey specific to your version of Windows. To do so, follow these steps:

为了设置接收窗口大小到一个指定的数值，请在你指定的windows版本中添加TcpWindowSize值到注册表子键。要做到这点，请跟随以下步骤:

#### 调整接收窗口

1. Select **Start** > **Run**, type *`Regedit`*, and then select **OK**.
2. Expand the registry subkey specific to your version of Windows:
   - For Windows 2000, expand the following subkey: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces`
   - For Windows Server 2003, expand the following subkey: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters`
3. On the **Edit** menu, point to **New**, and then select **DWORD Value**.
4. Type *`TcpWindowSize`* in the **New Value** box, and then press Enter
5. Select **Modify** on the **Edit** menu.
6. Type the desired window size in the **Value data** box.

**Note**

```
The valid range for window size is 0-0x3FFFC000 Hexadecimal.
窗口大小的有效值范围是0-0x3FFFC000（1073725440字节=1023MB）
```

This value isn't present by default. When you add the TcpWindowSize value, it overrides the default window size algorithm discussed above.
默认情况下，该值是不存在的。当添加TcpWindowSize值时，它将覆盖上面讨论的默认窗口大小算法。

**Note**

```
TcpWindowSize can also be added to the Parameters key to set the window size globally for all interfaces.

TcpWindowSize也可以被添加到Parameters键，以全局设置所有接口的窗口大小。
```

<br>

## TCP options now supported

Previously, TCP options were used primarily for negotiating maximum segment sizes. In Windows, TCP options are used for Window Scaling, Time Stamp, and Selective ACK.

在以前，TCP选项主要用于协商最大段长。在windows中，TCP选项被用于窗口缩放，时间戳和SACK。

There are two types of TCP options: 有以下两类TCP选项

1. A single octet TCP option, which is used to indicate a specific option kind.

   一个字节数的TCP选项，被用于表示特定的选项类型

2. A multiple octet TCP option, which consists of an option kind, an option length and a series of option octets.

   多个字节数的TCP选项，它包含了一个选项类型，一个选项长度和多种选项字节。

The following list shows each TCP option kind, length, name, and description.

Kind: 0
Length: 1
Option: End of Option List
Description: Used when padding is needed for the last TCP option.

Kind: 1
Length: 1
Option: No Operation
Description: Used when padding is needed and more TCP options follow within the same packet.

Kind: 2
Length: 4
Option: Maximum Segment Size
Description: Indicates the maximum size for a TCP segment that can be sent across the network.

Kind: 3
Length: 3
Option: Window Scale Option
Description: Identifies the scaling factor to be used when using window sizes larger than 64k.

Kind: 8
Length: 10
Option: Time Stamp Option
Description: Used to help calculate the Round Trip Time (RTT) of packets transmitted.

Kind: 4
Length: 2
Option: TCP SACK permitted
Description: Informs other hosts that Selective Acks are permitted.

Kind: 5
Length: Varies
Option: TCP SACK Option
Description: Used by hosts to identify whether out-of-order packets were received.

<br>

## Windows scaling

For more efficient use of high-bandwidth networks, a larger TCP window size may be used. The TCP window size field controls the flow of data and is limited to 2 bytes, or a window size of 65,535 bytes.

为了更有效地使用高带宽网络，可以使用更大的TCP窗口大小。TCP窗口大小字段控制数据流，被限制为2字节，或者窗口大小为65,535字节（2到65535字节）。

Since the size field can't be expanded, a scaling factor is used. TCP window scale is an option used to increase the maximum window size from 65,535 bytes to 1 Gigabyte.

因为size字段不能被扩展，所以使用了一个缩放因子。TCP窗口缩放是一个选项，用于将最大窗口大小从65,535字节增加到1G字节。

The window scale option is used only during the TCP three-way handshake. The window scale value represents the number of bits to left-shift the 16-bit window size field. The window scale value can be set from 0 (no shift) to 14.

窗口缩放选项仅在TCP三向握手期间使用。窗口缩放值表示左移16位窗口大小字段的位数。窗口缩放值可以从0(不移位)到设置为14。

To calculate the true window size, multiply the window size by 2^S where S is the scale value.

要计算真正的窗口大小，将窗口大小乘以2^S，其中S是缩放值。

For Example:

If the window size is 65,535 bytes with a window scale factor of 3.
True window size = 65535*2^3

True window size = 524280

例如窗口大小是65535，窗口缩放因子是3，则真实窗口大小=65535*（2^3）=524280

The following Network Monitor trace shows how the window scale option is used:

下面的Network Monitor跟踪显示了如何使用窗口缩放选项:

```output
TCP: ....S., len:0, seq:725163-725163, ack:0, win:65535, src:1217 dst:139(NBT Session)  
TCP: Source Port = 0x04C1  
TCP: Destination Port = NETBIOS Session Service  
TCP: Sequence Number = 725163 (0xB10AB)  
TCP: Acknowledgement Number = 0 (0x0)  
TCP: Data Offset = 44 (0x2C)  
TCP: Reserved = 0 (0x0000)  
+ TCP: Flags = 0x02 : ....S.  
TCP: Window = 65535 (0xFFFF)  
TCP: Checksum = 0x8565  
TCP: Urgent Pointer = 0 (0x0)  
TCP: Options  
+ TCP: Maximum Segment Size Option  
TCP: Option Nop = 1 (0x1)  
TCP: Window Scale Option  
TCP: Option Type = Window Scale  
TCP: Option Length = 3 (0x3)  
TCP: Window Scale = 3 (0x3)  
TCP: Option Nop = 1 (0x1)  
TCP: Option Nop = 1 (0x1)  
+ TCP: Timestamps Option  
TCP: Option Nop = 1 (0x1)  
TCP: Option Nop = 1 (0x1)  
+ TCP: SACK Permitted Option  
```

The window size used in the actual three-way handshake isn't the window size that's scaled, per RFC 1323 section 2.2:

根据RFC1323的2.2节，实际上三次握手中使用的窗口大小不是缩放后的窗口大小

"The Window field in a SYN (for example, a [SYN] or [SYN,ACK]) segment itself is never scaled."

“SYN(例如，[SYN]或[SYN,ACK])段中的Window字段本身永远不会伸缩。”

It means that the first data packet sent after the three-way handshake is the actual window size. If there's a scaling factor, the initial window size of 65,535 bytes is always used. The window size is then multiplied by the scaling factor identified in the three-way handshake. The table below represents the scaling factor boundaries for various window sizes.

这意味着三次握手后发送的第一个数据包才是实际的窗口大小。如果存在缩放因子，则始终使用初始窗口大小65,535字节。然后将窗口大小乘以在三次握手中确定的缩放因子。以下表格表示了对于各类窗口大小的缩放因子边界。

| Scale Factor | Scale Value | Initial Window | Window Scaled |
| :----------- | :---------- | :------------- | :------------ |
| 0            | 1           | 65535 or less  | 65535 or less |
| 1            | 2           | 65535          | 131,070       |
| 2            | 4           | 65535          | 262,140       |
| 3            | 8           | 65535          | 524,280       |
| 4            | 16          | 65535          | 1,048,560     |
| 5            | 32          | 65535          | 2,097,120     |
| 6            | 64          | 65535          | 4,194,240     |
| 7            | 128         | 65535          | 8,388,480     |
| 8            | 256         | 65535          | 16,776,960    |
| 9            | 512         | 65535          | 33,553,920    |
| 10           | 1024        | 65535          | 67,107,840    |
| 11           | 2048        | 65535          | 134,215,680   |
| 12           | 4096        | 65535          | 268,431,360   |
| 13           | 8192        | 65535          | 536,862,720   |
| 14           | 16384       | 65535          | 1,073,725,440 |

For example:

If the window size in the registry is entered as 269000000 (269M) in decimal, the scaling factor during the three-way handshake is 13. A scaling factor of 12 only allows a window size up to 268,431,360 bytes (268M).

The initial window size in this example would be calculated as follows:
65,535 bytes with a window scale factor of 13.
True window size = 65535*2^13
True window size = 536,862,720

When the value for window size is added to the registry, and its size is larger than the default value, Windows attempts to use a scale value that accommodates the new window size.

当窗口大小的值添加到注册表中，并且其大小大于默认值时，Windows将尝试使用一个容纳新窗口大小的缩放值。



#### 调整窗口缩放及时间戳

The Tcp1323Opts value in the following registry key can be added to control scaling windows and timestamp:

```
HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Tcpip\Parameters
```

1. On the toolbar, select **Start** > **Run**, and then type *`Regedit`* to start the Registry Editor.
2. In the Registry Editor, select **Edit**, point to **New**, and then select **DWORD Value**.
3. In the New Value box, type *`Tcp1323Opts`*, press ENTER, and then on the **Edit** menu, select **Modify**.

**Note**

The valid range is 0, 1, 2 or 3 where:
0 (disable RFC 1323 options) 关闭RFC1323选项
1 (window scale enabled only) 仅开启窗口scale
2 (timestamps enabled only)仅开启时间戳
3 (both options enabled)开启所有选项

This registry entry controls RFC 1323 timestamps and window scaling options. Timestamps and Window scaling are enabled by default, but can be manipulated with flag bits. Bit 0 controls window scaling. Bit 1 controls timestamps.

这个注册表项控制RFC 1323时间戳和窗口缩放选项。时间戳和窗口缩放在默认情况下是启用的，但可以通过标志位进行操作。第0位控制窗口缩放。第1位控制时间戳。

<br>

## Selective Acknowledgments (SACKs)

Windows introduces support for a performance feature known as Selective Acknowledgment, or SACK. SACK is especially important for connections that use large TCP window sizes. Before SACK, a receiver could only acknowledge the latest sequence number of a contiguous data stream that had been received, or the "left edge" of the receive window. With SACK enabled, the receiver continues to use the ACK number to acknowledge the left edge of the receive window, but it can also acknowledge other blocks of received data individually. SACK uses TCP header options, as shown below.

Windows引入了对一种性能特性的支持，称为选择性承认(Selective Acknowledgment, SACK)。SACK对于使用大TCP窗口的连接尤其重要。在SACK之前，接收方只能确认已接收到的连续数据流的最新序列号或接收窗口的“左边缘”。启用SACK后，接收方继续使用ACK号来确认接收窗口的左边缘，但它也可以单独确认接收到的其他数据块。SACK使用TCP头选项，如下所示。

SACK uses two types of TCP Options.SACK使用了两种TCP选项的类型

The TCP Sack-Permitted Option is used only in a SYN packet (during the TCP connection establishment) to indicate that it can do selective ACK.

TCP Sack-Permitted选项仅在SYN包中使用(在TCP连接建立过程中)，用来指示它可以进行选择性ACK。

The second TCP option, TCP Sack Option, contains acknowledgment for one or more blocks of data. The data blocks are identified using the sequence number at the start and at the end of that block of data. It's also known as the left and right edge of the block of data.

第二个TCP选项，TCP Sack选项，包含对一个或多个数据块的确认。在数据块的开始和结束处使用序列号标识数据块。它也被称为数据块的左边缘和右边缘。

Kind 4 is TCP Sack-Permitted Option. Kind 5 is TCP Sack Option. Length is the length in bytes of this TCP option.

Tcp SACK Permitted:

| Kind = 4 | Length = 2 |
| :------- | :--------- |
| 1 byte   | 1 byte     |

Tcp SACK Option:

| Kind = 5 | Length = Variable                                            |
| :------- | :----------------------------------------------------------- |
| 1 byte   | Left edge of first block to Right edge of first block ... Left edge of Nth block to Right edge of Nth block |

With SACK enabled (default), a packet or series of packets can be dropped. The receiver informs the sender which data has been received, and where there may be "holes" in the data. The sender can then selectively retransmit the missing data without a retransmission of blocks of data that have already been received successfully. SACK is controlled by the SackOpts registry parameter.

启用SACK(默认开启)后，可以丢弃一个或一系列数据包。接收方通知发送方已接收到哪些数据，以及数据中的哪些地方可能存在“漏洞”。然后，发送方可以有选择地重新传输丢失的数据，而无需重新传输已经成功接收到的数据块。SACK由SackOpts注册表参数控制。

#### 调整SACK的支持

The SackOpts value in the following registry key can be edited to control the use of selective acknowledgments:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters
```

1. On the toolbar, select **Start** > **Run**, and then type *`Regedit`* to start the Registry Editor.
2. Locate and select the above key in the Registry Editor, and then select **Modify** on the **Edit** menu.
3. Type the desired value in the **Value data** box.

**Note**

The valid binary value is 0 or 1, the default value is 1. This parameter controls whether or not Selective ACK (SACK - RFC 2018) support is enabled.

二进制有效值为0或1，默认值为1。该参数用于控制是否启用对SACK - RFC 2018的支持。

<br>

## TCP retransmission behavior and fast retransmit

### TCP retransmission

As a review of normal retransmission behavior, TCP starts a retransmission timer when each outbound segment is handed down to the Internet Protocol (IP). If no acknowledgment has been received for the data in a given segment before the timer expires, then the segment is retransmitted.

The retransmission timeout (RTO) is adjusted continuously to match the characteristics of the connection using Smoothed Round Trip Time (SRTT) calculations as described in RFC 793. The timer for a given segment is doubled after each retransmission of that segment. Using this algorithm, TCP tunes itself to the normal delay of a connection.

### Fast retransmit

TCP retransmits data before the retransmission timer expires under some circumstances. The most common cause is a feature known as fast retransmit. When a receiver that supports fast retransmit receives data with a sequence number beyond the current expected one, some data was likely dropped. To help inform the sender of this event, the receiver immediately sends an ACK, with the ACK number set to the sequence number that it was expecting. It will continue to do so for each additional TCP segment that arrives. When the sender starts to receive a stream of ACKs that's acknowledging the same sequence number, a segment may have been dropped. The sender will immediately resend the segment that the receiver is expecting, without waiting for the retransmission timer to expire. This optimization greatly improves performance when packets are frequently dropped.

By default, Windows resends a segment under the following conditions:

- It receives three ACKs for the same sequence number: one ACK and two duplicates.

  对于同一个序列号，它会收到三个ACK:一个ACK，两个duplicate。

- The sequence number lags the current one.

This behavior is controllable with the `TcpMaxDupAcks` registry parameter.

这种行为可以通过TcpMaxDupAcks注册表参数来控制。

#### 启动快速重传所需的ack数量

The TcpMaxDupAcks value in the following registry key can be edited to control the number of ACKs necessary to start a fast retransmits:

可以编辑以下注册表项中的TcpMaxDupAcks值，以控制启动快速重传所需的ack数量:

```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters
```

1. On the toolbar, select **Start** > **Run**, and then type *`Regedit`* to start the Registry Editor.
2. Locate and select the above key in the Registry Editor, and then select **Modify** on the **Edit** menu.
3. Type the desired value in the **Value data** box.

**Note**

The valid range is 1-3, the default value is 2.

取值范围为1 ~ 3，缺省值为2。

This parameter determines the number of duplicate ACKs that must be received for the same sequence number of sent data before fast retransmit is triggered to resend the segment that has been dropped in transit.

 该参数决定了在快速重传被丢弃的报文段之前，必须接收到与已发送数据序列相同的ack的个数。