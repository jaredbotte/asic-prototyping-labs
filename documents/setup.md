# Altera DE2-115 Setup on Ubuntu 20.04

## Overview
This setup document aims to guide you through the setup and initial configuration of an Ubuntu 20.04 system with the Altera DE2-115 development board. Setup on Windows will be similar, but with different steps to set environment variables.

## Download the necessary files
To begin, open a terminal window and download the ASIC prototyping tools and scripts:

```bash
cd ~
git clone git@github.com:jaredbotte/asic-prototyping-tools.git tools
```
### Set the `TOOLSDIR` environment variable
The provided scripts will attempt to look for each other as needed by referencing the `$TOOLSDIR` environment variable. It is important that this gets set and points to the right place.

```bash
vim ~/.bashrc
```
Note that this file starts with the name of your command line interpreter. For `zsh` use `zshrc`. For `csh` use `cshrc`.

Add the following line to the top of your `rc` file:

```bash
export TOOLSDIR=/home/<user>/tools
```
Where `<user>` is replaced by your username.


## Installation of Quartus Prime
### Download and run the installer
Go to [https://fpgasoftware.intel.com](https://fpgasoftware.intel.com/?edition=lite) and select the most recent "lite" version of Quartus Prime to download. Download the main installer under the "Combined Files" tab.

Extract the downloaded file by right clicking and hitting extract here, and open up a new terminal window. We'll use the terminal window to start the installation.

```bash
cd ~/Downloads
./setup.sh
```

If you are unable to find the file or it is not able to be run, first ensure that you are in the correct directory by running `ls` and looking for the `setup.sh` file. If necessary, `cd` into the folder containing the setup file. If you are in the correct folder and it's unable to run, try running `chmod +x setup.sh` before running `./setup.sh` again.

Follow the steps in the setup wizard and ensure that the installation directory is set to `/home/<user>/intelFPGA_lite/21.1` where `<user>` is your username and `21.1` is the version of Quartus Prime you are installing. Also ensure that you install all the tools and support equipment.

### Add Quartus Prime command line tools to your path variable
The provided scripts require access to the command line tools for Quartus programs, so we'll need to add them to our `PATH` variable. Once again, open your `rc` folder and add the following lines to the beginning:

```bash
export PATH=$PATH:/home/<user>/intelFPGA_lite/21.1/quartus/bin/
export PATH=$PATH:/home/<user>/intelFPGA_lite/21.1/questa_fse/bin/
```
Now for the changes to take effect, run `source ~/.bashrc`

## Obtain a QuestaSim license through Intel
You may or may not need to obtain a license through Intel for QuestaSim. I was unable to talk to the board until I did, and it will allow you to use `vsim` so it is nice to have either way. 

First, go to [Intel's Self-Service Licensing Center](https://licensing.intel.com) and create an account. Once you've recieved an email setting up your account, login to the website again.

On the menu bar below "Intel FPGA Self-Service Licensing Center", click the "Sign up for Evaluation or Free Licenses" tab. Select "Questa*-Intel FPGA Starter Edition SW-QUESTA". Select the edit icon under the "# of Seats" column and type in 1. Agree to the terms of use, and click "Get License"

Next you will be asked to either create a new computer, or add to an existing one. Click "+New Computer".

A prompt will now show up asking for information about your computer. First, give your computer a name. Then, select "FIXED" for the license type. 

Under the computer type tab, select "NIC ID". You'll need to obtain this ID from your computer to allow the license to work. It can be obtained by running `ip addr show` and looking for the first set of hexidecimal digits right after `link/ether`. Put this into the computer ID and click "Generate License". You should eventually recieve an email containing the license file.

Copy this license file into your `intelFPGA_lite/21.1/questa_fse` directory and once again open your `.rc` file. Add the following line:

```bash
export LM_LICENSE_FILE=/home/<user>/intelFPGA_lite/21.1/questa_fse/LR-*****_License.dat
```

The "****" should be replaced by the license number in the name of the file. Don't forget to run `source ~/.basrc` after adding these lines.

Setup should now be complete.
