1 #!/bin/bash
  2 start=`date +%s`
  3 cd /home/parallels/kernel/linux-source-4.19
  4    for ((var = 1; var <=16; var++)); do
  5       time make deb-pkg -j$var -s 2>/dev/null
  6       echo "sborka j$var"
  7       make clean
  8    done
  9 end=`date +%s`
 10 runtime=$((end-start))
 11 echo "Runtime was $runtime"