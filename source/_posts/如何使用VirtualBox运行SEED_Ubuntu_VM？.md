---
title: 如何使用VirtualBox运行SEED_Ubuntu_VM？
date: 2019-09-07 23:49:44
categories: SEED Labs
tags:
---

[官方原文档](https://seedsecuritylabs.org/Labs_16.04/Documents/SEEDVM_VirtualBoxManual.pdf)

Install the free VirtualBox software first. We recommend **Version 6.0.4** (please stay away from the newer versions, as they still have some issues with our VM).

首先安装免费的VirtualBox软件。 我们建议使用版本6.0.4（请远离新版本，因为它们仍然存在我们的VM的一些问题）。

<!--more-->

<br>

## Step 1: Create a New VM in VirtualBox

步骤1：在VirtualBox中创建一个新的VM

{% asset_img 1.jpg This is an test image %}

<br>

## Step 2: Provide a Name and Select the OS Type and Version

步骤2：进行命名，同时选择操作系统的类型与版本

Do NOT pick Ubuntu (64-bit), even though your machine is 64 bit. Our prebuilt VM is 32-bit Ubuntu.

不要选择Ubuntu (64-bit)，尽管你的机器是64位的。我们预建的VM是32位的Ubuntu。

{% asset_img 2.jpg This is an test image %}

<br>

## Step 3: Set the Memory Size

步骤3：设置内存容量

{% asset_img 3.jpg This is an test image %}

<br>

## Step 4: Select the Pre-built VM File Provided by Us

步骤4： 选择使用我们提供的预建的VM文件

{% asset_img 4.jpg This is an test image %}

{% asset_img 5.jpg This is an test image %}

<br>

## In the above step, you may encounter(遭遇) the following error; otherwise, directly go to Step 5.

在上面的步骤中，你可能会遇到以下错误; 如果没有，则直接转到步骤5。

{% asset_img 6.jpg This is an test image %}

**Reason and Solution:** This is because you copied the VM files from another VM, which is already loaded into VirtualBox. These two VMs have the same UUID, which is not allowed by Virtualbox. Here are several solutions depending on your situations:

**原因和解决方法：**这是因为你从其他VM复制VM文件，而这个VM已经被加载过VirtualBox中了。这两个VM有着同样的UUID，而在VirtualBox中是不允许这样的。取决于你的状况，有以下几个解决方案：

- If you plan to create multiple VMs using the same image, please use the clone
  mechanism (See Appendix A for details).
- 如果你使用相同的镜像创建多个VM，请使用克隆机制（更多细节请参考附录A）
- If the older VM with the same UUID is no longer needed, remove it from VirtualBox will solve the problem.
- 如果不再需要具有相同UUID的旧的VM，则从VirtualBox中删除它可以解决问题。
- If you do want to keep the older VM, you can change the UUID of the new VM. The fastest way is to directly modify SEEDUbuntu16.04.vmdk, which is a text file. Search for the ddb.uuid.image entry, and change its value (e.g., change the last byte from ‘d’ to ‘e’)
- 如果你确实想要保留旧的VM，你可以为新的VM修改UUID。 最快的方法是直接修改SEEDUbuntu16.04.vmdk，这是一个文本文件。 搜索ddb.uuid.image条目，并更改其值（例如，将最后一个字节从“d”更改为“e”）

{% asset_img 7.jpg This is an test image %}

{% asset_img 8.jpg This is an test image %}

If there is no error (or after you fix the error), your VM will be created successfully.

如果没有出现错误（或是你已经修复了错误），你的VM将成功创建。

{% asset_img 9.jpg This is an test image %}

<br>

## Step 5: Configure the VM

步骤5：配置VM

{% asset_img 10.jpg This is an test image %}

{% asset_img 11.jpg This is an test image %}

{% asset_img 12.jpg This is an test image %}

{% asset_img 13.jpg This is an test image %}

{% asset_img 14.jpg This is an test image %}

{% asset_img 15.jpg This is an test image %}

{% asset_img 16.jpg This is an test image %}

<br>

## Step 6: Start the VM

步骤6：启动VM

{% asset_img 17.jpg This is an test image %}

<br>

## Step 7: Stop the VM or Save the VM’s State

步骤7：停止VM或是保存VM的状态

When you are done with your VM, you can always shut it down (from inside Ubuntu). A better alternative is to “freeze” the computer, so everything is saved. When you need it again, you can “unfreeze” it, and resume from where you left off. This is much faster and convenient than shutting down and rebooting the VM. To achieve this, you can use the “Save State” option.

用完VM后，你可以随时关闭它（从Ubuntu内部）。 更好的选择是“freeze冻结”计算机，以便保存所有内容。 当你再次需要它时，你可以“unfreeze解冻”它，并从你离开的地方恢复。 这比关闭和重新启动VM快得多，方便快捷。 为此，你可以使用“Save State保存状态”选项。

{% asset_img 18.jpg This is an test image %}

{% asset_img 19.jpg This is an test image %}

<br>

# Appendix A: Use “Clone” to create Multiple VMs
附录A：使用“克隆”以创建多个VM

Some SEED labs require multiple VMs. The easiest way to create multiple VMs is to create one first, and then use the “Clone” mechanism to clone it. Before doing the cloning, please ensure the following:

一些SEED实验需要多个VM。 创建多个VM的最简单方法是首先创建一个，然后使用“克隆”机制来克隆它。 在进行克隆之前，请确保以下内容：

- **IMPORTANT:** make sure that the VM is **fully shutdown** (not in a “Saved” state), or there will be all sorts of problems.

  **重要：**确保你的VM已经**完全关闭**（而不是处于“保存状态”），不然可能会有各种各样的问题。
- Configure network (see Appendix B); otherwise you have to do it for each VM.

  配置网络（参考附录B）；不然你就得为每个VM配置它了。
- Configure folder sharing (see Appendix D); otherwiseyou have to do it for each VM.

  配置文件夹共享（参考附录B）；不然你就得为每个VM配置它了。

{% asset_img 20.jpg This is an test image %}

{% asset_img 21.jpg This is an test image %}

{% asset_img 22.jpg This is an test image %}

The clone will take a few minutes, depending on the speed of your computer.

克隆将会持续几分钟，这取决于你的电脑。

<br>

# Appendix B: Network Configuration in VirtualBox for SEED Labs

附录B：为SEED实验在VirtualBox上配置网络

In many of the SEED labs, we need to run multiple guest VMs, and these VMs should be able to (1) reach out to the Internet, (2) communicate with each other. In Virtualbox, if we use the “NAT” setting (default setting) for each VM, we can achieve 1, but not 2, because each VM will be placed in its own private network, not on a common one; they even have the same IP address, which is not a problem because each VM is the only computer on its own private network. On the other hand, if we use the “Host-only” setting for each VM, we can achieve 2, but not 1. Using this setting, all the VMs and the host will be put on a common network, so they can communicate with each other; however, due to the lack of NAT, the VMs cannot reach out to the outside.

在许多SEED实验中，我们需要运行多个客户虚拟机，这些虚拟机应该能够（1）接入互联网，（2）相互通信。在Virtualbox中，如果我们为每个VM使用“NAT”设置（默认设置），我们可以实现1而不是2，因为每个VM将放置在自己的专用网络中，而不是普通的网络中;它们甚至具有相同的IP地址，这不是问题，因为每个VM是其自己的专用网络上唯一的计算机。另一方面，如果我们为每个VM使用“仅主机”的设置，我们可以实现2但不能达到1.使用此设置，所有VM和主机将被放在一个公共网络上，因此它们可以进行通信彼此;但是，由于缺少NAT，虚拟机无法与外界联系。

Therefore, in order to achieve all these 2 goals, we have to use a network adapter called “NAT Network”. The adapter works in a similar way to “local area network” or LAN. It enable VMs communication within same local network as well as the communication to the internet. All the communication goes through this single adapter. As show in Figure 1, gateway router transfers the packets among the VMs and transfers the packets from local network to Internet.

因此，为了同时实现这两个目标，我们必须使用称为“NAT网络”的网络适配器。适配器的工作方式与“局域网”或LAN类似。它支持在同一本地网络内进行VM通信以及与Internet的通信。所有通信都通过这个单一适配器。如图1所示，网关路由器在VM之间传输数据包，并将数据包从本地网络传输到Internet。

{% asset_img 23.jpg This is an test image %}

<br>

## Configuration Instruction 

配置介绍

**Step 1**: Make sure you are using the most up-to-date VirtualBox. As show in the following figure, click the “File” on the top left of the VirtualBox main UI. Then choose “Preferences…” option.

**步骤1：**确保您使用的是最新的VirtualBox。 如下图所示，单击VirtualBox主UI左上角的“文件”。 然后选择“首选项...”选项。

{% asset_img 24.jpg This is an test image %}



**Step 2**: Click the “Network” tab on left panel. click the “+” button to create a new NAT Networks (NatNetwork) adaptor (if one does not exist). Double click on the NatNetwork, and look at its specifications. Set the specifications as the same as what is shown below.

**步骤2：**点击左侧栏中的“网络”键。点击“+”号按钮以创建一个新的NAT网络适配器（如果一个都没有的话）。双击这个NatNetwork，并且查看它的格式规范，照下图的配置来进行设置。

{% asset_img 25.jpg This is an test image %}

**Step 4**: Go to VM setting, you need to power off the VM before making the following changes. Enable Adapter 1(at the same time, disable the other adapters), and choose “NAT Network”.

**步骤4**：回到VM的设置，你需要确保在做以下操作的前已经对VM完全关机。开启适配器1（与此同时关闭其他适配器），并且选择“NAT网络”。

{% asset_img 26.jpg This is an test image %}

**Step 5**: Now power on the VM, and check the IP address.

**步骤5：**现在开启VM，并且检查IP地址

{% asset_img 27.jpg This is an test image %}

**Troubleshooting**:

If VMs can not ping each other, refresh the MAC Address can resolve the issue. The way to resolve the issue is shown in figure 4, troubleshoot 1.

如果VM之间无法互相ping通，重新获取MAC地址能解决该问题。解决问题的方法在上面步骤4，点击那个

troubleshoot 1。

<br>

# Appendix C: Take Snapshots and Recover from Snapshots

附录C：创建快照与从快照中恢复

For some labs, you may need to make changes to the operating system. If you make a severe mistake, your VM may not be able to boot up again, and you will lost everything inside the failed VM. have done. To avoid such trouble, before doing anything dangerous to the OS, it is better to take a snapshot of your current VM. You can take as many snapshots as you want.

对于一些实验，你可能需要对操作系统做出改变。如果你的操作导致服务器出现问题，你的VM可能无法再次启动了，并且你将丢失在这个故障VM中的所有内容。在对操作系统做任何危险操作前，为了避免上述问题出现，最好就是对当前的VM创建快照。只要你想，你能创建任意个数量的快照。

{% asset_img 28.jpg This is an test image %}

To restore from a snapshot that you have taken before, you can click the followings (you need to shut-down the VM first):

要从之前拍摄的快照还原，可以单击以下内容（你需要先关闭VM）：

{% asset_img 29.jpg This is an test image %}

<br>

# Appendix D: Folder Sharing

附录D：文件夹分享

Files can be shared between the host computer and the guest operating system in VirtualBox. The following steps show how to do so.

在主机电脑和VirtualBox中的客户操作系统间，文件是可以共享的。以下步骤将告诉你如何去做。

1. Create the folder to be shared on the host computer. In this tutorial we name the folder share.

   在主机电脑上创建一个用于共享的文件夹。在本教程中，我们给文件夹取名叫share。

2. Boot the Guest operating system in VirtualBox.

   在VirtualBox中启动用户操作系统。

3. Go to the Settings popup window, and select “Shared Folders”

   回到设置弹出窗口，并选择“分享文件夹”。

{% asset_img 30.jpg This is an test image %}

4. Choose the 'Add' button.

   选择“添加”按钮。

{% asset_img 31.jpg This is an test image %}

5. Choose “Other …”, and select a folder from the popup window.

   选择“其他……”，并从弹出窗口中选择文件夹。

{% asset_img 32.jpg This is an test image %}

6. Select **Auto Mount** and **Make Permanent** option. Click OK. Click OK again to close the Settings Dialog.

   选择**动态挂载**和**Make Permanent（常设，永久）** 选项。点击完成。再次点击完成以关闭设置对话框。

{% asset_img 33.jpg This is an test image %}

7. Open a terminal in the VM. Make a directory and name it host (you can choose any name you like). Use command “mkdir /home/seed/host”

   打开VM中的终端，创建一个目录并将其命名为host（你可以选择任何您喜欢的名称）。使用命令“mkdir /home/seed/host”（因为上面那张图的挂载目录写的就是这个文件夹地址，所以你也得确保在VM中创建了这个文件夹）

8. We want files in our mount point (~/host) to be owned by the current user. Also we want the mounted shared folder to persist after reboot. Hence, we will edit the /etc/rc.local file (using “sudo gedit /etc/rc.local”) and add the command below (1000 is the User ID and group ID of the user seed):

   我们希望挂载点（〜/ host）中的文件归当前用户所有。 此外，我们希望挂载的共享文件夹在重新启动后保持不变。 因此，我们将编辑 /etc/rc.local文件（使用“sudo gedit /etc/rc.local”）并添加以下命令（1000是用户ID和用户种子的组ID）：

   **sudo mount -t vboxsf -o rw,uid=1000,gid=1000 share /home/seed/host**

{% asset_img 34.jpg This is an test image %}

9. Save the changes and reboot VM. Now anything placed in /home/seed/host inside the VM should be visible from the share folder on the host machine, and vice versa.

   保存更改并重启VM。 现在，从主机上的共享文件夹中可以看到放在VM中/home/seed/host中的任何内容，反之亦然。