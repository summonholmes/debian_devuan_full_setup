# debian_full_setup
Sets up a minimal Debian system to a Debian system with my preferred defaults.

## Introduction
Rather than configure a system inch-by-inch, why not put everything into a few shell scripts and forget all your troubles?  This is what I prefer to do.  Doing a project such as this is great for practicing regular expressions with awk and sed, using wget and apt to install packages without a web browser, replacing config files with others from another git repository, automating system administration, and much more.

I've been using Debian Stable with KDE and backports for several years now, and expect my computer to never surprise me with noticable updates.  Instead, my machine is like a toaster that I have to clean every 2-3 years.

## Usage
These are what I use.  You'll likely need to get your hands dirty and change these where needed.  For instance, you should know your video driver in advance (intel, amd, nouveau, nvidia, etc).  Reboot after running each script in order.

## Todo
Add KDE config files to the 

### 1. At the tasksel prompt during install, uncheck everything.

### 2. Run the following commands

#### a. Configure
```
$ sudo apt-get install git -y
$ git clone https://github.com/summonholmes/debian_full_setup.git
$ cd debian_full_setup
$ sudo sh -c "./1_configure.sh"
$ sudo reboot
```

#### b. Update
```
$ sudo sh -c "./2_update.sh"
$ sudo reboot
```

#### c. Install All
```
$ sudo sh -c "./3_install_all.sh"
$ sudo reboot
```
