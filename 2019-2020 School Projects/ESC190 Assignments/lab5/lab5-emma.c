#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void encodeNuc(char *filename){
    FILE * opened = fopen(filename, "r");
    char out[10000];
    out[0] = 'b';
    int a = 0;
    int b = 1;
    while(filename[a] != '\0'){
        out[b] = filename[a];
        a += 1;
        b += 1;
    }
    out[b] = '\0';
    FILE * return_pointer = fopen(out, "w");
    char data = getc(opened);
    // printf("%c\n",data);
    while( data != EOF && data != '\0'){
        if (data == 'A'){
                fprintf(return_pointer, "00");}
        if (data == 'C'){
                fprintf(return_pointer, "01");}
        if (data == 'G'){
                fprintf(return_pointer, "10");}
        if (data == 'T'){
                fprintf(return_pointer, "11");}
        data = getc(opened);
    }

    fclose(opened);
    fclose(return_pointer);
}


void decodeBin(char *filename){
    FILE * opened = fopen(filename, "r");
    char out[10000];
    out[0] = 'n';
    int a = 0;
    int b = 1;
    while(filename[a] != '\0'){
        out[b] = filename[a];
        a += 1;
        b += 1;
    }
    out[b] = '\0';
    FILE * return_pointer = fopen(out, "w");
    char data = getc(opened);

    while( data != EOF && data != '\0'){
        if (data == '0'){
            char data2 = getc(opened);
            if (data2 == '0' && data2 != '\0'){
                    fprintf(return_pointer, "A");}
            if (data2 == '1' && data2 != '\0'){
                    fprintf(return_pointer, "C");}
            }
        if (data == '1'){
            char data2 = getc(opened);
            if (data2 == '0' && data2 != '\0'){
                    fprintf(return_pointer, "G");}
            if (data2 == '1' && data2 != '\0'){
                    fprintf(return_pointer, "T");}
            }
        data = getc(opened);
        }
    fclose(opened);
    fclose(return_pointer);
}

void findProtein(char *filename, int checkPos, int proteinInfo[]){
    char data[4];
    int counter = 1;
    proteinInfo[0] = 0;
    proteinInfo[1] = 0;
    decodeBin(filename);
    char out[10000];
    out[0] = 'n';
    int a = 0;
    int b = 1;
    while(filename[a] != '\0'){
        out[b] = filename[a];
        a += 1;
        b += 1;
    }
    out[b] = '\0';
    FILE * opened = fopen(out, "r");
    char c;
    int i = 0;
    while (i < checkPos-1){
        c = getc(opened);
        i += 1;
    }

    while (counter <  4){
        data[counter-1] = getc(opened);
        // printf("%c\n", data[counter-1]);
        counter += 1;
    }

    //printf("%c", data[0]);
    //printf("%c", data[1]);
    //printf("%c\n", data[2]);
    while(1){
    //      printf("%c\n", data[0]);
    //printf("%c", data[0]);
    //printf("%c", data[1]);
    //printf("%c\n", data[2]);
    //      printf("first while\n");
    if ((data[0] == 'A') && (data[1] == 'T') && (data[2] == 'G')){
    //              printf("%d\n", proteinInfo[0]);
        proteinInfo[0] = checkPos + counter - 3;
        break;}
    else{
        counter += 1;
        data[0] = data[1];
        data[1] = data[2];
        data[2] = getc(opened);
        if (data[2] == EOF || data[2] == '\0'){
                fclose(opened);
                return;}
    }
    }
    while(1){
    //        printf("second while\n");
    //printf("%c", data[0]);
    //printf("%c", data[1]);
    //printf("%c\n", data[2]);      
        if (proteinInfo[0] != 0){
            if ((data[0] == 'T') && (((data[1] == 'A') && (data[2] == 'A')) || ((data[1] == 'A') && (data[2] == 'G')) || ((data[1] == 'G') && (data[2] == 'A')))){
                proteinInfo[1] = (checkPos+ counter - proteinInfo[0])/3;
                break;}

            else{
                counter += 3;
                data[0] = getc(opened);
                if (data[0] == EOF || data[0] == '\0'){
                    fclose(opened);
                    return;}
                data[1] = getc(opened);
                if (data[1] == EOF || data[1] == '\0'){
                    fclose(opened);
                    return;}
                data[2] = getc(opened);
                if (data[2] == EOF || data[2] == '\0'){
                    fclose(opened);
                    return;}
    }}
        else{
            fclose(opened);
            return;}
    }
    fclose(opened);
    //printf("%d %d\n", proteinInfo[0], proteinInfo[1]);
}

void proteinReport(char *filename){
    //decode the binary filename
    decodeBin(filename);
    //printf("decoded\n");

    //create another file to write into
    char out[10000];
    out[0] = 'r';
    int a = 0;
    int b = 1;
    while(filename[a] != '\0'){
        out[b] = filename[a];
        a += 1;
        b += 1;
    }
    out[b] = '\0';
    FILE * return_pointer = fopen(out, "w");
    //printf("file made \n");

    //initialize important values
    int first = 0;
    int start = 0;
    int arr[2];
    findProtein(filename, start, arr);

    if (arr[0] == 0){
        fprintf(return_pointer, "%d, %d\n", 0, 0);
    }
    while(arr[0] != 0){
        printf("%d %d\n", arr[0], arr[1]);
        fprintf(return_pointer, "%d,%d\n", arr[0]-1, arr[1]);
        findProtein(filename, arr[0] + 3*arr[1], arr);
    }


fclose(return_pointer);
}

int main(void){
    char *b = "test.txt";
    encodeNuc(b);
    int arr[2];
//      findProtein("bfullSLV.txt", 1, arr);
    proteinReport("btest.txt");
//      findProtein("bpartialSLV.txt", 63, arr);
}