#include <stdio.h>
#include <stdlib.h>

int foo(){
       printf("foo called\n");
       return 2;
}
int bar(int x, int y) {
       printf("bar called:%d\n", x + y);
       return x+y;
}
int baz(int x){
       printf("baz called:%d\n", x);
       return x;
}
void printI(int i){
       printf("%d\n",i);
}
void printP(int* p){
       printf("%d\n",*p);
}
void alloc4(int **a,int v0,int v1,int v2,int v3){
       *a=(int*)malloc(sizeof(int)*4);
       printf("%d,%d,%d,%d\n",v0,v1,v2,v3);
       (*a)[0]=v0;
       (*a)[1]=v1;
       (*a)[2]=v2;
       (*a)[3]=v3;
       return;
}
int arg2(int p,int v0){
       printf("%d,%d\n",p,v0);
       if(p==0)
               return v0;
       return -1;
}
/* int main(){ */
/*     printf("%d\n",arg2(0,1)); */
/* } */
int arg3(int p,int v0,int v1){
        printf("%d,%d,%d\n",p,v0,v1);
       if(p==0)
               return v0;
       if(p==1)
               return v1;
       return -1;
}
int arg4(int p,int v0,int v1,int v2){
       if(p==0)
               return v0;
       if(p==1)
               return v1;
       if(p==2)
               return v2;
       return -1;
}
int arg5(int p,int v0,int v1,int v2,int v3){
       if(p==0)
               return v0;
       if(p==1)
               return v1;
       if(p==2)
               return v2;
       if(p==3)
               return v3;
       return -1;
}
void printVL(long *v,int l){
        for(int i=0;i<l;i++){
                printf("%d,",v[i]);
        }
        printf("\n");
}
void printVI(int *v,int l){
        for(int i=0;i<l;i++){
                printf("%d,",v[i]);
        }
        printf("\n");
}
void printVC(char *v,int l){
        for(int i=0;i<l;i++){
                printf("%d,",v[i]);
        }
        printf("\n");
}
void printA(int* p){
       printf("%x\n",p);
}
char* distance(int *p1,int *p2){
        char*ans=(char*)p2-(char*)p1;
        return ans;
}