#include <iostream>
#include <string>
#include <cstring>

using namespace std;

const int MAX_LEN = 40;


size_t myStrlen(const char* in_str)
{
    int str_len = 0;

    __asm {
        mov ECX, -1
        xor AL, AL
        mov EDI, in_str

        repne scasb

        not ECX
        dec ECX

        mov str_len, ECX
    }

    return str_len;
}


int main()
{
    char* str_1 = new char[MAX_LEN];
    strcpy_s(str_1, MAX_LEN, "I love assembly!");

    char* str_2 = (char*)malloc(MAX_LEN);
    strcpy_s(str_2, MAX_LEN, "I miss assembler!!!!");

    char str_3[MAX_LEN] = "I really like assembler!!";


    cout << "[Test 1]: Dynamic string allocated using \"new\": " << ((strlen(str_1) == myStrlen(str_1)) ? "PASSED" : "FAILED") << endl;
    cout << "[Test 2]: Dynamic string allocated using \"malloc\": " << ((strlen(str_2) == myStrlen(str_2)) ? "PASSED" : "FAILED") << endl;
    cout << "[Test 3]: Static string array: " << ((strlen(str_3) == myStrlen(str_3)) ? "PASSED" : "FAILED") << endl;

    delete[] str_1;
    free(str_2);

    return 0;
}