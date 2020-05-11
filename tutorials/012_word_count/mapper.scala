#!/usr/bin/env scala
for (line <- io.Source.stdin.getLines) {
  line.split(" ").foreach(x=>println(s"$x\t1"))
}
