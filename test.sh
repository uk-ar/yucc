#!/bin/bash
assert(){
    expected="$1"
    input="$2"

    echo "$input" > tmp.cc
    ./stage1 tmp.cc > tmp.s
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
#sample
#assert 1 "int main(){char a[2];printA(a);printA(a+1);return distance(a,a+1);}"
# https://github.com/Alignof/cc_sakura/blob/master/test.sh
assert  0  "int main(){0;}"
assert  42 "int main(){42;}"

assert  21 "int main(){5+20-4;}"
assert  41 "int main(){12 + 34 - 5;}"

assert  47 "int main(){5+6*7;}"
assert  15 "int main(){5*(9-6);}"
assert  4  "int main(){(3+5)/2;}"
assert  17 "int main(){(-3+5)+15;}"
assert  21 "int main(){(-3*-2)+15;}"
assert  0 "int main(){(-3*-2)%(5*(9-6)/5);}"

assert  0  "int main(){5<4;}"
assert  1  "int main(){5>4;}"

assert  1  "int main(){12 == 12;}"
assert  0  "int main(){12 == 11;}"
assert  1  "int main(){12 != 13;}"
assert  0  "int main(){12 != 12;}"
assert  1  "int main(){!(12 == 11);}"
assert  1  "int main(){!(12 != 12);}"

assert  1  "int main(){1 && 1;}"
assert  0  "int main(){1 && 0;}"
assert  0  "int main(){0 || 0;}"
assert  1  "int main(){1 || 0;}"
assert  0  "int main(){!(1 && 1);}"
assert  1  "int main(){!(1 && 0);}"
assert  1  "int main(){!(0 || 0);}"
assert  0  "int main(){!(1 || 0);}"

assert  8  "int main(){5+3;6+2;}"
assert  5  "int main(){int a;int b;a=3;b=2;a+b;}"
assert  5  "int main(){int a_1;int b_2;a_1=3;b_2=2;a_1+b_2;}"
assert  5  "int main(){int a;a=8;a=a-3;a;}"
assert  25 "int main(){int a;int b;int c;int d; a=3;b=2;c=12;d=17;(d-c)*(a+b);}"

assert  5  "int main(){int abc; int def; abc=3;def=2;abc+def;}"
assert  6  "int main(){int kinako;int momone; kinako=3;momone=2;momone*kinako;}"

assert  5  "int main(){return 2+3;}"
assert  5  "int main(){int a;int b; a=13;b=8;return a-b;}"

assert  1  "int main(){int a; a=0;if(3>2) a=1;a;}"
assert  0  "int main(){int a; a=0;if(3<2) a=1;a;}"
assert  7  "int main(){int a; a=1+2;if(3>2) a=10-3;a;}"
assert  3  "int main(){int a; a=1+2;if(3<2) a=10-3;a;}"
assert  1  "int main(){int a; int b;int c; a=2;b=3;c=a+b;if(a<b) c=b-a;c;}"
assert  5  "int main(){int a; int b;int c; a=2;b=3;c=a+b;if(a>b) c=b-a;c;}"
assert  1  "int main(){int a=0; return !a;}"
assert  0  "int main(){int a=9; return !a;}"

assert  5  "int main(){int a; if(2>3) a=3-2; else a=2+3;a;}"
assert  1  "int main(){int a; if(2<3) a=3-2; else a=2+3;a;}"
assert  5  "int main(){int a; if(!(2<3)) a=3-2; else a=2+3;a;}"
assert  9  "int main(){int a; int b;int c; a=2;b=3;if(a>b) c=b-a/a; else c=a+b*b-a;c;}"
assert  2  "int main(){int a; int b;int c; a=2;b=3;if(a<b) c=b-a/a; else c=a+b*b-a;c;}"

assert  0  "int main(){int a; a=10;while(a>0) a=a-1;a;}"
assert  10 "int main(){int a; a=10;while(a<0) a=a-1;a;}"

assert  10 "int main(){int a; int i; a=0; for(i=0;i<10;i=i+1) a=a+1;a;}"
assert  64 "int main(){int a; int i; a=1; for(i=0;i<6;i=i+1) a=a*2;a;}"
assert  5  "int main(){int i; for(i=0;i<10;i++){if(i==5) break;} return i;}"
assert  5  "int main(){int i=0; while(i<10){if(i==5){break;}i++;} return i;}"
assert  50 "int main(){int i; int k; int l; int x=0; for(i=0;i<5;i++){for(k=0;k<10;k++){if(k==5){break;} x++;}for(l=0;l<10;l++){if(l==5){break;} x++;}} return x;}"
#assert  16 "int main(){int i; int x[10];for(i=0;i<10;i++){if(i == 5){x[i]=13;continue;}x[i]=i;} return x[5]+x[3];}" # why core dump?
#assert  16 "int main(){int i=-1; int x[10]; while(i<10){i++;if(i == 5){x[i]=13;continue;}x[i]=i;} return x[5]+x[3];}"
assert  50 "int main(){int i; int k; int x=0; for(i=0;i<10;i++){for(k=0;k<10;k++){if(k==5){break;} x++;}} return x;}"

assert  3  "int main(){int i=1; int x; switch(i){case 0:x=2;break; case 1:x=3;break; case 2:x=4;break; default:x=5;} return x;}"
assert  4  "int main(){int i=1; int x; switch(i){case 0:x=2;break; case 1:x=3; case 2:x=4;break; default:x=5;} return x;}"
assert  5  "int main(){int i=8; int x; switch(i){case 0:x=2;break; case 1:x=3;break; case 2:x=4;break; default:x=5;} return x;}"
assert  10 "int main(){int i; int x=1; for(i=0; i<4; i++){switch(i){case 0:x=2;break; case 1:x=3;break; case 2:x=4;break; default:x=10;}} return x;}"
assert  6  "int main(){int i;for(i=0;i<12;i++){while(i<0);while(i<0);if(i==6) break;}return i;}"


assert  2  "int main(){int a;int b;int c; a=2;b=3;c=5;if(a>b){a=a+b;a=a+c;} a;}"
assert  13 "int main(){int a;int b;int c; a=2;b=3;c=5;if(a<b){a=a+b;a=a+b+c;} a;}"
assert  2 "int main(){int x; int y=1; x =(y==1)?2:3; return x;}"
assert  3 "int main(){int x; int y=1; x =(y==5)?2:3; return x;}"
assert  4 "int main(){int x; int y=2; int z=5; x=(y==2) ? ((z==4)?8:4) : 3; return x;}"


assert  9  "int func_e(){return 9;} int main(){int b; b=func_e();b;}"
assert  9  "int func_e(){int a; a=9;return a;} int main(){int b; b=func_e();b;}"
assert  3  "int func_e(){int a; a=9;return a;} int main(){int b;int c; b=3;c=func_e();b;}"

assert  1  "int func_e(int a){return a;} int main(){int b;b=func_e(1);b;}"
assert  1  "int func_e(int a){return a;} int main(){int a;a=func_e(1);a;}"
assert  1  "int i=0; void increment(void){i++; return;} int main(){increment(); return i;}"


assert  5  "int add(int a,int b){return a+b;} int main(){add(2,3);}"
assert  5  "int add(int a,int b){return a+b;} int main(){int a;int b; a=2;b=3;add(a,b);}"
assert  9  "int add(int a,int b,int c){return a+b+c;} int main(){int a;int b;int c; a=2;b=3;c=4;add(a,b,c);}"

assert  55 "int fibo(int num){if(num==0){return 0;}if(num==1){return 1;} return fibo(num-1)+fibo(num-2);} int main(){fibo(10);}"

assert  3  "int main(){int x; int *y; y=&x;*y=3;return x;}"
assert  3  "int main(){int x; int *y; int **z; y=&x;z=&y;**z=3;return x;}"

assert  4  "int main(){int x; sizeof(x);}"
assert  8  "int main(){int *x; sizeof(x);}"
assert  8  "int main(){int x; sizeof(&x);}"
assert  4  "int main(){int x; sizeof(x+2);}"
assert  8  "int main(){int *x; sizeof(x+2);}"
assert  8  "int main(){int *x; sizeof((x));}"
assert  4  "int main(){char x[4]; sizeof((x));}"
assert  16 "int main(){int x[4]; sizeof((x));}"
#assert  64 "int main(){int x[4][4]; sizeof((x));}"
#assert  16 "int main(){int x[4][4]; sizeof((x[0]));}"
assert  1  "int main(){return sizeof(char);}"
assert  4  "int main(){return sizeof(int);}"
assert  8  "int main(){return sizeof(char *);}"
assert  8  "int main(){return sizeof(int **);}"
#assert  8  "int main(){return sizeof(__NULL);}"
#assert  1  "int main(){return sizeof(*__NULL);}"
#assert  6  'int main(){char x[]="hello"; return sizeof(x);}'
#assert  12 'int main(){int x[]={0,1,2}; return sizeof(x);}'
#assert  20 'int main(){int x[5]={0,1,2}; return sizeof(x);}'

assert  1  "int main(){int a[4]; *a=1; return *a;}"
assert  1  "int main(){int a[4]; *a=1; *a=1; return *a;}"
assert  2  "int main(){int a[4]; *a=1; *(a+1)=2; return *(a+1);}"
assert  1  "int main(){int a[4]; int *p; *a=1; return *a;}"
assert  1  "int main(){int a[4]; int *p; p=a; *p=1; return *a;}"
assert  3  "int main(){int a[4]; *a=1; *(a+1)=2; int *p; p=a; return *p + *(p+1);}"

assert  1  "int main(){int a[4]; a[0]=1; return a[0];}"
assert  3  "int main(){int a[4]; a[0]=1; a[1]=2; return a[0]+a[1];}"
assert  10  "int main(){int a[5]; int sum; int i; sum=0; i=0; while(i<5){a[i]=i; i=i+1;} i=0; while(i<5){sum=sum+a[i];i=i+1;} return sum;}"

assert  0  "int a; int main(){a;}"
assert  0  "int a[10]; int main(){a[5];}"
assert  2  "int a; int b; int main(){a=2;a;}"
assert  5  "int a; int b; int main(){a=2;b=3;a+b;}"
assert  5  "int a; int b; int main(){int a;a=2;b=3;a+b;}"

assert  2  "int main(){char a;a=2;return a;}"
assert  25 "int main(){char a;char b;char c;char d; a=3;b=2;c=12;d=17;(d-c)*(a+b);}"
assert  9  "int main(){char a;char b;char c; a=2;b=3;if(a>b) c=b-a/a; else c=a+b*b-a;c;}"
assert  3  "int main(){char x; char *y; char **z; y=&x;z=&y;**z=3;return x;}"
#assert  4  "int main(){char x; sizeof(x+2);}"//cast
assert  3  "int main(){char a[4]; *a=1; *(a+1)=2; char *p; p=a; return *p + *(p+1);}"

assert  101  'int main(){char *x; x="hello"; x[1];}'
assert  108  'int main(){char *x; x="hello"; *(x+2);}'

#assert  5  'int main(){int i; int x[10];/* set counter */ for(i=0;i<10;i=i+1) x[i]=i; return x[5];}'
assert  5  "int main(){int a=8;a=a-3;a;}"
assert  108 'int main(){char *x="hello"; *(x+2);}'
#assert  108 'int main(){char x[]="hello"; *(x+2);}'
#assert  108 'int main(){char x[6]="hello"; *(x+2);}'
#assert  4 'int main(){int a[]={0,1,2,3,4}; return a[4];}'
#assert  4 'int main(){int a[5]={0,1,2,3,4}; return a[4];}'
#assert  0 'int main(){int a[5]={0,1,2}; return a[4];}'
#assert  4 'int add(int x,int y){return x+y;} int main(){int a[5]={0,1,2,add(1,3),4}; return a[3];}'
#assert  72 'int main(){int i; int k; int x[10][10]; for(i=1;i<=9;i++){ for(k=1;k<=9;k++){ x[k][i]=i*k; }} return x[8][9];}'
#assert  72 'int x[10][10]; int main(){int i; int k; for(i=1;i<=9;i++){ for(k=1;k<=9;k++){ x[k][i]=i*k; }} return x[8][9];}'
#assert  5 "int main(){int x[2][3]; int *y; x[1][2]=5; y=x[1]; y[2];}"
#assert  8 "int main(){int x[2][3]; int *y; int *z; x[1][1]=5; x[1][2]=3; y=x[1]; z=y; return *(y+1) + z[2];}"
#assert  8 "int main(){int x[2][3][4]; x[1][1][1]=5; x[1][2][3]=3; return x[1][1][1] + x[1][2][3];}"

assert  5  "int a=8; int main(){a=a-3;a;}"
assert  108 'char *x="hello"; int main(){*(x+2);}'
assert  108 'char x[]="hello"; int main(){*(x+2);}'
assert  108 'char x[6]="hello"; int main(){*(x+2);}'
assert  4   'int a[]={0,1,2,3,4}; int main(){return a[4];}'
assert  4   'int a[5]={0,1,2,3,4}; int main(){return a[4];}'
#assert  0   'int a[5]={0,1,2}; int main(){return a[4];}'
#assert  97  'char reg_ax[8][4] = {"al", "al", "al", "eax","rax","rax","rax","eax"};int main(){return reg_ax[1][0];}'


assert  7  'int main(){int x=3; int a=x++; return a+x;}'
assert  8  'int main(){int x=3; int a=++x; return a+x;}'
assert  5  'int main(){int x=3; int a=x--; return a+x;}'
assert  4  'int main(){int x=3; int a=--x; return a+x;}'
#assert  0  'int main(){int x[4]={0,1,2,3}; int *p; int *q; p=x; q=p++; return *q;}'
#assert  1  'int main(){int x[4]={0,1,2,3}; int *p; int *q; p=x; q=++p; return *q;}'
#assert  12 'int global = 7; int *f(int *x){*x += 1; global += 1; return x;} int main(){int x=3; x = (*f(&x))++; return global + x;}'

assert  7  'int main(){int x=4; int y=3; x+=y; return x;}'
assert  1  'int main(){int x=4; int y=3; x-=y; return x;}'
assert  9  'int main(){int x=3; int y=3; x*=y; return x;}'
assert  4  'int main(){int x=12; int y=3; x/=y; return x;}'
#assert  6  'int main(){int i; int x[4]={0,1,2,3}; int y[4]={0,1,2,3}; int *p=x; int *q=y; for(i=0;i<4;i++){*(p++)+=*(q++);} return x[3];}'
#assert  21 'int global = 7; int *f(int *x){*x += 4; global += 3; return x;} int main(){int x=3; *f(&x) += 4; return global + x;}'

assert  97 "int main(){return 'a';}"
assert  0  "int main(){return '\0';}"
assert  9  "int main(){return '\t';}"
assert  10 "int main(){return '\n';}"
#assert  92 "int main(){return '\\\\';}"
assert  1  "int main(){int flag; char *hello=\"hello\"; if(hello[1] == 'e') flag=1; else flag=0; return flag;}"

assert  5  "struct test{int a; int b;}; int main(){struct test x; x.a=2; x.b=3; return x.a + x.b;}"
assert  5  "struct test{char a; int b;}; int main(){struct test x; x.a=2; x.b=3; return x.a + x.b;}"
assert  5  "struct test{int a; int b;}; int main(){struct test x; struct test *y; y=&x; y->a=2; y->b=3; return y->a + y->b;}"
assert  5  "struct test{int a; int b;}; int main(){struct test x; struct test *y; struct test **z; y=&x; z=&y; (*z)->a=2; (*z)->b=3; return (*z)->a + (*z)->b;}"
#assert  10 "struct test{int a; int b; int c[10];}; int main(){struct test x; x.a=1; x.b=2; x.c[0]=3; x.c[2]=4; return x.a + x.b + x.c[0] + x.c[2];}"
assert  9  "struct rgb{int r; int g; int b;}; struct point{int x; int y; struct rgb col;}; int main(){struct point test; test.col.r=2; test.col.g=3; test.col.b=4; return test.col.r + test.col.g + test.col.b;}"
#assert  9  "struct rgb{int r; int g; int b;}; struct point{int x; int y; struct rgb *col;}; int main(){struct point test; test.col->r=2; test.col->g=3; test.col->b=4; return test.col->r + test.col->g + test.col->b;}"
#assert  9  "struct rgb{int r; int g; int b;}; struct point{int x; int y; struct rgb *col;}; int main(){struct point test; struct point *ptr; ptr=&test; ptr->col->r=2; ptr->col->g=3; ptr->col->b=4; return ptr->col->r + ptr->col->g + ptr->col->b;}"

assert  2  "enum Color{Red, Green, Blue}; int main(){return Blue;}"
assert  2  "enum Color{Red, Green, Blue}; int main(){enum Color test; test=Blue; return test;}"
#assert  17 "enum Color{Red, Green, Blue}; int main(){int Blue = 17; return Blue;}"
#assert  2  "int main(){enum Color{Red, Green, Blue}; return Blue;}"
#assert  2  "int main(){enum Color{Red, Green, Blue}; enum Color test; test=Blue; return test;}"
#assert  1  "int main(){enum Color{Red, Green, Blue}; enum Color test=Green; int result=13; switch(test){case Red:result=0;break; case Green:result=1;break; case Blue:result=2;break;} return result;}"
#assert  2  "int main(){enum Color{Red, Green, Blue} test=Blue; int result=13; switch(test){case Red:result=0;break; case Green:result=1;break; case Blue:result=2;break;} return result;}"

assert  3  "int main(){int x=0; int y=1; int z=2; if(x == 0){int y=4;}else{int y=11;} return y+z;}"
assert  3  "int main(){int x=0; int z=2; if(x == 0){int y=4;}else{int y=11;} int y=1; return y+z;}"
assert  7  "int main(){int x=0; int z=2; if(x == 0){if(z==2){int x=2; int y=4; z=x+y;}} int y=1; return y+z;}"

assert  97 "typedef char moji; int main(void){moji head='a'; return head;}"
assert  1  "typedef char moji; int main(void){moji head='a'; return sizeof(moji);}"
assert  7  "typedef int suuji; suuji main(void){suuji x = 3; return sizeof(suuji) + x;}"
#assert  3  "typedef int suuji; typedef int* int_ptr; suuji main(void){suuji x=3; int_ptr ptr=&x; return *ptr;}"
#assert  3  "typedef int suuji; typedef int* int_ptr; typedef int** int_ptr_ptr; suuji main(void){suuji x=3; int_ptr y=&x; int_ptr_ptr z=&y; return **z;}"
#assert  2  "typedef enum Color{Red, Green, Blue}Color; int main(){Color test; test=Blue; return test;}"
#assert  2  "typedef enum Color Color; Color{Red, Green, Blue}; int main(){Color test; test=Blue; return test;}"
#assert  1  "typedef enum{RED,GREEN,BLUE,}COLOR; int main(void){COLOR c = GREEN; return GREEN;}"
assert  5  "typedef struct test{int a; int b;}Test; int main(){Test x; x.a=2; x.b=3; return x.a + x.b;}"
#assert  5  "typedef struct test Test; Test{int a; int b;}; int main(){Test x; x.a=2; x.b=3; return x.a + x.b;}"
assert  4  "typedef struct test Test; struct test{int r; int g; int b; Test *next;}; int main(void){Test x; Test y; x.r=1; x.g=2; x.b=3; y.r=4; y.g=5; y.b=6; x.next = &y; return x.next->r;}"

assert  1  "int main(){_Bool x = 3; return sizeof(x);}"
assert  1  "int main(){_Bool x = 3; return x;}"
assert  1  "int main(){_Bool x = 3; x++; return x;}"
assert  0  "int main(){_Bool x = 3; x--; return x;}"
assert  1  "int main(){_Bool x = 3; x+=3; return x;}"
assert  0  "int main(){_Bool x = 3; x-=1; return x;}"
assert  1  "int main(){_Bool x = 3; x-=4; return x;}"
assert  4  "int main(){_Bool x = 3; return x+3;}"

assert  5  "int main(){int x=5; ; return x;}"
assert  10 "int main(){int i=0; int x=0; for(;i<10;i++){x++;}return x ;}"


assert  4 "int main(){return _Alignof(int); }"
assert  4 "int main(){int x; return _Alignof(x); }"
#assert  4 "int main(){int  a[456]; return _Alignof(a); }"
#assert  1 "int main(){char a[456]; return _Alignof(a); }"
#assert  4 "int main(){struct rgb{int r; int g; int b;}; struct rgb x; return _Alignof(x); }"
assert  8 "struct rgb{int r; int g; int b;}; struct point{int x; int y; struct rgb *col;}; int main(){struct point x; return _Alignof(x); }"
assert  8 "struct rgb{int r; int g; int b;}; struct point{int x; int y; struct rgb *col;}; int main(){struct point x; return _Alignof(struct point); }"

#assert  8 "int main(){return sizeof(size_t);}"
#assert  8 "int main(){size_t isize = 8; return sizeof(isize);}"

assert  3 "int main(){const int x = 3; return x;}"
#assert  3 'int main(){const int x[4]={0,1,2,3}; return x[1] + x[2];}'
assert  3 "const int x = 3; int main(){return x;}"
assert  3 'const int x[4]={0,1,2,3}; int main(){return x[1] + x[2];}'
assert  3 "int main(){int x=3; const int *y=&x; return *y;}"
#assert  3 "int main(){int x=3; int * const y=&x; return *y;}"
#assert  97 'const char reg_ax[8][4] = {"al", "al", "al", "eax","rax","rax","rax","eax"};int main(){return reg_ax[1][0];}'

echo OK
