setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 1 -file "chip_mem.bit"
Program -p 1
quit
