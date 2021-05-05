#ifndef _FRACTION_H
#define _FRACTION_H

#include <iostream>

class Fraction {
    // n - numarator;
    // m - numitor;
    int n, m;
public:
    Fraction (int, int = 1);
    Fraction operator+(const Fraction&);
    Fraction operator-(const Fraction&);
    Fraction operator*(const Fraction&);
    Fraction operator/(const Fraction&);

    friend std::ostream& operator << (std::ostream&, const Fraction&);
    friend std::istream& operator >> (std::istream&, Fraction&);
};

#endif // _FRACTION_H