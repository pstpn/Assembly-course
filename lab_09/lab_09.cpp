#include <iostream>
#include <ctime>
#include <chrono>
#include <vector>

const size_t COUNT = (size_t) 1e7;
const size_t N = 4;

using namespace std;


void deepCopy(float *dst, const float* src) {
    for (size_t i = 0; i < N; ++i)
        dst[i] = src[i];
}


void mulCpp(const float* first_vector, const float* second_vector) {

    float result;

    clock_t all_time = 0;


    for (size_t i = 0; i < COUNT; ++i) {
        result = 0;

        auto start = clock();
        for (size_t j = 0; j < N; ++j)
            result += first_vector[j] * second_vector[j];
        auto end = clock();

        all_time += end - start;
    }

    cout << "\nCpp mul time: " << all_time << " ms" << endl;
    cout << "Result: " << result << endl;
}


void addCpp(const float* first_vector, const float* second_vector) {

    float result[N];

    clock_t all_time = 0;


    for (size_t i = 0; i < COUNT; ++i) {
        auto start = clock();
        for (size_t j = 0; j < N; ++j)
            result[j] = first_vector[j] + second_vector[j];
        auto end = clock();

        all_time += end - start;
    }

    cout << "\nCpp add time: " << all_time << " ms" << endl;
    cout << "Result: [";
    for (size_t i = 0; i < N - 1; ++i)
        cout << result[i] << ", ";
    cout << result[N - 1] << "]" << endl;
}


void mulSse(const float* first_vector, const float* second_vector) {

    float result = 0;

    float f_v[N];
    float s_v[N];

    clock_t all_time = 0;

    deepCopy(f_v, first_vector);
    deepCopy(s_v, second_vector);


    for (size_t i = 0; i < COUNT; ++i) {
        auto start = clock();
        __asm
        {
            movups xmm0, f_v
            movups xmm1, s_v

            mulps xmm0, xmm1

            movhlps xmm1, xmm0
            addps xmm0, xmm1
            movups xmm1, xmm0
            shufps xmm0, xmm0, 1
            addps xmm0, xmm1
            movss result, xmm0
        }
        auto end = clock();

        all_time += end - start;
    }

    cout << "\nSse mul time: " << all_time << " ms" << endl;
    cout << "Result: " << result << endl;
}


void addSse(const float* first_vector, const float* second_vector) {

    float result[N];
    float f_v[N];
    float s_v[N];

    clock_t all_time = 0;

    deepCopy(f_v, first_vector);
    deepCopy(s_v, second_vector);


    for (size_t i = 0; i < COUNT; ++i) {
        auto start = clock();
        __asm {
            movups xmm0, f_v
            movups xmm1, s_v
            addps xmm1, xmm0
            movups result, xmm1
        }
        auto end = clock();

        all_time += end - start;
    }

    cout << "\nSse add time: " << all_time << " ms" << endl;
    cout << "Result: [";
    for (size_t i = 0; i < N - 1; ++i)
        cout << result[i] << ", ";
    cout << result[N - 1] << "]" << endl;
}

int main() {

    float first_vector[N] = {1e-2, 1.13e-3, 10033, -12.1111};
    float second_vector[N] = {1e-4, 2, -14.1414, -.121121};

    mulCpp(first_vector, second_vector);
    mulSse(first_vector, second_vector);

    addCpp(first_vector, second_vector);
    addSse(first_vector, second_vector);

    return 0;
}
