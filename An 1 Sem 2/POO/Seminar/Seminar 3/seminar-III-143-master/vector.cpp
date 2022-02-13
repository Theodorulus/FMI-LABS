#include "vector.hpp"
#include <stdexcept>
Vector::Vector(unsigned s) : maxSize(s), size(0)
{
    arr = new Fraction[maxSize];
}

void Vector::push(Fraction fr)
{
    if(size == maxSize)
    {
        maxSize += 5;
        Fraction* aux = new Fraction[maxSize];
        for(int i=0; i < size; i++)
        {
            aux[i] = arr[i];
        }
        delete[] arr;
        arr = aux;
    }

    arr[size] = fr;
    size++;
}
Vector& Vector:: operator=(const Vector& ob)
{
    if(this==&ob)
        return *this;
    if(maxSize<ob.size)
    {
        delete[] arr;
        arr=new Fraction[ob.maxSize];
        maxSize=ob.maxSize;
    }
    size=ob.size;
    for(int i=0;i<size;i++)
        arr[i]=ob.arr[i];
    return *this;
}
Fraction& Vector:: operator[](const unsigned x)
{
    if(x>=size)
        throw std::out_of_range("Index out of range");
    return arr[x];

}
