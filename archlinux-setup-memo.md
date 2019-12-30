## 一回消してやり直す

構成

ArchLinux
GNOME (Wayland) / GDM
  - Waylandはちょっと勇気いるけど、まァ一応実用に耐えるらしいし。
  - HiDPIの対応遅れがこんなに進まないのはやはりXorgの不健全さを感じる

一からやり直し、で参考になりそうな記事

https://qiita.com/Connie/items/3a6892a555a17a333c57
https://qiita.com/miy4/items/796c51813417cc90c77f

Windowsも消そう。前回設定したEFIが心配だけど。

## 経緯メモ

### インストールメディアをつくる

Archlinux Wiki参照

### インストールメディアからLinuxを起動する

1. USBメモリをさし、電源ON
1. LENOVOロゴの画面でEnterを押す
1. Startup Interrupt Menuの画面でF1を押す
1. Secure Bootを無効にする
  1. Security＞Secure Boot
  1. Secure BootがDisabledであることを確認
1. USBメモリのLinuxの起動を最優先にする
  1. ESCを押して、Startup＞Boot
  1. USBメモリのBoot Priority Orderを1番にする
  1. ここでLinux Bootが残ってたので、Deleteで消しておいた。
      Windowsはどうしようか悩んだけど、WindowsのBootがどこから手に入れるのか知らんかったので辞めておいた
1. F10 (Save and Exit)を押して、Yesを選択する
1. 再起動し、インストールメディアが起動する

### パーティション設定

まずは今何があるか見る

```console
$ parted /dev/nvme0n1 print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 512GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End    Size    File system  Name                          Flags
 1      1049kB  274MB  273MB   fat32        EFI system partition          boot, hidden, esp
 2      274MB   290MB  16.8MB               Microsoft reserved partition  msftres
 3      290MB   167GB  167GB                Basic data partition          msftdata
 4      511GB   512GB  1049MB  ntfs         Basic data partition          hidden, diag
```

nvme0n1ってなんだろう。archisoが外部のSSDをそう認識するのか？
ThinkPadならではなのか？
ArchLinux Wikiによると後者のようだ。

> デバイスを確認するには、lsblk または fdisk を使ってください:

### NetworkにつないでSSHで接続

上の表コピって疲れた。流石にSSH経由でやろう。
Wi-Fi経由でやれる。便利。

```console
root@archiso ~ # wifi-menu
root@archiso ~ # ping -4 -c 3 ftp.tsukuba.wide.ad.jp
root@archiso ~ # ping -4 -c 3 ftp.jaist.ac.jp
```

パスワード設定してSSHを起動する。

```console
root@archiso ~ # passwd
root@archiso ~ # systemctl start sshd
```

接続するべきIPアドレスを取得する

```console
root@archiso ~ # ip addr
```

他から接続する

```console
$ ssh 192.168.1.x -l root
```

### 気を取り直してパーティション作り直し

Windows云々もあるけど、めんどくさくなったので全てのパーティションを一回消した。

```console
root@archiso ~ # parted /dev/nvme0n1 rm 1
Information: You may need to update /etc/fstab.

root@archiso ~ # parted /dev/nvme0n1 rm 2
Information: You may need to update /etc/fstab.

root@archiso ~ # parted /dev/nvme0n1 rm 3
Information: You may need to update /etc/fstab.

root@archiso ~ # parted /dev/nvme0n1 rm 4
Information: You may need to update /etc/fstab.

root@archiso ~ # parted /dev/nvme0n1 print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 512GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start  End  Size  File system  Name  Flags

```

### パーティションテーブルを作る

今更MBRを使う気もないので、UEFI/GPTとして、
シングルrootで。スワップファイルでパフォーマンスも最適にしておきたい

| マウントポイント | パーティション | パーティションタイプ | 容量 |
| /mnt/boot または /mnt/efi | /dev/sdX1 | EFI システムパーティション | 260–512 MiB |
| /mnt | /dev/sdX2 | Linux x86-64 root (/) | デバイスの残り容量全て |

```console
root@archiso ~ # parted /dev/nvme0n1 \
    -s mklabel gpt \
    -s mkpart ESP fat32 1MiB 513MiB \
    -s set 1 boot on \
    -s mkpart primary ext4 513MiB 100%
root@archiso ~ # parted /dev/nvme0n1 print
Model: Unknown (unknown)
Disk /dev/nvme0n1: 512GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End    Size   File system  Name     Flags
 1      1049kB  538MB  537MB  fat32        ESP      boot, esp
 2      538MB   512GB  512GB               primary
```

### /boot パーティションをフォーマットする

```console
root@archiso ~ # mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.fat 4.1 (2017-01-24)
```

### / (root) パーティションを暗号化してフォーマットする

#### LUKSコンテナを作成する

```console
root@archiso ~ # cryptsetup luksFormat /dev/nvme0n1p2

WARNING!
========
This will overwrite data on /dev/nvme0n1p2 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase for /dev/nvme0n1p2: 
Verify passphrase: 
cryptsetup luksFormat /dev/nvme0n1p2  17.04s user 0.75s system 97% cpu 18.180 total
```

#### LUKSコンテナにLVMボリュームを作成する

* 物理ボリューム: /dev/mapper/lvm
  * ボリュームグループ: volume
  * 論理ボリューム #1: root
    * 全領域
    * /にマウントする

```console
root@archiso ~ # cryptsetup open /dev/nvme0n1p2 lvm
Enter passphrase for /dev/nvme0n1p2: 
cryptsetup open /dev/nvme0n1p2 lvm  6.56s user 0.26s system 90% cpu 7.568 total
root@archiso ~ # pvcreate /dev/mapper/lvm          
  Physical volume "/dev/mapper/lvm" successfully created.
root@archiso ~ # vgcreate volume /dev/mapper/lvm
  Volume group "volume" successfully created
root@archiso ~ # lvcreate --extents +100%FREE volume --name root
  Logical volume "root" created.
```

#### ファイルシステムを作成する

```console
root@archiso ~ # mkfs.ext4 /dev/mapper/volume-root
mke2fs 1.45.3 (14-Jul-2019)
Creating filesystem with 124891136 4k blocks and 31227904 inodes
Filesystem UUID: ffd3b86f-9bef-4a38-9625-ff392f84e132
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
        102400000

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done     
```

### パーティションのマウント

```console
root@archiso ~ # mount /dev/mapper/volume-root /mnt
root@archiso ~ # mkdir /mnt/boot
root@archiso ~ # mount /dev/nvme0n1p1 /mnt/boot
```

### システムクロックの更新

ファイルいじるからだろうけど、クロックちゃんと正確にしたほうが良いみたい。

```console
root@archiso ~ # timedatectl set-ntp true
```


### 本体のインストール

基本ArchLinux Wikiに従う

> #### ミラーの選択
>
> /etc/pacman.d/mirrorlist を編集してミラーを選択してください。位置的に一番近いミラーがベストです。設定したミラーリストが pacstrap によってインストール時にコピーされます。
>
> #### ベースシステムのインストール
>
> pacstrap スクリプトを使用して base パッケージと Linux カーネル、ファームウェアをインストールしてください:
>
> # pacstrap /mnt base linux linux-firmware
> ヒント: linux は他のカーネルパッケージに置き換えることができ、また、コンテナとして使うなど、カーネルが必要ない場合はインストールしない選択肢もあります。
> base パッケージにはライブ環境に含まれているツールが全て含まれているわけではありません。したがって、ベースシステムを機能させるには別途以下のようなパッケージをインストールする必要があります。
>
> * システムで使用するファイルシステムのユーザースペースユーティリティ
> * RAID や LVM パーティションにアクセスするためのユーティリティ
> * linux-firmware に含まれていないデバイスを動かすためのファームウェアファイル
> * ネットワークを設定するのに必要なソフトウェア
> * テキストエディタ
> * man や info ページのドキュメントを読むためのパッケージ: man-db, man-pages, texinfo
> 他のパッケージやグループをインストールしたい場合、上記の pacstrap コマンドの後ろに（スペースで区切ってから）パッケージ名を追加してください。また、chroot を実行した後に pacman コマンドでインストールすることも可能です。ライブ環境に含まれていてデフォルトでインストールされてないパッケージは packages.x86_64 を見てください。
>
> AUR からソフトウェアをコンパイルしたり ABS を使うつもりであれば、base-devel パッケージグループもインストールするべきです。

とのことなので、

```console
root@archiso ~ # vim /etc/pacman.d/mirrorlist
```

として、中身をJapanの3つ（cat.net, jaist.ac.jo, tsukuba.wide.ad.jp）だけにする

( `:v/cat\.net\|\.jp\//d` とかすると良いかも

```console
root@archiso ~ # cat /etc/pacman.d/mirrorlist 
Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
```

インストールするものも、なんか面倒くさそうなのでいりそうなもの片っ端から入れちゃう

```console
root@archiso ~ # pacstrap /mnt base linux linux-firmware man-db man-pages texinfo lvm2 base-devel vim netctl dhcpcd openssh zsh
```

### fstabを作る

fstabというのを生成する。
ArchLinux wikiによると

> /etc/fstab ファイルはディスクパーティションや様々なブロックデバイス、リモートファイルをどうやってファイルシステムにマウントするかを記述します。

らしい。どういうこっちゃ。

```console
root@archiso ~ # genfstab -U /mnt >> /mnt/etc/fstab
root@archiso ~ # cat /mnt/etc/fstab
# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>
# /dev/mapper/volume-root
UUID=ffd3b86f-9bef-4a38-9625-ff392f84e132       /               ext4            rw,relatime     0 1

# /dev/nvme0n1p1
UUID=AA66-ACD2          /boot           vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro  0 2
```

ほーん。

### いよいよ本体に入る

ここまであくまでインストールメディア内の（archiso）Linuxでの作業なので、
本体の方に chroot で入る

```console
root@archiso ~ # arch-chroot /mnt
[root@archiso /]# 
```

ひょー

### タイムゾーンとかロケーションの設定

この辺はお定まり。
ただ、間違ってもシステムレベルのロケーションはja_JPにしないほうが良い。
（フォントが読み込まれない状況では文字化けが起きる）

```console
[root@archiso /]# ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
[root@archiso /]# vim /etc/locale.gen
[root@archiso /]# cat /etc/locale.gen | grep -e 'ja_JP\|en_US'
#  en_US ISO-8859-1
#  en_US.UTF-8 UTF-8
en_US.UTF-8 UTF-8  
#en_US ISO-8859-1  
#ja_JP.EUC-JP EUC-JP  
ja_JP.UTF-8 UTF-8  
[root@archiso /]# locale-gen
Generating locales...
  en_US.UTF-8... done
  ja_JP.UTF-8... done
Generation complete.
[root@archiso /]# echo LANG=en_US.UTF-8 > /etc/locale.conf
[root@archiso /]# localectl set-locale LANG=en_US.UTF-8
[root@archiso /]# hwclock --systohc
```

### ホスト名の設定

hostsファイルの `127.0.1.1` が何なのか少し気になるけど

```console
[root@archiso /]# echo kyoh86-thinkpad > /etc/hostname
[root@archiso /]# vim /etc/hosts 
[root@archiso /]# cat /etc/hosts
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1       localhost
::1     localhost
127.0.1.1       kyoh86-thinkpad.localdomain     kyoh86-thinkpad
```

### initramfsをインストールする

暗号化した/ (root)の読み込みにdm-crypt使ってるので、必要になる。
lvm2ちゃんとインストールしてないとエラーになるので注意。

```console
[root@archiso /]# sed -i.backup '/^HOOKS=/ s/ filesystems / encrypt lvm2 resume filesystems /' /etc/mkinitcpio.conf
[root@archiso /]# diff /etc/mkinitcpio.conf.backup /etc/mkinitcpio.conf
52c52
< HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
---
> HOOKS=(base udev autodetect modconf block encrypt lvm2 resume filesystems keyboard fsck)
[root@archiso /]# mkinitcpio --preset linux
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'default'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
==> Starting build: 5.4.6-arch3-1
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [autodetect]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
  -> Running build hook: [encrypt]
  -> Running build hook: [lvm2]
  -> Running build hook: [resume]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux.img
==> Image generation successful
==> Building image from preset: /etc/mkinitcpio.d/linux.preset: 'fallback'
  -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autode
tect
==> Starting build: 5.4.6-arch3-1
  -> Running build hook: [base]
  -> Running build hook: [udev]
  -> Running build hook: [modconf]
  -> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: aic94xx
  -> Running build hook: [encrypt]
  -> Running build hook: [lvm2]
  -> Running build hook: [resume]
  -> Running build hook: [filesystems]
  -> Running build hook: [keyboard]
  -> Running build hook: [fsck]
==> Generating module dependencies
==> Creating gzip-compressed initcpio image: /boot/initramfs-linux-fallback.img
==> Image generation successful
```

### ブートローダーインストール

EFIに乗せる

```console
[root@archiso /]# bootctl --path=/boot install
Created "/boot/EFI".
Created "/boot/EFI/systemd".
Created "/boot/EFI/BOOT".
Created "/boot/loader".
Created "/boot/loader/entries".
Created "/boot/EFI/Linux".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/systemd/systemd-bootx64.efi".
Copied "/usr/lib/systemd/boot/efi/systemd-bootx64.efi" to "/boot/EFI/BOOT/BOOTX64.EFI".
Created "/boot/0f861ec8c4eb4b949822ff2356b84aa8".
Random seed file /boot/loader/random-seed successfully written (512 bytes).
Created EFI boot entry "Linux Boot Manager".
[root@archiso /]# echo 'default arch' >> /boot/loader/loader.conf
[root@archiso /]# echo 'timeout 5' >> /boot/loader/loader.conf
[root@archiso /]# UUID_CRYPTDEVICE=$(find /dev/disk/by-uuid -lname ../../nvme0n1p2 -printf "%f\n" | head -n 1)
[root@archiso /]# cat << __ARCH_CONF__ > /boot/loader/entries/arch.conf
> title Arch Linux
> linux /vmlinuz-linux
> initrd /initramfs-linux.img
> options cryptdevice=UUID=${UUID_CRYPTDEVICE}:volume root=/dev/mapper/volume-root rw intel_pstate=no_hwp
> __ARCH_CONF__
```

### EFI ブートマネージャの更新

ArchLinux Wikiによると、

> systemd-boot のバージョンが新しくなった場合、ユーザーがブートマネージャを更新する必要があります。手動で行ったり、もしくは pacman フックを使って自動で更新できます。
>
> 自動で更新
> systemd-boot-pacman-hookAUR パッケージには上記のアップデートを自動化する Pacman フックが含まれています。パッケージをインストールすると systemd パッケージをアップグレードしたときに毎回フックが起動するようになります。また、パッケージをインストールする代わりに、/etc/pacman.d/hooks/ ディレクトリに以下の pacman フックを作成することでも自動更新できます:
>
> /etc/pacman.d/hooks/systemd-boot.hook
> [Trigger]
> Type = Package
> Operation = Upgrade
> Target = systemd
>
> [Action]
> Description = Updating systemd-boot
> When = PostTransaction
> Exec = /usr/bin/bootctl update

らしいので設定しちゃう

```console
[root@archiso /]# mkdir /etc/pacman.d/hooks
[root@archiso /]# vim /etc/pacman.d/hooks/systemd-boot.hook
[root@archiso /]# cat /etc/pacman.d/hooks/systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
```

### ルートパスワードを設定する

```console
[root@archiso /]# passwd
```

### SSHでつなげるようにしておく

```console
[root@archiso /]# vim /etc/ssh/sshd_config
[root@archiso /]# grep -e 'PermitRootLogin' /etc/ssh/sshd_config
PermitRootLogin yes
```

### 再起動

[root@archiso /]# exit
exit
root@archiso ~ # umount -R /mnt
root@archiso ~ # reboot
Connection to 192.168.1.x closed by remote host.
Connection to 192.168.1.x closed.
```

ディスク暗号化解除のパスワードを聞かれるのでさっき設定したやつを入れる。
ユーザー名聞かれるので `root`。パスワードはさっき設定したやつ。

### Wi-Fiにつなぐ

Wi-Fiのプロファイルを作るのダルいけど、wifi-menuで繋げば良い
ただし、DNSが上手くつながらんので、/etc/resolv.confで設定する

```console
# vim /etc/resolv.conf
# cat /etc/resolv.conf
# Generated by resolvconf
nameserver 8.8.8.8
```

あとはまたSSHでつないで作業する

### マイクロコードをインストールする

UNDONE:

### GNOME入れちゃう

```console
[root@kyoh86-thinkpad ~]# pacman -S gnome
:: 67 個のパッケージがグループ gnome に存在します:
:: リポジトリ extra
   1) baobab  2) cheese  3) eog  4) epiphany  5) evince  6) file-roller  7) gdm  8) gedit
   9) gnome-backgrounds  10) gnome-books  11) gnome-calculator  12) gnome-calendar
   13) gnome-characters  14) gnome-clocks  15) gnome-color-manager  16) gnome-contacts
   17) gnome-control-center  18) gnome-dictionary  19) gnome-disk-utility  20) gnome-documents
   21) gnome-font-viewer  22) gnome-getting-started-docs  23) gnome-keyring  24) gnome-logs
   25) gnome-maps  26) gnome-menus  27) gnome-music  28) gnome-photos  29) gnome-remote-desktop
   30) gnome-screenshot  31) gnome-session  32) gnome-settings-daemon  33) gnome-shell
   34) gnome-shell-extensions  35) gnome-system-monitor  36) gnome-terminal
   37) gnome-themes-extra  38) gnome-todo  39) gnome-user-docs  40) gnome-user-share
   41) gnome-video-effects  42) gnome-weather  43) grilo-plugins  44) gvfs  45) gvfs-afc
   46) gvfs-goa  47) gvfs-google  48) gvfs-gphoto2  49) gvfs-mtp  50) gvfs-nfs  51) gvfs-smb
   52) mousetweaks  53) mutter  54) nautilus  55) networkmanager  56) orca  57) rygel  58) sushi
   59) totem  60) tracker  61) tracker-miners  62) vino  63) xdg-user-dirs-gtk  64) yelp
:: リポジトリ community
   65) gnome-boxes  66) gnome-software  67) simple-scan

選択して下さい (デフォルト=all): 
依存関係を解決しています...
（略）
```

### GDMなどGNOME関係のサービスを起動しちゃう

[root@kyoh86-thinkpad ~]# systemctl enable gdm
Created symlink /etc/systemd/system/display-manager.service → /usr/lib/systemd/system/gdm.service.
[root@kyoh86-thinkpad ~]# systemctl enable NetworkManager.service
[root@kyoh86-thinkpad ~]# systemctl start NetworkManager

### ユーザーセットアップ

```console
[root@kyoh86-thinkpad ~]# useradd -m -G wheel -s /usr/bin/zsh kyoh86
[root@kyoh86-thinkpad ~]# passwd kyoh86
[root@kyoh86-thinkpad ~]# EDITOR=/usr/bin/vim visudo
[root@kyoh86-thinkpad ~]# tail -N1 /etc/sudoers
kyoh86 kyoh86-thinkpad=(ALL) ALL
```

sudoersとしては、visudo起動後に一番末尾に上記の通りの内容を記載しておく。
ホスト名がkyoh86-thinkpadと固定されていることに注意（つまりSSHではsudoできない）



## Locale

set LANG=en_US.UTF-8 in /etc/locale.conf
change locale with the Desktop Environment. (like LXQt)
like below (in ~/.config/lxqt/lxqt-config-locale.conf)
```
[General]
__userfile__=true

[Formats]
LANG=ja_JP.UTF-8
```

## ime

fcitx + Mozc

## Tethering

Androidだけど、iPhoneでもこれだった
ref: https://wiki.archlinux.jp/index.php/Android_%E3%83%86%E3%82%B6%E3%83%AA%E3%83%B3%E3%82%B0#Bluetooth_.E3.81.A7.E3.83.86.E3.82.B6.E3.83.AA.E3.83.B3.E3.82.B0

Bluetooth でテザリング
Android (4.0 以降。前のバージョンでも出来ることあり) はアクセスポイントモードの Bluetooth パーソナルエリアネットワーク (PAN) に対応しています。

NetworkManager がこのアクションを実行できネットワークの初期化を処理します。詳しくはドキュメントを見て下さい。

もしくは: Bluetooth の記事の記述に従って、ペアリングをしてコンピュータと Android デバイスを接続できるようにしてから、次を実行 (デバイスのアドレス (AA_BB_CC_DD_EE_FF) は置き換えて下さい):

$ dbus-send --system --type=method_call --dest=org.bluez /org/bluez/hci0/dev_AA_BB_CC_DD_EE_FF org.bluez.Network1.Connect string:'nap'

これでネットワークインターフェース bnep0 が作成されます。最後に、このインターフェースでネットワーク接続を設定してください。Android はデフォルトで DHCP を提供します。

-> XFCEならNetworkManagerがいい感じ

## Wi-Fi

not setup wpa_supplicant.conf
never use netctl enable {profile}
create /etc/netctl/{profile} ( from /etc/netctl/examples/wireless-wpa-configsection )
use netctl-ifplugd@{interface} and netctl-auto@{interface}

ref:  https://wiki.archlinux.jp/index.php/NetCtl

-> XFCEならNetworkManagerがいい感じ

```
$ sudo pacman -S networkmanager network-manager-applet xfce4-notifyd gnome-keyring
$ sudo systemctl enable NetworkManager.service
```

ref: http://grainrigi.hatenablog.com/entry/2017/12/02/222955
