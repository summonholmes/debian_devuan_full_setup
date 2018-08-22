# devuan_full_setup
A toast to my fellow neckbeards.  Cheers!

## Introduction
They say that the best sysadmins are lazy.  Wouldn't it be fantastic if everything "just worked" forever and happily ever after?  This repository is dedicated to my inner *nix sysadmin, and will hopefully provide knowledge to others who wish to grow their neckbeards long.

Rather than configure a system inch-by-inch, why not put everything into a few shell scripts and forget all your troubles?

Why am I doing this for Devuan?  I wanted to take a vacation away from Debian and see how I'd adapt in a similar non-systemd environment.  Non-systemd distributions have little room in the spotlight these days, yet remain excellent and in many ways, superior.  While I'm not here to bash systemd, it has introduced toxic attitudes, security vulnerabilities, and other crucial bugs due to its massive scope.  On the flipside and as of today, there is far less support for problems encountered in non-systemd distributions.  Therefore, I also did this for Debian.

However, if you put on your big boy pants and can solve challenging problems, why not give a distribution like Devuan a try?  There's also Slackware, Void, Gentoo, the BSDs, and a few more.  I find Devuan and Void to be the easiest choices in the non-systemd camp, and prefer Devuan for stability.

Anyway, please enjoy!

## Usage
These are what I use.  You'll need to get your hands dirty and change these where needed.  Reboot after running each script in order.  Just 1, reboot, 2, reboot, and 3, reboot.

## Notes
This provides bug fixes for wacom tablets and polkit which are not in the repositories.  I have reported both bugs and would like the changes implemented in Devuan, but am unsure of how to proceed any further.  Message me if you'd like to close these bugs, or if you can get me the details on how to do it myself: [#232: xserver-xorg-input-wacom: starting X session results in permanent black screen](https://bugs.devuan.org//cgi/bugreport.cgi?bug=232) & [#233: libpolkit-backend-1-0: switch dependency resolution to libpolkit-backend-1-0-elogind](https://bugs.devuan.org//cgi/bugreport.cgi?bug=233)
