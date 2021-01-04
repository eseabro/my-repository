#include "lab2.h"
#include <math.h>

void print_tree(float arr[], int n) {
  // Prints a visual representation of a binary tree
  printf("\t");
  int height;
  height = (log(n))/(log(2));
  int count;
  count = 0;
  int i;

  for(i=0; i<=n-1;i++ ){

    int counter = 1;
    if(i==0){
      counter = 2;
    }
    while(counter<=height){
      printf("\t");
      counter++;
    }
    counter++;
    printf("%f",arr[i]);
    height--;
    int temp;
    temp = count;
    while(temp>0){
      printf("\t");
      i++;
      printf("%f",arr[i]);
      temp--;
    }
    count++;
    printf("\n");
  }
}

float get_parent_value(float arr[], int n, int index) {
  int parentnode;
  if((index>1) && (index<=n)){
  parentnode = (index/2 )-1;
  return arr[parentnode];
  }
  else{
    return -1;
  }
}


float get_left_value(float arr[], int n, int index) {
  if(index<((n/2))){
      return arr[(2*index)+1];
    }
    else{
      return -1;
      }
}


float get_right_value(float arr[], int n, int index) {
  if(index<((n/2)-1)){
      return arr[(2*index)+2];
    }
    else{
      return -1;
      }
return arr[2*index +2];
}


int is_max_heap(float arr[], int n) {
  int x;
  for(x = 0; x < (0.5*n); x++){
    if((arr[x] < arr[2*x+1]) ||(arr[x] < arr[2*x+2])){
      return 0;
    }
    return 1;
  }
}


void emmmax(float arr[], int n, int x){
    int left, big, right, length;
    left = 2*x+1;
    right = left +1;
    length= n ;
    big = x;
    if((left <= n) && (arr[x] < arr[left])){
	big = left;
      }
    if(( right <= n) &&( arr[big] < arr[right])){
	big = right;
      }
    if( big !=x){
	int z;
	z = arr[x];
	arr[x] = arr[big];
	arr[big] = z;
	emmmax(arr, n, big);
      }
      }
void heapify(float arr[], int n){
  int x;
  for(x = n; x >= 0; x--){
    emmmax(arr, n, x);
  }
}

void heapsort(float arr[], int n) {
int m,x,y,z; 

heapify(arr,n);

for(x=n-1;x>=0;x--){
      z = arr[0];
      arr[0] = arr[x];
      arr[x] = z;
      heapify(arr, n-1);
  }
}



float find_most_common_element(float arr[], int n) {
  int mc,mosty,y,x;
  mosty = 0;
  mc = 0;
  for(x=0;x<=n ;x++){
    int count = 1;
    for(y=x+1; y<n; y++){
      if(arr[x]==arr[y]){
	count++;
      }}
    if(count>mc){
      mc=count;
      mosty = x;
    }}

    return arr[mosty];
  }
