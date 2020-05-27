#!/bin/sh

# Require Homebrew

if test ! $(brew info docker-machine-driver-xhyve)
then
    # If this is kept, should replace the install with use of Brewfile
    #
    # Use the following command to install the latest version of the driver with Homebrew:
    brew install docker-machine-driver-xhyve

    # Once installed, enable root access for the docker-machine-driver-xhyve binary and add it to the default wheel group:
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    # Set the owner User ID (SUID) for the binary as follows:
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    # You can verify the existing version of the xhyve driver on your system using brew info as follows:
    brew info docker-machine-driver-xhyve
fi
