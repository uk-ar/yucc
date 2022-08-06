#!/bin/bash
assert(){
    expected="$1"
    input="$2"

    ./9cc "$input" > tmp.s
    cc -o tmp tmp.s
    ./tmp
    actual="$?"

    if [ "$actual" = "$expected" ]; then
       echo "$input => $actual"
    else
       echo "$input => $expected expected, but got $actual"
       exit 1
    fi
}

assert 3 "1+2"
assert 0 0
assert 4 4
assert 42 42

assert 6 "1+2+3"
assert 2 "5 - 3"
assert 7 "1+2*3"
assert 9 "1*2+(3+4)"
assert 21 "5+20-4"
assert 10 "-10+20"

echo OK
