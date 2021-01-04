#include "lab4.h"
#include <math.h>


long int helper(char *filename){
    FILE* file = fopen(filename, "r");
    int line;
    long int size=0;
        while(feof(file)==0){
        line = fgetc(file);
        if (line == '\n'){
        size+=1;
        }
    }
    fclose(file);
    return size;
}

PersonalData** parse_data(char* fn){
    FILE * fly = fopen(fn,"r");

    PersonalData ** output = malloc(sizeof(PersonalData)*helper(fn));
    char ch[100000];
    long int size = 0;
    long int line;
    char* fout;
    char* token;
    int ridder = 0;
    long int index = 0;

    while((fout = fgets(ch, __INT_MAX__, fly))!=NULL){
        if (ridder ==0){
            ridder = 1;
            continue;
        }        
        if (fout == NULL){
            printf("fgets error\n");
        }
        if (ch==NULL){
            break;
        }
        PersonalData * person = malloc(sizeof(PersonalData));
        if (person == NULL) printf("malloc failed\n");

        person->SIN = atoi(strtok(ch,"\t"));
        person->gender = *strtok(NULL, "\t");
        strcpy(person->first_name, strtok(NULL, "\t"));
        strcpy(person->last_name, strtok(NULL, "\t"));
        strcpy(person->passport_num, strtok(NULL, "\t"));
        strcpy(person->bank_acc_num, strtok(NULL, "\t"));
        person->dob_year = atoi(strtok(NULL, "-"));
        person->dob_month = atoi(strtok(NULL, "-"));
        person->dob_day = atoi(strtok(NULL, "-"));
        output[index] = person;

        char ch[10000];
        index+=1;

    }


    fclose(fly);
    return output;
}


void counter_intelligence(char* load, char* update, char* validate, char* outfile){
    FILE * output = fopen(outfile, "w");
    PersonalData ** data_load = parse_data(load);
    PersonalData ** data_update = parse_data(update);
    PersonalData ** data_validate = parse_data(validate);
    HashTable *table = create_hash_table(0, 2);
    long int val = helper(load);
    for (int i= 0; i<val; i++){
        update_key(data_load[i], &table);
    }
    for (int j = 0; j<helper(update);j++){
        update_key(data_update[j], &table);
    }
    for (int k = 0; k<helper(validate); k++){
        INT_SIN SIN_1 = data_validate[k] -> SIN;
        PersonalData *pointer = lookup_key(SIN_1,table);
        if(pointer==NULL){
            fprintf(output, "%lu\n",(SIN_1));
        }
        else{
            int same = 1;
            if(strcmp(&(data_validate[k]->gender), &(pointer->gender))!=0){same = 0;}
            if(strcmp(data_validate[k]->first_name,pointer->first_name)!=0){same = 0;}
            if(strcmp(data_validate[k]->last_name,pointer->last_name)!=0){same = 0;}
            if(strcmp(data_validate[k]->passport_num,pointer->passport_num)!=0){same = 0;}
            if(strcmp(data_validate[k]->bank_acc_num,pointer->bank_acc_num)!=0){same = 0;}
            if(data_validate[k]->dob_year != pointer->dob_year){same = 0;}
            if(data_validate[k]->dob_month != pointer->dob_month){same = 0;}
            if(data_validate[k]->dob_day != pointer->dob_day){same = 0;}
            if (same == 0){
                fprintf(output, "%lu\n",(pointer->SIN));
            }
        }

    }
    delete_table(table);
    long int max1 = helper(load)-1;
    long int max_lines = max1;
    long int max2 = helper(update)-1;
    if (max2>max_lines) max_lines = max2;
    long int max3 = helper(validate)-1;
    if (max3>max_lines) max_lines = max3;
    while (max_lines>=0){
        if (max_lines<=max1){
                free(data_load[max_lines]);}
        if (max_lines<=max2){
                free(data_update[max_lines]);}
        if (max_lines<=max3){
                free(data_validate[max_lines]);}
        max_lines -= 1;
    }
    free(data_load);
    free(data_update);
    free(data_validate);
    fclose(output);
}
