#include <stdio.h>
#include <stdlib.h>
#define MAX 5

struct queue{
    int capacity; //capacity of the queue
	int * array; //array of integer values
	int size; //current size of queue
    int head; //index of head
    int tail; // index
};

struct queue * create_queue(int a_size){
    struct queue * my_queue = malloc(sizeof(struct queue));
    my_queue->capacity = a_size;
    my_queue->array = malloc(sizeof(int)*a_size);
    for (int i=0; i<a_size; i++){
        my_queue->array[i]=0;
    }
    my_queue->head = 0;
    my_queue->tail = 0;
    my_queue->size = 0;
    return my_queue;
}


int dequeue(struct queue * Q){
    // Dequeue from the head
    if (Q->size ==0){
        printf("Queue Underflow");
    }
    int val = Q->array[Q->head];
    Q->array[Q->head]=0;
    Q->head = (Q->head +1)% Q->capacity;
    Q->size -=1;
    return val;
}

void delete_queue(struct queue * Q){
    // Delete the queue
    free(Q->array);
    free(Q);
}

void enqueue(struct queue * Q, int adder){
    //Enqueue on the tail
    if ((Q->tail!=Q->head)||((Q->tail == 0)&&(Q->head==0)&&(Q->array[Q->head]==0))){
        Q->array[Q->tail]=adder;
        Q->tail =(Q->tail+1)%(Q->capacity);
        Q->size+=1;
    }
    else{
        //If queue is full
        struct queue * new_Q = create_queue(Q->capacity*2);
        for (int a = 0; a<(Q->size);a++){
            enqueue(new_Q, Q->array[a]);
        }
        enqueue(new_Q,adder);
        Q->array=new_Q->array;
        Q->size = new_Q->size;
        Q->tail = new_Q->tail;
        Q->head = 0;
        Q->capacity=new_Q->capacity;
        delete_queue(new_Q);


    }
}


int main(){
    // function call
    struct queue * Qu = create_queue(MAX);
    enqueue(Qu,5);
    enqueue(Qu,5);
    enqueue(Qu,5);
    enqueue(Qu,5);
    enqueue(Qu,5);
    enqueue(Qu,6);
    printf("%i\n", Qu->tail-1);
    printf("%i\n", Qu->array[Qu->tail-1]);
    int temp = dequeue(Qu);
    printf("%i\n", temp);
    delete_queue(Qu);
}