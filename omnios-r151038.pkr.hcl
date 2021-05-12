
variable "compression_level" {
  type    = string
  default = "6"
}

variable "cpus" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "40000"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "c4f91c755668c8ce5d5aa818b8249f3ab33fbd579b312513ec5c63e857cbbc2d"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "mirror" {
  type    = string
  default = "https://downloads.omnios.org/media/stable"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

source "virtualbox-iso" "vbox" {
  boot_command      = [
    // Start booting
    "<enter><wait10>",

    // Enter text mode installer
    // Select default keyboard layout
    // Start installer config
    "T<wait>",
    "<enter><wait>",
    "<enter><wait>",

    // Select disk 1 for rpool
    // Finish disk setup
    // Confirm rpool as pool name
    "1<enter><wait>",
    "0<enter><wait>",
    "<enter><wait>",

    // Confirm omnios as hostname
    "<enter><wait>",

    // Select custom timezone
    // Use UTC as timezone
    // Confirm correct timezone
    "11<enter><wait>",
    "UTC<enter><wait>",
    "1<enter><wait>",

    // Wait 2 minutes for ZFS install
    "<wait10><wait10><wait10><wait10><wait10><wait10>",
    "<wait10><wait10><wait10><wait10><wait10><wait10>",

    // Back to menu
    // Configure system
    "<enter><wait>",
    "1<enter><wait>",

    // Setup DHCP networking
    "1<enter><wait>",
    "2<enter><wait>",
    "7<enter><wait>",

    // Set root passwd
    "3<enter><wait>",
    "vagrant<enter><wait>",
    "vagrant<enter><wait>",
    "<enter><wait>",

    // Create vagrant user
    "2<enter><wait>",
    // Username
    "vagrant<enter><wait>",
    // Password
    "vagrant<enter><wait>",
    "vagrant<enter><wait>",
    // Give primary admin
    "y<enter><wait>",
    // Give sudo group without password
    "y<enter><wait>",
    "<enter><wait>",
    "n<enter><wait>",

    // Start SSH server
    "4<enter><wait>",

    // Return to main menu
    // Restart to get SSH started
    "8<enter><wait>",
    "3<enter><wait10>",
    "<enter><wait10>"
]
  boot_wait         = "5s"
  disk_size         = "${var.disk_size}"
  guest_os_type     = "OpenSolaris_64"
  headless          = "${var.headless}"
  iso_checksum      = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url           = "${var.mirror}/omnios-r151038.iso"
  output_directory  = "output-omnios-r151038-virtualbox"
  shutdown_command  = "sudo /usr/sbin/shutdown -i 5 -g 0 -y"
  ssh_password      = "vagrant"
  ssh_timeout       = "${var.ssh_timeout}"
  ssh_username      = "vagrant"
  vboxmanage        = [["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"], ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"]]
  vm_name           = "packer-omnios-r151038"
}

build {
  sources = ["source.virtualbox-iso.vbox"]

  provisioner "shell" {
    scripts = ["scripts/virtualbox.sh", "scripts/vagrant.sh"]
  }

  post-processor "vagrant" {
    compression_level = "${var.compression_level}"
    output            = "omnios-r151038.box"
  }
}
