# SHELL := /bin/bash

MAKE = make
FIRMWAREDIR = firmware
ISEPRJDIR = ise

sw: 
	cd $(FIRMWAREDIR) && $(MAKE) firmware

sw_clean:
	cd $(FIRMWAREDIR) && $(MAKE) clean

hw:
	cd $(ISEPRJDIR) && $(MAKE) chip

hw_prog:
	cd $(ISEPRJDIR) && $(MAKE) firmware

hw_clean:
	cd $(ISEPRJDIR) && $(MAKE) clean

hw_sim:
	