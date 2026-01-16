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
MV=mv -f
INSTALL=cp

# 68k compiler and tools
DEVC_PREFIX=m68k-elf-
CC=$(DEVC_PREFIX)gcc
AR=$(DEVC_PREFIX)ar
OBJCOPY=$(DEVC_PREFIX)objcopy
OBJDUMP=$(DEVC_PREFIX)objdump

TARGET := lvgl.a
gccdir = /c/SysGCC/m68k-elf/
COMMON_DIR = $(gccdir)nkc_common/  
ISEARCH = -I. -Ilvgl -Ilvgl/src

LIB = liblvgl.a

CFLAGS= -Os -m68000 -std=gnu99 -DCPU=2 -Wall -Wno-unused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wno-switch -fomit-frame-pointer -nostartfiles -fno-delete-null-pointer-checks -ffunction-sections -fdata-sections $(ISEARCH) 

LVGL_SRCS := $(shell find ./src -name '*.c')
LVGL_OBJS := $(LVGL_SRCS:.c=.o)

# =========================
# Build rules
# =========================
all: $(LIB)

$(LIB): $(LVGL_OBJS)
	$(AR) rcs $@ $^

src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm $(LVGL_OBJS) $(LIB)

install: $(LIB)
	$(INSTALL) $(LIB) $(COMMON_DIR)

