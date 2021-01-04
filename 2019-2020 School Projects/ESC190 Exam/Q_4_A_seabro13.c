#include <stdio.h>
#include <stdlib.h>

#define M 3
#define N 4
#define L 5

int main(){
    /* ~~~~~~~~~~~~Part A~~~~~~~~~~~~~*/
    int array[L][M][N];
    for (int i = 0; i< L; i++){
        for (int j = 0; j< M; j++){
            for (int k =0; k<N; k++){
                int sum = i+j+k;
                int val = 2;
                for (int po = 1; po<sum;po++){
                    val=val*2;
                }
                array[i][j][k] = val;
            }
        }
    }
/* ~~~~~~~~~~~~Part B~~~~~~~~~~~~~*/

    int new_array[L][M][N];
    int x=0,y=0,z = 0;
    for (int a = 0; a<L*M*N; a ++){
        new_array[x][y][z] = array[x][y][z];

        z++;
        if(z==N){
            z=0;
            y++;
        }
        if(y==M){
            y = 0;
            x++;
        }
    }

    /* ~~~~~~~~~~~~Part C~~~~~~~~~~~~~*/
    int u=0,v=0,w = 0;
    long long int power = 1;
    for (int b = 0; b<L*M*N; b ++){
        new_array[u][v][w] = power;

        w++;
        if(w==N){
            w=0;
            v++;
        }
        if(v==M){
            v = 0;
            u++;
            power=power*4;
        }

    }
    /* ~~~~~~~~~~~~Part D~~~~~~~~~~~~~*/
    int r=0,s=0,t = 0;
    unsigned long long pow_2 = 1;
    long long int t_s = 1;
    for (int c = 0; c<L*M*N; c ++){
        new_array[r][s][t] = pow_2;

        t++;
        if(t==N){
            t=0;
            s++;
            t_s = t_s*2;
        }
        if(s==M){
            s = 0;
            r++;
            t_s = 1;
        }
        if(s==0||t==0){
            pow_2 = 1;
        }
        else{
            pow_2 = pow_2 * t_s;
        }

    }


}
