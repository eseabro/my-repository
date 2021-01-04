#include <stdio.h>
#include <stdlib.h>
#include "calc.h"
#include "stack.h"


int main(int argc, char* argv[]){
//	if(argc!=3){
//		printf("Missing input and output file names. Usage:\n./rpn input output\n");
//	}else{
//		char* expr = get_expressions(argv[1]);
//		process_expressions(expr, argv[2]);
//	}
//	
	char *stringy = "1 1 +";
	double comp = compute_rpn(stringy);
	printf("%f \n", comp);
	char *arra =  get_expressions("sample_in.txt");



	char *pointing = "emma_out.txt";

	process_expressions(arra, pointing);
	return 0;

}
