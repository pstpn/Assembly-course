#include <iostream>
#include <chrono>

const int REPEAT_COUNT = 10000000;


template<typename T>
void assemblyAdd(T a, T b) {

    T ans;
    auto repeat_count = REPEAT_COUNT;

    auto start = std::chrono::system_clock::now();
    while (--repeat_count)
        __asm__(
            "fld %1\n"
            "fld %2\n"
            "faddp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            : "=m"(ans)
            : "m"(a),
            "m"(b)
        );
    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double, std::milli> all_time = end - start;
    std::cout << "\nASM add time(" << typeid(T).name() << "): "
        << all_time.count() << " ms" << std::endl << std::endl;
}

template<typename T>
void assemblyMul(T a, T b) {

    T ans;
    auto repeat_count = REPEAT_COUNT;

    auto start = std::chrono::system_clock::now();
    while (--repeat_count)
        __asm__(
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            : "=m"(ans)
            : "m"(a),
            "m"(b)
        );
    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double, std::milli> all_time = end - start;
    std::cout << "\nASM mul time(" << typeid(T).name() << "): "
        << all_time.count() << " ms" << std::endl << std::endl;
}

template<typename T>
void add(T a, T b) {

    T ans;
    auto repeat_count = REPEAT_COUNT;

    auto start = std::chrono::system_clock::now();
    while (--repeat_count)
        ans = a + b;
    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double, std::milli> all_time = end - start;
    std::cout << "\nUsually add time(" << typeid(T).name() << "): "
        << all_time.count() << " ms" << std::endl << std::endl;
}

template<typename T>
void mul(T a, T b) {

    T ans;
    auto repeat_count = REPEAT_COUNT;

    auto start = std::chrono::system_clock::now();
    while (--repeat_count)
        ans = a * b;
    auto end = std::chrono::system_clock::now();

    std::chrono::duration<double, std::milli> all_time = end - start;
    std::cout << "\nUsually mul time(" << typeid(T).name() << "): " 
        << all_time.count() << " ms" << std::endl << std::endl;
}

int main() {

    double c = 99.12, d = 3.3;
    float a = 13.22, b = 0.12;

#ifndef ASM 
    std::cout << "\nWithout ASM: \n";

    add(a, b);
    add(c, d);

    mul(a, b);
    mul(c, d);
#else
    std::cout << "\nWith ASM: \n";

    assemblyAdd(a, b);
    assemblyAdd(c, d);
    
    assemblyMul(a, b);
    assemblyMul(c, d);
#endif
    return 0;
}