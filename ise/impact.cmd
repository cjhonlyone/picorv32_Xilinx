setMode -bs
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 2 -file "chip_mem.bit"
Program -p 2
quit
