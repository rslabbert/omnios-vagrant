# omnios-vagrant

A packer script to create an OmniOS vagrant box. Useful to get an OmniOS box running for development purposes.

Currently supports omnios-r151038, the latest stable & LTS release at time of commit.

# Notes

-   Initially adapted from https://github.com/kaorimatz/packer-templates
-   If you drop the CPU/Memory, you'll probably have to increase the wait time for the ZFS install as well
