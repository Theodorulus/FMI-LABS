#ifndef _VECTOR_H
#define _VECTOR_H

#include <iostream>
#include "fraction.hpp"


class Vector {
    Fraction * arr;
    int size;
    int maxSize;
public:
    Vector(unsigned = 1);
    void push(Fraction fr);
    Vector& operator=(const Vector&);
    Fraction& operator[](const unsigned);
};

#endif // _FRACTION_H
