#include "lab2.h"
#include "test.h"
#include <stdio.h>

int main () {
  float arr[10] = {1,2,3,4,5,6,7,8,9,10};
  int oop = arr[0];

  int n = 10;
  int i;
//  int mce = find_most_common_element(arr, 10);
//  printf("%d \n",mce);
 // printf("%d \n", arr);
  heapsort(arr, 10);
//  int index = 6;
 // int haha = heapify(arr,10);
 for(i=0;i<n;i++){
  printf("%f",arr[i]);
  printf(" ");
 }
 printf("\n");
  //  test_get_parent_value(arr, 5, 2); yes
  //  test_get_left_value(); 		yes
    //test_get_right_value();		yes
  //  test_is_max_heap();		yes
   // test_heapify();
   // test_heapsort();
   // test_find_most_common_element();
}
