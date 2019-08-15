KERNEL=/home/jordan/oss/lkd/linux-tpmdd/arch/x86_64/boot/bzImage
IMAGE=/home/jordan/qemu/arch.img

mkdir -p /tmp/mytpm1
swtpm socket --tpmstate dir=/tmp/mytpm1 \
    --tpm2 \
    --ctrl type=unixio,path=/tmp/mytpm1/swtpm-sock \
    --log level=20 &

sudo qemu-system-x86_64 \
    -enable-kvm \
    -hda $IMAGE \
    -m 2G \
    -net nic -net user,hostfwd=tcp::2222-:22 \
    -serial stdio \
    -kernel $KERNEL \
    -append "console=ttyS0 root=/dev/sda1 rw" \
    -display none \
    -chardev socket,id=chrtpm,path=/tmp/mytpm1/swtpm-sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0

ps aux | grep swtpm | awk '{print $2}' | xargs kill -9

