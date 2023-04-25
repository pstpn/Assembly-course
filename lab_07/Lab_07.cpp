#include <iostream>
#include <string>
#include <cstring>

using namespace std;

const int MAX_LEN = 40;
const int FIRST_STR_LEN = 18;
const int SECOND_STR_LEN = 22;

extern "C" void myStrcpy(char* dst, const char* src, const size_t len);


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
    char* str_1 = new char[FIRST_STR_LEN];
    char* str_2 = (char*)malloc(SECOND_STR_LEN);
    char str_3[MAX_LEN] = "I really like assembler!!";

    strcpy_s(str_1, FIRST_STR_LEN, "I love assembly!");
    strcpy_s(str_2, SECOND_STR_LEN, "I miss assembler!!!!");


    cout << endl << "===================myStrlen===================" << endl << endl;

    cout << "[Test 1]: Dynamic string allocated using \"new\": " << ((strlen(str_1) == myStrlen(str_1)) ? "PASSED" : "FAILED") << endl;
    cout << "[Test 2]: Dynamic string allocated using \"malloc\": " << ((strlen(str_2) == myStrlen(str_2)) ? "PASSED" : "FAILED") << endl;
    cout << "[Test 3]: Static string array: " << ((strlen(str_3) == myStrlen(str_3)) ? "PASSED" : "FAILED") << endl;

    delete[] str_1;
    free(str_2);

    char dst_1[MAX_LEN];
    char* dst_2 = str_3 + 4;


    cout << endl << "===================myStrcpy===================" << endl << endl;

    size_t len = myStrlen(str_3);
    char s_str_3[MAX_LEN] = "I really like assembler!!";
    myStrcpy(str_3, str_3, len);

    cout << "[Test 1]: Copying identical strings : " << 
        ((len == strlen(str_3) && (strcmp(str_3, s_str_3) == 0)) ? "PASSED" : "FAILED") << endl;

    myStrcpy(dst_1, str_3, strlen(str_3));

    cout << "[Test 2]: Usually string array test: " << 
        ((strlen(dst_1) == strlen(str_3) && (strcmp(str_3, dst_1) == 0)) ? "PASSED" : "FAILED") << endl;

    myStrcpy(dst_2, str_3, strlen(str_3));
    cout << "[Test 3]: Address overlay: " <<
        ((strlen(dst_2) == strlen(s_str_3) && (strcmp(s_str_3, dst_2) == 0)) ? "PASSED" : "FAILED") << endl;

    cout << endl << "==============================================" << endl << endl;

    return 0;
}