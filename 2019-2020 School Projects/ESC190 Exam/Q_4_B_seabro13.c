#include <stdio.h>
#include <stdlib.h>

#define NUM_STORES 100
#define NUM_GELS 10


struct Gelato{
    char * flavour;
    int popularity;
    int quantity;
};

struct AlgosStore{
    char * man_name;
    int num_staff;
    struct Gelato gel_arr[10];
};

struct AlgosGelatos{
    char * CEO;
    struct AlgosStore store_arr[100];
};

void print_stores(struct AlgosGelatos * Algo){
    //prints all the members of each algosgelatos
    for (int i =0; i<NUM_STORES; i++){
        struct AlgosStore curr_store =  Algo->store_arr[i];
        printf("Manager is %s\n", *curr_store.man_name);
        printf("Number of staff members is %i\n", curr_store.num_staff);
        for(int j =0; j< NUM_GELS; j++){
            struct Gelato curr_gel = curr_store.gel_arr[j];
            printf("\t Flavour is %s", *curr_gel.flavour);
            printf("\t Popularity is %i", curr_gel.popularity);
            printf("\t Quantity is %i", curr_gel.quantity);

        }
    }
}

void update_gelatos(struct AlgosGelatos * Algo, struct Gelato * in_gel_arr){
    // int num_stores = (sizeof(Algo->store_arr)/sizeof(struct AlgosStore));
    int num_per_store = in_gel_arr->quantity / 100;
    int count = 0;
    struct Gelato new_gel[10];
    for (int i=0; i< NUM_STORES; i++){
        for (int j =0; j<NUM_GELS; j++){
            new_gel[j] = Algo->store_arr[i].gel_arr[j];
        }
        int gel_c = NUM_GELS;
        for (int k =0; k<num_per_store;k++){
            new_gel[gel_c] = in_gel_arr[count];
            gel_c++;
            count++;
        }
        Algo->store_arr[i].gel_arr = new_gel;
    }
}


int main(){
    // Run
}