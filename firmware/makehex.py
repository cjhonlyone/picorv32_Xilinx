#!/usr/bin/env python3
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

from sys import argv

import os
if not os.path.exists('hex/'):
    os.mkdir('hex/')

binfile = argv[1]
ramsize = int(argv[2])
blockramsize = int(argv[3])

# binfile = 'firmware.bin' #argv[1]
# ramsize = 131072 #int(argv[2])
# blockramsize = 4096 #int(argv[3])

ramnum = int(ramsize/blockramsize)
ramidx = 0

with open(binfile, "rb") as f:
    bindata = f.read()

assert len(bindata) < 4*ramsize
assert len(bindata) % 4 == 0

f0 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
ramidx = ramidx + 1
f1 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
ramidx = ramidx + 1
f2 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
ramidx = ramidx + 1
f3 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
ramidx = ramidx + 1

blockramsize = blockramsize
ramsize = ramsize >> 2
for i in range(ramsize):
    if i < len(bindata) // 4:
        w = bindata[4*i : 4*i+4]
        f0.write("%02x\n" % (w[0]))
        f1.write("%02x\n" % (w[1]))
        f2.write("%02x\n" % (w[2]))
        f3.write("%02x\n" % (w[3]))
    else:
        f0.write("00\n")
        f1.write("00\n")
        f2.write("00\n")
        f3.write("00\n")

    if (i & (blockramsize - 1) == (blockramsize - 1) ):
        f0.close()
        f1.close()
        f2.close()
        f3.close()
        if (ramidx != ramnum) :
            f0 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
            ramidx = ramidx + 1
            f1 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
            ramidx = ramidx + 1
            f2 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
            ramidx = ramidx + 1
            f3 = open('hex/'+binfile[0:-1-3]+'ram%02d'%(ramidx)+'.hex', 'w')
            ramidx = ramidx + 1

f0 = open('hex/firmwarezero.hex', 'w')
for i in range(4096):
    f0.write("00\n")
f0.close()
