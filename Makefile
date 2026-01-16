# Makefile --
# Copyright 2000, 2002, 2003 Free Software Foundation, Inc.
# Written by Stephane Carrez (stcarrez@nerim.fr)
#
# This file is part of GEL.
#
# GEL is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# GEL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GEL; see the file COPYING.  If not, write to
# the Free Software Foundation, 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#
# Host generic commands
RM=rm -f
#RM=del
MV=mv -f
INSTALL=cp

# 68k compiler and tools
DEVC_PREFIX=m68k-elf-
CC=$(DEVC_PREFIX)gcc
AR=$(DEVC_PREFIX)ar
AS=$(DEVC_PREFIX)as
SIZE=$(DEVC_PREFIX)size
OBJCOPY=$(DEVC_PREFIX)objcopy
OBJDUMP=$(DEVC_PREFIX)objdump

TARGET := lvgl_nkc
gccdir = /c/SysGCC/m68k-elf
COMMON_DIR = $(gccdir)/nkc_common/
ISEARCH = -I. -I$(COMMON_DIR)

LIBDIRS =  -L$(COMMON_DIR) #-L/c/src/LVGLNKC/lvgl
LIBS =  -llvgl

CFLAGS= -Os -m68000 -Wall -DCPU=2 -Wno-unused-variable -Wno-unused-but-set-variable -Wno-switch -fomit-frame-pointer -nostartfiles -std=gnu99 -ffunction-sections -fdata-sections -Dndrcomp -DUSE_JADOS $(ISEARCH)

ASFLAGS= #-DM68000

# Linker Flags
LDFLAGS= -T $(COMMON_DIR)rm_ram1.ld -Wl,-Map,$(OUTDIR)$(TARGET).map $(LIBDIRS)
LDLIBS= -llvgl 

# List of C sources
CSRCS=  lvgl_nkc.c

# Directory where the files are generated to (objects, list files, ...)
OUTDIR=./_out/
OBJPATH = ./obj

# List of objects
#OBJS=$(ASM_SRCS:.s=.o) $(CSRCS:.c=.o)
OBJS           = $(addprefix $(OBJPATH)/, $(addsuffix .o, $(notdir $(basename $(CSRCS)))))
#OBJS          += $(addprefix $(OBJPATH)/, $(addsuffix .o, $(notdir $(basename $(ASM_SRCS)))))

PROGS=$(OUTDIR)$(TARGET).elf
LIST=$(PROGS:.elf=.lst)

all:: createdirs $(PROGS) create_bin

clean_all: clean all

#$(OBJPATH)/%.o : %.c
#	$(CC) -flto $(CFLAGS) -c $< -o $@
#$(OBJPATH)/%.o : %.s
#	$(AS) $(ASFLAGS)  $< -o $@
$(eval USE_ENC:;@:)

createdirs:
	-@mkdir $(OUTDIR) 2>/dev/null || echo "" >/dev/null
	-@mkdir $(OBJPATH) 2>/dev/null || echo "" >/dev/null
$(PROGS):	$(OBJS) #llnkc.o
	$(CC) $(CFLAGS) -c -o $(OBJPATH)/crt0.o $(COMMON_DIR)crt0.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
	$(OBJDUMP) -S $(PROGS) > $(LIST)

create_bin:  
	$(OBJCOPY) --output-target=binary $(OUTDIR)$(TARGET).elf $(OUTDIR)$(TARGET).68k

define COMPILE_C_TEMPLATE
$(OBJPATH)/$(notdir $(basename $(1))).o : $(1)
	$(CC) -c $$(CFLAGS) $$< -o $$@
endef
$(foreach src, $(filter %.c, $(CSRCS)), $(eval $(call COMPILE_C_TEMPLATE, $(src))))

define COMPILE_ASM_TEMPLATE
$(OBJPATH)/$(notdir $(basename $(1))).o : $(1)
	$(AS) $$(ASFLAGS) $$< -o $$@
endef
$(foreach src, $(filter %.s, $(ASM_SRCS)), $(eval $(call COMPILE_ASM_TEMPLATE, $(src))))

clean:
	echo $(OBJS)
	$(RM) $(OBJS) $(OUTDIR)*.68k $(OUTDIR)*.lst $(OUTDIR)*.elf $(OUTDIR)*.map
	$(RM) $(OBJS) *.o

transfer:
#	C:/Users/USER/source/repos/NKCtransfer/NKCtransfer/bin/Debug/NKCtransfer COM3 2000000 00000 $(OUTDIR)$(TARGET).s19 START

# switch WiFi
	netsh wlan disconnect
	sleep 1
	netsh wlan connect name="TP-Link_Extender"

# send file to NKC
	tftp -i 192.168.0.101 PUT _out/lvgl_nkc.68k

# switch WiFi back
	netsh wlan disconnect
	sleep 1
	netsh wlan connect name="iJumeirah"

