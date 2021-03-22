import os
import strutils
import macros

const 
  maxInput = 30

type FibCounts = array[maxInput, int]

proc fib(i: int):int =
  case i
  of 0: return 0
  of 1: return 1
  else:
    return fib(i-1) + fib(i-2)

macro myFibMacro(arg: static[int]): untyped =
  let v = fib(arg)
  result = quote do:
    `v`

macro buildCache() : untyped =
  var fibCounts : FibCounts
  for i in low(fibCounts)..high(fibCounts):
    echo "[-] Precomputing at compile time:", i
    fibCounts[i] = fib(i)
  result = quote do:
    `fibCounts`

proc main =
  echo "[-] As a first proof, fib(16) = ", myFibMacro(16)
  if paramCount() == 1:
    var input = paramStr(1).parseInt
    if input < maxInput:
      # Use compile-time cache
      echo buildCache()[input]
    else:
      # Compute at run-time
      echo fib(input)
  else:
    echo "[-] Usage: fibie <number>"

main()
