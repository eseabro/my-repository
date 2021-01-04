#include "lab4.h"
#include <math.h>
#define NUM_HASH_FUNCS 3

HashTable *create_hash_table(int m, int mode){
/**
    create a new hash table of size 2^m and return the pointer to the newly created table.
    Fully initialize the state of the table.

    Sample IO
	0
    HashTable* table0 = create_hash_table(1, CLOSED_ADDRESSING);
    print_status(table0);
	
	2
	HashTable* table1 = create_hash_table(1, LINEAR_PROBING); 
	print_status(table1); 
	
	3
	HashTable* table2 = create_hash_table(1, CUCKOO); 
	print_status(table2); 

    Stdout:
    Table capacity:    		2 
    Table load:        		0 
    Table load factor: 		0.00
	Mode:			   		closed
	
	Table capacity:         2 
	Table load:             0 
	Table load factor:      0.00 
	Mode:                   linear

	Table capacity:         2 
	Table load:        		0 
	Table load factor:      0.00 
	Mode:                   cuckoo 	

**/

	hash_funcs[0] = trivial_hash;
    hash_funcs[1] = pearson_hash;
    hash_funcs[2] = fibonacci_hash;
	//2^m is the number of buckets needed
	int size = pow(2,m);
	struct HashTable * my_table; //here we're creating the hash table
	//the next two initialize it so that we return NULL if they give us NULL
	if((my_table = malloc(sizeof(HashTable)))==NULL){
		return NULL;
	}
	if((my_table->buckets = malloc(sizeof(Node)*(size)))==NULL){
		return NULL;
	}
	//This for loop initializes it so that every ccuurent bucket is NULL
	for (int i=0;i<size;i++){
		my_table -> buckets[i] = NULL;
	}
	//initializing table properties
	my_table -> num_buckets = pow(2,m);
	my_table -> num_keys = 0;
	my_table -> mode = mode;
	return my_table;
}

void update_without_resize(PersonalData * data, HashTable *table) {
	/**
	Insert/update the data corresponding to SIN of data.
	Update all book-keeping information.
	**/
	INT_HASH hash_index;
	int count = 1;
	int in_table = lookup_key(data->SIN, table) !=NULL; 
	if (table->mode == 0){
		//Closed addressing:linked lists
		hash_index = trivial_hash(data->SIN,table->num_buckets);
		Node *curr_node = table->buckets[hash_index];
		if (in_table){
			while(curr_node->value->SIN!=data->SIN){
				curr_node=curr_node->next;
				}
			curr_node->value = data;
		}
		else{
			if(table->buckets[hash_index]!=NULL){
				while(curr_node->next != NULL){
					curr_node=curr_node->next;
				}
			curr_node->next = malloc(sizeof(Node));
			//curr_node->next->value = malloc(sizeof(PersonalData));
			curr_node->next->value = data;
			curr_node->next->next = NULL;
			}
			else{
				table->buckets[hash_index] = malloc(sizeof(Node));
				//table->buckets[hash_index]->value = malloc(sizeof(PersonalData));
				table->buckets[hash_index]->value = data;
				table->buckets[hash_index]->next = NULL;
            }
			table->num_keys+= 1;
		}
        }
        if (table->mode == 1){
			hash_index = pearson_hash(data->SIN,table->num_buckets);
			INT_HASH o = hash_index;
		    if (in_table){
				while((table->buckets[hash_index]->value->SIN!=data->SIN)){
					count ++;
					int temp = table->num_buckets;
					hash_index = (o + count) % temp;
					if (count >= temp){
						break;
					}
				}
				(table->buckets[hash_index]->value) = data;
			}
			else{
			if(table->buckets[hash_index]==NULL){
				//printf("malloc issue\n");
				if (((table->buckets[hash_index]) = malloc(sizeof(PersonalData)))==NULL){printf("malloc failed\n");}
				//printf("Y\n");
				(table->buckets[hash_index]->value) = data;
				table->buckets[hash_index]->next = NULL;
			}
			else{
			while(table->buckets[hash_index]!=NULL){
				int temp = table->num_buckets;
				hash_index = (o + count) % temp;
				if (count >= temp){
					break;
				}
				count ++;
			}
			(table->buckets[hash_index]) = malloc(sizeof(PersonalData));
			(table->buckets[hash_index]->value) = data;
			table->buckets[hash_index]->next = NULL;
        }
		table->num_keys +=1;
		}
		}
        if (table->mode == 2){
			hash_index = fibonacci_hash(data->SIN,table->num_buckets);
			INT_HASH o = hash_index;
		    if (in_table){
				while((table->buckets[hash_index]->value->SIN!=data->SIN)){
					int p_x = pow(count,2);
					int temp = table ->num_buckets;
					hash_index = (o + p_x) % temp;
					if (p_x >= temp){
						break;
					}
					count++; 
				}
				(table->buckets[hash_index]->value) = data;
			}
			else{
			if(table->buckets[hash_index]==NULL){
				//printf("malloc issue\n");
				if (((table->buckets[hash_index]) = malloc(sizeof(PersonalData)))==NULL){printf("malloc failed\n");}
				//printf("Y\n");
				(table->buckets[hash_index]->value) = data;
				table->buckets[hash_index]->next = NULL;
			}
			else{
			while(table->buckets[hash_index]!=NULL){
				int p_x = pow(count,2);
				int temp = table ->num_buckets;
				hash_index = (o + p_x) % temp;
				if (p_x >= temp){
					break;
				}
				count++;
			}
			(table->buckets[hash_index]) = malloc(sizeof(PersonalData));
			(table->buckets[hash_index]->value) = data;
			table->buckets[hash_index]->next = NULL;
        }
		table->num_keys+=1;
		}
		}

		if (table->mode ==3){
			PersonalData *curr = data;
			while(1){
				INT_HASH trivial = hash_funcs[0](curr->SIN, table->num_buckets);
				INT_HASH pearson = hash_funcs[1](curr->SIN, table->num_buckets);
				INT_HASH fibonacci = hash_funcs[2](curr->SIN, table->num_buckets);
				
				if (table->buckets[trivial] ==NULL){
					(table->buckets[trivial]) = malloc(sizeof(PersonalData));
					(table->buckets[trivial]->value) = curr;
					table->buckets[trivial]->next = NULL;
					table->num_keys+=1;
					break;				
				}
				else if (table->buckets[pearson]==NULL){
					(table->buckets[pearson]) = malloc(sizeof(PersonalData));
					(table->buckets[pearson]->value) = curr;
					table->buckets[pearson]->next = NULL;
					table->num_keys+=1;
					break;
				}
				else if (table->buckets[fibonacci]==NULL){
					(table->buckets[fibonacci]) = malloc(sizeof(PersonalData));
					(table->buckets[fibonacci]->value) = curr;
					table->buckets[fibonacci]->next = NULL;
					table->num_keys +=1;
					break;
					
				}
				else{
					if (table->buckets[fibonacci]->value == data){
						free(curr);
						break;
					}
					else{
						PersonalData * temporary = curr;
						curr = table->buckets[fibonacci]->value;
						table->buckets[fibonacci]->value = temporary;
					}
				}
		}}
}

void update_key(PersonalData * data, HashTable **table){
	/** 
	Using update_without_resize and resize_table,
	update the hash table while ensuring the final table's 
	load factor does not exceed MAX_LOAD_FACTOR.
	
	Note that this function updates the pointer to the table with the
	return of resize_table and deletes the original table.
	
	Sample IO
	HashTable * table1 = create_hash_table(1, CLOSED_ADDRESSING);
	PersonalData data_a = {0, 'F', "Alice","Smith","XXX", "YYY", 1995, 12, 12};
	PersonalData data_b = {1, 'M', "Bob","Xu","XXX", "YYY", 1994, 12, 12};
	PersonalData data_c = {10, 'M', "Jeremy","Voyager","XXX", "YYY", 1994, 19, 12};
	update_key(&data_a, &table1);
	update_key(&data_b, &table1);
	update_key(&data_c, &table1);
	print_buckets(table1);
	
	PersonalData data1 = {2, 'F', "Alice", "Li", "XXX", "YYY", 1986, 1, 1}; 
	PersonalData data2 = {7, 'M', "Bob", "Kim", "XXX", "YYY", 1999, 5, 12}; 
	PersonalData data3 = {10, 'F', "Eve", "Pooh", "XXX", "YYY", 1993, 4, 20}; 
	HashTable* table2 = create_hash_table(3, LINEAR_PROBING); 
	update_key(&data1, table2); 
	update_key(&data2, table2); 
	update_key(&data3, table2); 
	print_buckets(table2);

	Stdout:
	Bucket 0:    SIN: 000000000     
	Bucket 1:    SIN: 000000001
	Bucket 2:    SIN: 000000010     
	Bucket 3:     
	Bucket 4:     
	Bucket 5:     
	Bucket 6:     
	Bucket 7:   
	
	Bucket   0:     
	Bucket   1:     SIN:    2 
	Bucket   2:     SIN:    7 
	Bucket   3:     
	Bucket   4:      
	Bucket   5:     SIN:    10 
	Bucket   6:     
	Bucket   7:     
	**/
	int cond = lookup_key(data->SIN, *table) == NULL;
	float ls = (*table)->num_keys + cond;
	float rs = (*table)->num_buckets * MAX_LOAD_FACTOR;
	if(ls>rs){
		*table = resize_table(*table);
	}
	update_without_resize(data,*table);
}

int delete_key(INT_SIN SIN, HashTable *table){
/**
	Delete key value, return 1 if successful,
	0 if key not in table - update book-keeping information.
	Ensure no memory leaks. Do not free memory that you did not allocate.

	Sample IO
	HashTable * table = create_hash_table(1, CLOSED_ADDRESSING);
	PersonalData data_a = {0, 'F', "Alice","Smith","XXX", "YYY", 1995, 12, 12};
	update_key(&data_a, table);
	delete_key(0, table);
	print_status(table);
	print_buckets(table);

	Stdout:
	Table capacity:    2 	
	Table load:        0 
	Table load factor: 0.00 
	Bucket 0: 
	Bucket 1: 
	Bucket 2:       
	Bucket 3:     
	Bucket 4:     
	Bucket 5:     
	Bucket 6:     
	Bucket 7:  
	
**/
	int index;
	int count = 0;
	int intable = lookup_key(SIN, table)!=NULL;
	if (table->mode == 0){
		if (intable){
		index = trivial_hash(SIN, table->num_buckets);
		Node *curr = table->buckets[index];
		while (curr->value->SIN != SIN){
			if (curr->next == NULL){
				return 0;
			}
			curr = curr->next;
		}
		while (curr->next != NULL){
			PersonalData *tempy = curr->next->value;
			curr->value = tempy;
			curr = curr->next;
		}
		curr->value = NULL;
		table-> num_keys --;
		return 1;
	}
	else{
		return 0;
	}
	}
	if (table->mode == 1){
		index = pearson_hash(SIN, table-> num_buckets);
		INT_HASH hash = index;
		if (table->buckets[index]==NULL){
			return 0;
		}
		while(table->buckets[index]->value->SIN!=SIN){
			count ++;
			if (((hash + count)%table->num_buckets)>sizeof(table->buckets[index])){
				return 0;
			}
			index = (hash + count)%table->num_buckets;
		}
		table->buckets[index] = NULL;
		table-> num_keys --;
		return 1;
	}
	if (table->mode ==2){
		index = fibonacci_hash(SIN,table->num_buckets);
		INT_HASH hash = index;
		if (table->buckets[index]==NULL){
			return 0;
		}
		while(table->buckets[index]->value->SIN!=SIN){
			count =pow(count,2);
			if (table->buckets[(hash + count)%table->num_buckets]==NULL){
				return 0;
			}
			index = (hash + count)%table->num_buckets;
		}
		table->buckets[index] = NULL;
		table-> num_keys --;
		return 1;
	}
	if (table->mode ==3 && intable){
		INT_HASH trivial = hash_funcs[0](SIN, table->num_buckets);
		INT_HASH pearson = hash_funcs[1](SIN, table->num_buckets);
		INT_HASH fibonacci = hash_funcs[2](SIN, table->num_buckets);		
		if (table->buckets[trivial] && table->buckets[trivial]->value->SIN==SIN){
			table->buckets[trivial]->value = NULL;
			return 1;
		}
		if (table->buckets[pearson] && table->buckets[pearson]->value->SIN==SIN){
			table->buckets[pearson]->value = NULL;
			return 1;
		}
		if (table->buckets[fibonacci] && table->buckets[fibonacci]->value->SIN==SIN){
			table->buckets[fibonacci]->value = NULL;
			return 1;
		}
	}
	if (intable == 0){
		return 0;
	}
}

PersonalData* lookup_key(INT_SIN SIN, HashTable *table){
	/** 
	return pointer to the PersonalData struct associated with SIN.
	return NULL if the SIN is not in table.
	
	Sample IO
	HashTable * table = create_hash_table(1, CLOSED_ADDRESSING);
	PersonalData data = {8, 'F', "Alice","Xu", "AB12345", "99999-999-999999999999", 1960, 31, 12};
	update_key(&data, table);
	print_personal_data(lookup_key(data.SIN, table));

	Stdout:
	SIN:        		8 
	Gender:     		F 
	Name:        		Xu, Alice 
	Passport #:    		AB12345 
	Bank account #:		99999-999-999999999999 
	Date of birth:		12-31-1960 
	**/

PersonalData * pointer = NULL;
        long int index;
        long int count = 0;
        INT_HASH i;
        if (table->mode ==0){
                index = trivial_hash(SIN, table->num_buckets);
                Node *curr = table->buckets[index];
                if (curr == NULL) {
                        return NULL;
                        }
                while (curr -> value->SIN != SIN){
                        if (curr->next == NULL) return NULL;
                        curr = curr->next;
                        }
                pointer = curr->value;
                return pointer;
        }
        if (table->mode == 1 || table->mode == 2){
                int pwr = table->mode == 2;
                long int increment = 0;
                index = hash_funcs[table->mode](SIN, table-> num_buckets);
                int True = 1;
                while (True){
                        long int val = index + increment*pow(increment, pwr);
                        val = val%table->num_buckets;
                        if (table->buckets[val] != NULL){
                                if (table->buckets[val]->value->SIN == SIN) return table->buckets[val]->value;
                        }
                        if (increment*pow(increment, pwr)>table->num_buckets) True  = 0;
                        increment= increment + 1;
                }
                return NULL;
		}
		if (table->mode ==3){
			INT_HASH trivial = hash_funcs[0](SIN, table->num_buckets);
			INT_HASH pearson = hash_funcs[1](SIN, table->num_buckets);
			INT_HASH fibonacci = hash_funcs[2](SIN, table->num_buckets);
			if (table->buckets[trivial]!=NULL){
				if	(table->buckets[trivial]->value->SIN == SIN){
					pointer = table->buckets[trivial]->value;
					return pointer;
				}
			}
			else if (table->buckets[pearson]!=NULL){
				if	(table->buckets[pearson]->value->SIN == SIN){
					pointer = table->buckets[pearson]->value;
					return pointer;
				}
			}
			else if (table->buckets[fibonacci]!=NULL){
				if	(table->buckets[fibonacci]->value->SIN == SIN){
					pointer = table->buckets[fibonacci]->value;
					return pointer;
				}
			}
			else{
				return NULL;
			}
		
	}
}

void delete_table(HashTable *table){
	/**
	Delete the table and ensure no memory leaks. Do NOT free memory that you 
	did not allocate.

	Sample IO
	HashTable * table = create_hash_table(1, CLOSED_ADDRESSING);
	delete_table(table);
	**/
	for (INT_HASH i = 0; i<(table->num_buckets); i++){
		if (table->buckets[i]){
		while(table->buckets[i]!=NULL){
			Node *freeit = table->buckets[i];
			table->buckets[i] = table->buckets[i]->next;
			free(freeit);
		}
		}
		free(table->buckets[i]);
	}

	free(table->buckets);
	free(table);
}

HashTable *resize_table(HashTable *table){
	/**
	Return a pointer to a new table with size m+1, where 
	the original table "table" has size 2^m.
	Delete the original table, ensure no memory leaks. 
	Update all book-keeping information.

	SampleIO
	HashTable * table = create_hash_table(2, CLOSED_ADDRESSING);
	table = resize_table(table);
	print_status(table);

	Stdout:
	Table capacity:    8 
	Table load:        0 
	Table load factor: 0.00 
	**/
	//the first three are the things they already had there idek if thats important
	//2^m is the number of buckets needed
	/**
	int size = table->num_buckets * 2;
	struct HashTable * my_table; //here we're creating the hash table
	//the next two initialize it so that we return NULL if they give us NULL
	my_table = malloc(sizeof(HashTable));
	if(my_table==NULL){
		return NULL;
	}
	if(my_table->buckets ==NULL){
		return NULL;
	}
	//This for loop initializes it so that every ccuurent bucket is NULL
	// for (int i=0;i<size;i++){
	// 	my_table -> buckets[i] = NULL;
	// }
	for (int j = 0; j<table->num_buckets; j++){
		if (table->buckets[j] !=NULL){
			Node *data = table->buckets[j];
			while(data!=NULL){
			update_without_resize(data->value, my_table);
			data=data->next;
			}
		}
	}
	
	//initializing table properties
	my_table -> num_buckets = size;
	my_table -> num_keys = table->num_keys;
	my_table -> mode = table->mode;
	delete_table(table);
	return my_table;
	**/

	int size = table->num_buckets * 2;
        struct HashTable * my_table;
        my_table = create_hash_table(log2f(size), table->mode);
        if((my_table ==NULL)){
                return NULL;
        }
        if((my_table->buckets == NULL)){
                return NULL;
        }

        for (int j = 0; j<table->num_buckets; j++){
                if (table->buckets[j] !=NULL){
                        Node * data = table->buckets[j];
                        while (data != NULL){
                                update_without_resize(data->value, my_table);
                                data = data->next;
                        }
                }
        }
        my_table -> num_buckets = size;
        my_table -> mode = table->mode;
        delete_table(table);
        return my_table;

}
