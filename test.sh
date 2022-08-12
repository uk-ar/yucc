#!/bin/bash
assert(){
    expected="$1"
    input="$2"

    echo "$input" > tmp.cx
    ./9cc tmp.cx > tmp.s
    if [ "$?" -ne 0 ]; then
        echo "compile error"
        exit 1
    fi
    gcc -static -g -o tmp tmp.s test/common.o
    ./tmp
    actual="$?"

    if [ "$actual" = "$expected" ]; then
       echo "$input => $actual"
    else
       echo "$input => $expected expected, but got $actual"
       exit 1
    fi
}
assert 1 "main(){char a[2];*a=1;*(a+1)=2;printVC(a,2);return *a;}"

#assert 1 "int main(){int a;{int a;a=1;return a;}}"
#assert 3 "int main(){return ({3;});}"
#assert 3 "int main(){return ({int a;a=3;});}"
assert 3 "int main(){{return 3;}}"
assert 3 "int main(){//hello\nreturn 3;}"
assert 2 "int main(){/*hello\n commnent*/return 2;}"

assert 3 "int main(){printf(\"abc\");return 3;}"
assert 1 "int main(){printf(\"abc\");return 1;}"
assert 2 "int main(){printf(\"abc:%d\",1);return 2;}"
assert 1 "int main(){char x[3];x[0]=97;x[1]=98;x[2]=0;printVC(x,3);puts(x);return 1;}"
assert 3 "int main(){puts(\"abc\");return 3;}"
assert 2 "int main(){puts(\"abc\");puts(\"efg\");return 2;}"
assert 3 "int main(){char *x;x=\"abc\";return 3;}"
assert 1 "int main(){char *x;x=\"abc\";printVC(x,3);return 1;}"
assert 97 "int main(){char *x;x=\"abc\";return x[0];}"
assert 97 "int main(){char *x;x=\"abc\";return *x;}"
assert 3  "int main(){char *x;x=\"abc\";puts(x);return 3;}"
assert 3 "int main(){char x[3];x[0]=-1;x[1]=2;int y;y=4;return x[0]+y;}"

assert 3 "int a;int main(){a;return 3;}"
assert 3 "int a;int main(){a=1;return 3;}"
assert 1 "int a;int main(){a=1;printI(a);return a;}"
assert 1 "main(){char a[2];printA(a);printA(a+1);return distance(a,a+1);}"
assert 1 "char a[2];main(){printA(a);printA(a+1);return distance(a,a+1);}"
assert 1 "main(){char a[2];*a=1;*(a+1)=2;printVC(a,2);return *a;}"
assert 2 "main(){char a[2];*a=1;*(a+1)=2;return *(a+1);}"
assert 1 "main(){char a[2];*a=1;*(a+1)=2;return a[0];}"
assert 2 "main(){char a[2];*a=1;*(a+1)=2;return a[1];}"
assert 1 "main(){char a;char b;a=1;b=2;return a;}"
assert 2 "main(){char a;char b;a=1;b=2;return b;}"
# assert 8 "main(){int a;int b;a=1;b=2;printA(&a);printA(&b);return distance(&b,&a);}"
assert 1 "main(){char a;char b;a=1;b=2;printA(&a);printA(&b);return distance(&b,&a);}"

assert 1 "main(){arg2(1+2,3+4);return 1;}"
assert 2 "main(){arg3(1+2,3+4,2+3);return 2;}"
assert 1 "main(){int a[2];a[0]=1;return *a;}"
assert 2 "main(){int a[2];a[0]=2;return a[0];}"
assert 3 "main(){int a[2];*a=3;return a[0];}"
assert 4 "main(){int a[2];printA(a);printA(a+1);return distance(a,a+1);}"
assert 4 "int a[2];main(){printA(a);printA(a+1);return distance(a,a+1);}"

assert 3 "main(){int a[3];*a=1;*(a+1)=2;printI(*(a+1));printVI(a,3);int *p;p=a;return *p+*(p+1);}"
assert 3 "main(){int a[2];*a=1;*(a+1)=2;printI(*(a+1));printVI(a,2);int *p;p=a;return *p+*(p+1);}"
assert 1 "int fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(1);}"
assert 0 "main(){int a[2];*a=1;return 0;}"
assert 1 "main(){int a[2];*a=1;return *a;}"
assert 1 "main(){int a[2];*a=1;*(a+1)=1;printI(*a);return *a;}"

assert 1 "char x;int main(){return sizeof(x);}"
assert 1 "int main(){char x;return sizeof(x);}"
assert 8 "int main(){char x;char *y;return sizeof(y);}"
assert 1 "int main(){char x;char *y;return sizeof(*y);}"

assert 3 "int main(){int a[10];return 3;}"
assert 3 "int a;int main(){return 3;}"
assert 0 "int a;int main(){return a;}"
assert 3 "int a;int main(){a;return 3;}"
assert 3 "int a;int main(){a=1;return 3;}"
assert 1 "int a;int main(){a=1;return a;}"
assert 40 "main(){int a[10];return sizeof(a);}"
assert 1 "main(){int a[2];*a=1;return *a;}"
assert 2 "main(){int a[2];*(a+1)=2;return *(a+1);}"
assert 1 "main(){int a[2];*a=1;return a[0];}"
assert 2 "main(){int a[2];*(a+1)=2;return a[1];}"
assert 1 "main(){int a[2];*a=1;*(a+1)=2;return *a;}"
assert 2 "main(){int a[2];*a=1;*(a+1)=2;return *(a+1);}"
assert 1 "main(){int a[2];*a=1;*(a+1)=2;int *p;p=a;return *p;}"
assert 2 "main(){int a[2];*a=1;*(a+1)=2;int *p;p=a;return *(p+1);}"
assert 2 "main(){int a[2];*a=1;*(a+1)=2;int *p;p=a;return *(a+1);}"
assert 2 "main(){int a[2];*a=1;*(a+1)=2;int *p;p=a;printP(p+1);printP(a+1); return 2;}"
assert 3 "main(){int a[2];*a=1;*(a+1)=2;int *p;p=a;return *p+*(p+1);}"
assert 1 "main(){int a[2];*a=1;*(a+1)=2;return a[0];}"
assert 2 "main(){int a[2];*a=1;*(a+1)=2;return a[1];}"
#assert 1 "main(){int a[2];*a=1;*(a+1)=2;return 0[a];}"
#assert 2 "main(){int a[2];*a=1;*(a+1)=2;return 1[a];}"
#assert 4 "main(){int a[10];return sizeof(a[0]);}"

assert 4 "main(){int x;return sizeof(x);}"
assert 8 "main(){int x;int *y;return sizeof(y);}"
assert 4 "main(){int x;return sizeof(x+3);}"
assert 8 "main(){int x;int *y;return sizeof(y+3);}"
assert 4 "main(){int x;int *y;return sizeof(*y);}"
assert 4 "main(){int x;return sizeof(1);}"
assert 4 "main(){int x;return sizeof(sizeof(1));}"

assert 14 "main(){int a;int b;a=3;b=5*6-8;return a+b/2;}"
assert 2 "int main(){int *p;alloc4(&p,1,2,4,8);int *q;q=p+2;return 2;}"
assert 2 "int main(){int *p;alloc4(&p,1,2,4,8);int *q;q=p+2;printI(p);printI(q);return 2;}"
assert 4 "int main(){int *p;alloc4(&p,1,2,4,8);int *q;q=p+2;return *q;}"
assert 8 "int main(){int *p;alloc4(&p,1,2,4,8);int *q;q=p+3;return *q;}"
assert 2 "int main(){return foo();}"
assert 3 "int main(){return bar(1,2);}"
assert 1 "int main(){return arg2(0,1);}"
assert 2 "int main(){return arg3(1,1,2);}"
assert 4 "int main(){return arg4(2,1,2,4);}"
assert 8 "int main(){return arg5(3,1,2,4,8);}"
assert 2 "int main(){int *p;alloc4(&p,1,2,4,8);return 2;}"
assert 1 "int main(){int *p;alloc4(&p,1,2,4,8);return *p;}"
assert 3 "int main(){int x;int *y;y=&x;return 3;}"
assert 3 "int main(){int x;int *y;y=&x;*y=3;return x;}"
assert 4 "int main(){return 4;}"
assert 3 "int qux(int x){return 3;}int main(){return qux(3);}"
assert 3 "int main(){int a;a=3;return a;}"
assert 3 "main(){int x;int y;x=3;y=&x;return *y;}"
assert 3 "main(){int x;int y;int z;x=3;y=5;z=&y+8;return *z;}"
assert 3 "quxx(){return 3;}qux(){return quxx();}main(){return qux();}"
assert 1 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(1);}"
assert 1 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(2);}"
assert 2 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(3);}"
assert 3 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(4);}"
assert 5 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(5);}"
assert 8 "fib(int x){if(x<=1)return x;return fib(x-2)+fib(x-1);}main(){return fib(6);}"


assert 1 "main(){int f;f=1;return f;}"

#assert 3 "main(){return 1+2;}"
# assert 3 "qux(){return 3;}main(){return qux();}"
# assert 3 "qux(int x){return 3;}main(){return qux(3);}"
# assert 3 "qux(int x){return x;}main(){return qux(3);}"
# assert 6 "qux(int x,int y){return x+y;}main(){return qux(2+3,1);}"

# assert 2 "main(){return foo();}"
# assert 3 "main(){return bar(1,2);}"
# assert 5 "main(){return bar(1+2,2);}"
# assert 3 "main(){return baz(3);}"

assert 3 "main(){if(1==1){2;return 3;}}"
assert 4 "main(){if(1==1){2;3;}return 4;}"
assert 2 "main(){int a;for(a=1;a;a=a-1)return 2;}"
assert 0 "main(){int a;a=1;for(;a;)a=a-1;return a;}"
assert 1 "main(){if(1==1)return 1;}"
assert 2 "main(){if(1!=1)return 1;else return 2;}"
assert 2 "main(){int a;a=1;while(a)a=a-1;return 2;}"
assert 0 "main(){int a;a=1;while(a)a=a-1;return a;}"
assert 3 "main(){return 3;}"
assert 3 "main(){int foo;foo=3;return foo;}"
assert 5 "main(){int foo;foo=3;return 2+3;}"
assert 3 "main(){int foo;foo=3;2;return foo;}"
assert 3 "main(){int foo;foo=3;2+3;return foo;}"
assert 4 "main(){int foo;foo=3;2+3;return foo+1;}"
assert 6 "main(){int foo;int bar;foo=1;bar=2+3;return foo+bar;}"
assert 3 "main(){int a;return a=3;}"
assert 14 "main(){int a;int b;a=3;b=5*6-8;return a+b/2;}"
# assert 0 "main(){return 1>2;}"
# assert 3 "main(){return 1+2;}"
# assert 0 "main(){return 0;}"
# assert 4 "main(){return 4;}"
# assert 42 "main(){return 42;}"
# assert 6 "main(){return 1+2+3;}"
# assert 2 "main(){return 5 - 3;}"
# assert 7 "main(){return 1+2*3;}"
# assert 9 "main(){return 1*2+(3+4);}"
# assert 21 "main(){return 5+20-4;}"
# assert 10 "main(){return -10+20;}"
# assert 1 "main(){return 1<=2;}"
# assert 1 "main(){return 2==2;}"
# assert 0 "main(){return ;}"

echo OK
