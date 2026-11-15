#!/bin/sh

cd $(dirname $0) && ./pci_endpoint_test -r pci_ep_data_transfer.memcpy.READ_TEST
cd $(dirname $0) && ./pci_endpoint_test -r pci_ep_data_transfer.memcpy.WRITE_TEST
cd $(dirname $0) && ./pci_endpoint_test -r pci_ep_data_transfer.memcpy.COPY_TEST
