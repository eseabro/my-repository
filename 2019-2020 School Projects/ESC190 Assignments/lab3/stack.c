#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

struct stack* create_stack(void){
	
	struct stack* pt = (struct stack*)malloc(sizeof(struct stack));
	pt -> top = NULL;
	return pt;
}

void delete_stack(struct stack*s){
	

	if(s->top == NULL){
	  free(s);
	}
	else{
	  while(s->top != NULL && s->size!= 0){
	    struct stack_entry *temp = s->top->next;
	    free(s->top);
	    s->top = temp;
	  }
	  free(s);
	}
}

double pop(struct stack* s){
	
	if((s->size==0)||(s==NULL)){
	  return 0;
	}
	else{
	  double final = s->top->value;
	  struct stack_entry *temp = s->top->next;
	  free(s->top);
	  s->top = temp;
	  (s->size) --;
	  return final;
	}
	
}

int push(struct stack* s, double e){
	
	struct stack_entry* new_top = malloc(sizeof(struct stack_entry));
	if(new_top == NULL){
		return -1;
		}
	(s->size) ++;
	new_top->value = e;
	if(s->size ==0){
		s->top = new_top;
	}
	else{
		new_top ->next = s->top;
		s->top = new_top;
	}
	return 0;
}
