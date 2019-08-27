#!/bin/bash
try() {
  expected="$1"
  input="$2"

  ./9cc "$input" > tmp.s
  gcc -o tmp tmp.s helper.o
  ./tmp
  actual="$?"

  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

try 0  "int main(){ 0; }"
try 101  "int main(){ 101; }"
try 42  "int main(){ 42; }"
try 0  "int main(){ 42+42-40-40-1-1-1-1; }"
try 0  "int main(){ 42 +42 -40  -40-     1 -1-1-1; }"
try 41  "int main(){  12 + 34 - 5 ; }"
try 2  "int main(){ 1+1; }"
try 47  "int main(){ 5+6*7; }"
try 15  "int main(){ 5*(9-6); }"
try 4  "int main(){ (3+5)/2; }"
try 13  "int main(){ 1   * ( 2* ( 2  +1+2*(6-1)       ))/(  6 /( 2 +1))  ; }"
try 4  "int main(){ -10+14; }"
try 4  "int main(){ +14-10; }"
try 3   "int main(){ -(-(-(-3))); }"
try 1  "int main(){ 1==1; }"
try 0  "int main(){ 2==12; }"
try 1  "int main(){ (1+1-2+1)==1; }"
try 1  "int main(){ 1==((1==2)+(-1==-1))==1; }"
try 1  "int main(){ 1!=100; }"
try 0  "int main(){ (1+2+3)!=(1*2*3); }"
try 1  "int main(){ (1+2+3+4)!=(1*2*3*4); }"
try 1  "int main(){ 2<3; }"
try 1  "int main(){ 3>1; }"
try 1  "int main(){ (3>1)==(1<3); }"
try 1  "int main(){ 1+2>1*2; }"
try 0  "int main(){ 1*2*3<1+2+3; }"
try 1  "int main(){ 2<=3; }"
try 1  "int main(){ 3>=1; }"
try 1  "int main(){ (3>=1)==(1<=3); }"
try 1  "int main(){ 1+2>=1*2; }"
try 1  "int main(){ 2*1*2*3/2<=1+2+3; }"
try 1  "int main(){ int a;a=1; }"
try 3  "int main(){int a;int b; a=1;b=2;a+b; }"
try 4  "int main(){int a;int b;int c; a=1;b=a;c=a*b+a;c+2; }"
try 3  "int main(){ int a;int b;int c;a=1;b=2;c=2*(a==b)+3*(a!=b);c; }"
try 3  "int main(){ int foo;int bar;int baz;foo=1;bar=2;baz=2*(foo==bar)+3*(foo!=bar);baz; }"
try 100  "int main(){ int OKTHISISAVERYLONGLONGLONGNAME_____10101010aaaaaaaa;OKTHISISAVERYLONGLONGLONGNAME_____10101010aaaaaaaa=100; }"
try 0  "int main(){int a;int b;int c; a=1;b=2;c=1+b+a/2;return 0; }"
try 3  "int main(){ int a;int b;int c;a=1;b=2;c=1+b+a/2;return c; }"
try 2  "int main(){int return0; return0= 1;return0=2;return return0; }"
try 3  "int main(){ if (2==1) return 2; return 3; }"
try 2  "int main(){ if (1==1) return 2; return 3; }"
try 100  "int main(){int a; a=10;if (a==10) a=a*10; return a; }"
try 11  "int main(){int a; a=11;if (a==10) a=a*10; return a; }"
try 4  "int main(){ int a;a=1;if (a==1) a=a+1;if (a==2) a=a+1;if (a==3) a=a+1;if (a==3) a=a+1; return a; }"
try 1  "int main(){ int a;if (1==1)a=1;else a=2; return a;  }"
try 3  "int main(){ int a;if (2==1)a=1;else if (1==2) a=2; else a=3; return a;  }"
try 3  "int main(){ int a;if (2==1)a=1;else if (1==2) a=2; else if (1==1) a=3;else a=4; return a;  }"
try 3  "int main(){ 9%6; }"
try 1  "int main(){int a;int count; a=27;count=0;while(a!=1)if (a%2==0) a=a/2;else a=3*a+1;return a; }"
try 55  "int main(){int a;int sum; sum=0;for (a=1;a<=10;a=a+1)sum=sum+a;return sum; }"
try 55  "int main(){int a;int sum; sum=0;a=1;for (;a<=10;a=a+1)sum=sum+a;return sum; }"
try 55  "int main(){int a;int sum; sum=0;a=1;for (;;a=a+1)if (a==55) return a;return 0; }"
try 55  "int main(){int a;int sum; sum=0;a=1;for (;;)if (a==55) return a;else a=a+1;return 0; }"
try 55  "int main(){int a;int sum; sum=0;a=1;for (;a<55;)if (0==55) return a;else a=a+1;return a; }"
try 0  "int main(){int a; a=0;int i;i=0;for (i=0;i<65536*16;i=i+1){a=0;}return 0;  }"
try 50  "int main(){int a;int i; a=0;i=0;for (i=0;i<10;i=i+1){a=a+1;a=a+1;a=a+1;a=a+1;a=a+1;}return a; }"
try 0  "int main(){int a;int i; a=0;i=0;{{{{{{{{0;}}}}}}}}return 0; }"
try 111  "int main(){int a;int count; a=27;count=0;while (a!=1){if (a%2==0){a=a/2;}else{a=3*a+1;}count=count+1;}return count; }"
try 42  "int main(){ int a;if (ret_42()==42) a=ret_42(); while (ret_42()!=42){ a=1;}return a; }"
try 21  "int main(){ int a;a=1; return mulab(21,a); }"
try 9 "int main(){ return (fib(32))%100;} int fib(int n){if (n<=2) return 1; return fib(n-1)+fib(n-2);}"
try 10 "int main(){ return sub(16,6);} int sub(int first,int second){return first-second;}"
try 0 "int main(){ int i;for (i=0;i<65536;i=i+1) sub(16,6); return 0;} int sub(int first,int second){return first-second;}"
try 42 "int main(){int x; int *y;x=42;y=&x;return *y;}"
try 42 "int main(){int x;int y;int *z;x=42;y=1111;z=&y+1;return *z;}"
try 3 "int main(){int x;int *y;y=&x;*y=3;return x;}"
try 42 "int main(){int x;int *y;int **z;  x=20; y=&x;*y=*y+20; z=&y;y=y; return **z+2;}"
echo OK