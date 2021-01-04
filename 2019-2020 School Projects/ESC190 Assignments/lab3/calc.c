#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "calc.h"
#include "stack.h"




double compute_rpn(char* rpn){
    struct stack * tictac = create_stack();
    char things[7] = {'+','-','*','/','^','f','~'};
    char specials[7] = {'s','c','t','e','i','m','r'};
    int first = 0;
    int incr = 0;
    int legs = strlen(rpn);

    while (incr<legs){
        //printf("%f\n", answer_out);
        for (int j = 0; j<7; j++) {
            if((*rpn == things[j]) || (*rpn == specials[j])){
                  if (*rpn == '+'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, (num1+num2));
                    }
                  if (*rpn == '-'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, (num2-num1));
                      }
                  if (*rpn == '*'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, (num1*num2));
                      }
                  if (*rpn == '/'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, (num2/num1));
                    }
                  if (*rpn == 's'){
                      double num = pop(tictac);
                      push(tictac, (sin(num)));
                    }
                  if (*rpn == 'c'){
                      double num = pop(tictac);
                      push(tictac, (cos(num)));
                    }
                  if (*rpn == 't'){
                      double num = pop(tictac);
                      push(tictac, (tan(num)));
                      }
                  if (*rpn == 'e'){
                      double num = pop(tictac);
                      push(tictac, (exp(num)));
                      }
                  if (*rpn == 'i'){
                      double num = pop(tictac);
                      push(tictac, (1/(num)));
                      }
                  if (*rpn == 'm'){
                      double num = pop(tictac);
                      push(tictac, ((-1)*(num)));
                      }
                   if (*rpn == 'r'){
                      double num = pop(tictac);
                      push(tictac, (pow(num,0.5)));
                      }
                   if (*rpn == '^'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, (pow(num2,num1)));
                      }
                   if (*rpn == 'f'){
                      double num1 = pop(tictac);
                      double num2 = pop(tictac);
                      push(tictac, num1);
                      push(tictac,num2);
                      }

                  rpn ++;
                  incr++;
                  break;
                } 
            }

         if (*rpn == '0'||*rpn == '1'||*rpn == '2'||*rpn == '3'||*rpn == '4'||*rpn == '5'||*rpn == '6'||*rpn == '7'||*rpn == '8'||*rpn == '9'||*rpn=='.'){
            double x = atof(rpn);
            while(*rpn!= ' ' && (incr+1<legs)){
                rpn++;
                incr++;
            }
            
            if (incr+1==legs){
                break;
            }
            push(tictac,x);
            
        }
        if (*rpn == ' '){
             if (incr+1<legs){
                rpn++;
                incr++;
            }
        }
    }
    double answer_out = pop(tictac);
    delete_stack(tictac);
    return answer_out;
    
}

char* get_expressions(char* filename){
    FILE *flying;
    char grid[256][256];
    int  i = 0;
    char *out = malloc(sizeof(char)*256*256);
    flying = fopen(filename, "r");

    while (fgets(grid[i],256,flying)){
        int ind = strlen(grid[i]);
        int ind_1 = strlen(grid[i])-1;
        grid[i][ind] = '\0';
        grid[i][ind_1] = '\n';
        i++;
    }

    int g_inc = 0;

    for (int j = 0; grid[j][0] != '\0'; j++){
        for (int k = 0;grid[j][k]!='\0'; k++){
        out[g_inc] = grid[j][k];
	g_inc++;}}
    out[g_inc+1] = '\0';
    fclose(flying);
    return out;
    }

void process_expressions(char* expressions, char* filename){
    FILE *fly;
    fly = fopen(filename, "w");

    char *coin = strtok(expressions, "\n");

    while (coin!=NULL){

        double output_comp = compute_rpn(coin);
        fprintf(fly,"%g\n",output_comp);
        coin = strtok(NULL,"\n");
    }
    
    free(expressions);

    fclose(fly);
	
}
