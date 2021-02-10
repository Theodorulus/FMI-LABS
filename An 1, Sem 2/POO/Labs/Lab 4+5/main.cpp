#include <iostream>
#include <algorithm>
#include <assert.h>

using namespace std;

//array.h

//#ifndef ARRAY_H
//#define ARRAY_H

class Array
{
    int *v;
    const int n;
public:
    Array(int);
    Array(int, int);
    Array(const Array&);
    ~Array();
    int Length() const;
    int& At(int);
    void Fill(int);
    void Print(std::ostream& out = std::cout) const;
    Array FilterOdd() const;
    Array FilterMultipleOfFour() const;
    Array Filter(bool (* IsIncluded)(int)) const;
    void Add(Array);
    int& operator[](int i)
    {
        if(i < 0 || i >= n)
            throw "index out of bounds";
        return v[i];
    }
    const int& operator[](int i) const
    {
        if(i < 0 || i >= n)
            throw "index out of bounds";
        return v[i];
    }
    Array& operator=(const Array &other);
    Array operator+(const Array &otrher);

    //friend std::ostream& operator<<(std::ostream&, const Array&);
};

std::ostream& operator<<(std::ostream&, const Array&);

//#endif

//array.cpp
//using namespace std;

Array::Array (int size) : n(size) //Array a1(3) // 0 0 0
{
    if(size <= 0)
        v = NULL;
    else
    {
        v = new int[size];
        for(int i = 0; i < size; i++)
            v[i] = 0;
    }
}

Array::Array(int size, int val) : n(size)// Array a2(2, 1) // 1 1
{
    v = new int[size];
    for(int i = 0; i < size; i++)
        v[i] = val;
}

Array::Array(const Array &other) : n(other.n)
{
    if(n < 0)
        v = NULL;
    else
    {
        v = new int[n];
        for(int i = 0; i <= n; i++)
            v[i] = other.v[i];
    }
}

Array::~Array()
{
    if(v != NULL)
        delete[] v;
}

int Array::Length() const// a1.Length() // 3
{
    return n;
}

int& Array::At(int i)
{
    //if(i < n && i >= 0)
        return v[i];
}

void Array::Fill(int val)// a1.fill(5) // 5 5 5
{
    for(int i = 0; i < n; i++)
        v[i] = val;
}

Array Array::Filter(bool (* IsIncluded)(int)) const
{
    int nr = 0;
    for(int i = 0; i < n; i++)
        if(IsIncluded(v[i]))
            nr++;
    Array a(nr);
    int j = 0;
    for(int i = 0; i < n; i++)
        if(IsIncluded(v[i]))
            a.v[j++] = v[i];
    return a;
}

Array Array::FilterOdd() const
{
    int nr = 0;
    for(int i = 0; i < n; i++)
        if(v[i] % 2)
            nr++;
    Array a(nr);
    int j = 0;
    for(int i = 0; i < n; i++)
        if(v[i] % 2)
            a.v[j++] = v[i];
    return a;
}

Array Array::FilterMultipleOfFour() const
{
    int nr = 0;
    for(int i = 0; i < n; i++)
        if(v[i] % 4 == 0)
            nr++;
    Array a(nr);
    int j = 0;
    for(int i = 0; i < n; i++)
        if(v[i] % 4 == 0)
            a.v[j++] = v[i];
    return a;
}

Array& Array::operator=(const Array &other)
{
    if(&other != this)
    {
        if(n == other.n)
            for(int i = 0; i < n; i++)
                v[i] = other.v[i];
    }
    return *this;
}

Array Array::operator+(const Array &other)
{
    Array result(min(n, other.n));
    for(int i = 0; i < n; i++)
        result.v[i] = v[i] + other.v[i];
    return result;
}

void Array::Print(std::ostream& out) const
{
    for(int i = 0; i < n; i++)
        cout << v[i] << ' ';
    cout<<endl;
}

void Array::Add(Array arr)
{

}

std::ostream& operator<<(std::ostream& out, const Array& arr) {
    //for(int i = 0; i < arr.n; i++)
    //    out << arr.v[i] << ' ';
    arr.Print(out);
    return out;
}

//main.cpp

void PrintArray(const Array &arr)
{
    cout << arr;
    cout << arr.Length() << endl;
}

bool Odd(int x)
{
    return x % 2 == 1;
}

bool MultipleOfFour(int x)
{
    return x % 4 == 0;
}

void testCtor2()
{
    Array arr(3,2);
    assert(arr.Length() == 3);
    for (int i = 0; i < 3; i++)
        assert(arr[i] == 2);
}

int main()
{
    /*Array a(3, 1);
    cout << a.Length() << endl;
    cout << a.At(2) << endl;
    a.At(1) = 4;
    PrintArray(a);
    a.Print();
    a.Fill(5);
    a.Print();
    a.FilterOdd().Print();
    a.FilterMultipleOfFour().Print();
    PrintArray(a);
    Array arr3(2,5);
    arr3[0] = 10;
    a = arr3;
    cout<<a + arr3;*/
   /* Array arr1(3, 2);
    PrintArray(arr1); // 2 2 2
    arr1.Print(); // 2 2 2*/

    Array arr2(2);
    arr2.Print(); // 0 0

    Array arr3(2, 5);
    arr3[0] = 10;
    arr3[1] = 4;
    arr2 = arr3;
    arr3[1] = 10;
    arr2.Print(); // 10 5
    arr3.Print(); // 10 10

    (arr1 + arr2).Print(); // 12 7
    (arr2 + arr3).Print(); // 20 15
    testCtor2();

    cout << arr2.Filter(Odd);
    cout << arr2.Filter(MultipleOfFour);

    try
    {
        cout << arr1[100];
    }
    catch (const char *reason)
    {
        cout << reason << endl;
    }
    return 0;
}
