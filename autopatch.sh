#!/bin/bash

set -eu
set -x

linux=$1
outdir="results/linux"

if [ "$#" == "2" ]; then
  msgid=$2
  outdir="results/${msgid}"
  b4 am ${msgid} -o ${outdir} 2> ${outdir}/b4_am.log
fi

apply_patches(){
  for patch in $@;
  do
    git am < ${patch}
  done
}

cd ${linux}
git stash -u                  
git checkout v7.0
apply_patches \
  ../patches/0001-PCI-qemu-Add-QEMU-PCIe-endpoint-controller-driver.patch \
  ../patches/0001-selftests-pci_endpoint-makes-a-pci_endpoint_test-bin.patch \
  ../patches/0001-hack-misc-pci_endpoint_test-XXX-Don-t-merge-this-com.patch \
  > ../${outdir}/pre_patches_apply.log

if [ -e ../${outdir}/*.mbx ]; then
  git am ../${outdir}/*.mbx > ../${outdir}/patch_apply.log
fi
if [ ! -f .config ]; then
  make defconfig > ../${outdir}/config.log
fi
./scripts/config \
  --enable BLK_DEV_NVME \
  --enable VFAT_FS \
  --enable NLS_CODEPAGE_437 \
  --enable NLS_ISO8859_1 \
  --enable PCI_ENDPOINT \
  --enable PCI_ENDPOINT_CONFIGFS \
  --enable PCI_EPF_TEST \
  --enable PCI_ENDPOINT_TEST \
  --enable PCIE_QEMU_EP
make olddefconfig >> ../${outdir}/config.log
make -j 32 > ../${outdir}/build.log
