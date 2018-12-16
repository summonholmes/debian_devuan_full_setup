# debian_full_setup
Sets up a minimal Debian system to a Debian system with my preferred defaults.

## Introduction
Rather than configure a system inch-by-inch, why not put everything into a few shell scripts and forget all your troubles?  This is what I prefer to do.

## Usage
These are what I use.  You'll likely need to get your hands dirty and change these where needed.  For instance, you should know your video driver in advance (intel, amd, nouveau, nvidia, etc).  Reboot after running each script in order.

### 1. At the tasksel prompt during install, uncheck everything.

### 2. Run the following commands

#### a. Configure
```
$ sudo apt-get install git -y
$ git clone https://github.com/summonholmes/debian_full_setup.git
$ cd debian_full_setup
$ sh 1_configure.sh
$ sudo reboot
```

#### b. Update
$ sh 2_update.sh
$ sudo reboot

#### c. Install All
$ sh 3_install_all.sh
$ sudo reboot
