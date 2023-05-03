#define _USE_MATH_DEFINES
#include <iostream>
#include <cmath>

const double DIV = 2;


double assemblySin() {

    double ans;

    __asm__(
        "fldpi\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(ans)
    );

    return ans;
}


double assemblyHalfSin() {

    double ans;

    __asm__(
        "fld %1\n"
        "fldpi\n"
        "fdiv %%ST(0), %%ST(1)\n"
        "fsin\n"
        "fstp %0\n"
        : "=m"(ans)
        : "m"(DIV)
    );

    return ans;
}


int main()
{
    std::cout << "\nPI:" << std::endl << std::endl;
    std::cout << "assemblySin(): " << assemblySin() << std::endl;
    std::cout << "sin(3.14): " << sin(3.14) << std::endl;
    std::cout << "sin(3.141596): " << sin(3.141596) << std::endl;

    std::cout << "\nPI / 2:" << std::endl << std::endl;
    std::cout << "assemblyHalfSin(): " << assemblyHalfSin() << std::endl;
    std::cout << "sin(3.14 / 2): " << sin(3.14 / 2) << std::endl;
    std::cout << "sin(3.141596 / 2): " << sin(3.141596 / 2) << std::endl;

    return 0;
}