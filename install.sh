qemu-img create -f raw arch.img 4G
qemu-system-x86_64 -boot order=d \
    -net nic -net user \
    -drive file=arch.img,format=raw -m 2G \
    -cdrom images/archlinux-2019.08.01-x86_64.iso
