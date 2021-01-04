#include "lab4.h"
#include <math.h>

INT_HASH trivial_hash(INT_SIN SIN, INT_HASH num_buckets) {
	/**
	   return the hash of SIN scaled to num_buckets
	   
	   Sample IO
	   printf(“%ld”, trivial_hash(10, 8)); 
	   
	   stdout:
	   2
	**/
	INT_HASH hash_val;
	hash_val = SIN % num_buckets;
	return hash_val;
}


INT_HASH pearson_hash(INT_SIN SIN, INT_HASH num_buckets) {
	/**
	   return the hash of SIN scaled to num_buckets

	   Sample IO
	   printf(“%ld”, pearson_hash(10, 8)) 
	   
	   stdout:
	   7

	**/
	//printf("hash was called\n");
	INT_HASH hash_val = 0;
	char stringy[256];
	sprintf(stringy, "%lu", SIN);
	int length = strlen(stringy);
	for(int i = 1; i<= length; i++){
		int ind = length - i;
		int aski = stringy[ind];
		int temp = hash_val ^ aski;
		hash_val = PEARSON_LOOKUP[temp];
	}
	int final = hash_val % num_buckets;
	return (final);
}


INT_HASH fibonacci_hash(INT_SIN SIN, INT_HASH num_buckets) {
	/**
	return the hash of SIN scaled to num_buckets

	Sample IO
	printf(“%ld”, fibonacci_hash(10, 8)) 
	printf(“%ld”, fibonacci_hash(999999999, 8)) 
	printf(“%ld”, fibonacci_hash(999999999, W)) 

	stdout:
	1
	0
	69107783
	**/
	INT_HASH hash_val;
	INT_HASH a = W/PHI;
	hash_val = ((a * SIN % W)/(W/num_buckets));
	return hash_val;
}

// int main(void){

// 	printf("%ld\n", pearson_hash(9, 8));
// }
