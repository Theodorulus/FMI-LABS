#include <iostream>

using namespace std;

template <class Type>
class Array
{
    Type *a;
    int N;
public:
    Array(Type value);

};

template<class Type> Array::Array(Type val)
{
    for (int i = 0 ;i < N; i++)
        a[i] = val;
}

int main()
{
    cout << "Hello world!" << endl;
    return 0;
}
