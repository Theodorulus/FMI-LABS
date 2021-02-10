#include "fraction.hpp"
#include <stdexcept>
int cmmdc(int x,int y)
{
    while(x!=y)
        if(x>y)
            x-=y;
        else y-=x;
    return x;
}
int cmmmc(int x,int y)
{
    return x*y/cmmdc(x,y);
}
Fraction::Fraction(int numarator,int numitor)
{
    n=numarator;
    if(numitor==0)
        throw out_of_range;
    m=numitor;
    int cd;
    cd=cmmdc(n,m);
    if(cd!=1)
    {
        n/=cd;
        m/=cd;
    }
}

Fraction Fraction::operator-(const Fraction& obj){
    int cm=m;
    int cn=n;
    cm=cmmdc(m,ob.m);
    cn=cm/m*n-cm/ob.m*ob.n;
    Fraction returnObj(cn, cm);
    return returnObj;
}

Fraction Fraction::operator*(const Fraction& obj){
    int cm = m*obj.m;
    int cn = n*obj.n;
    Fraction returnObj(cn, cm);
    return returnObj;
}
Fraction Fraction::operator/(const Fraction& obj){
    int cm = m * obj.n;
    int cn = n* obj.m;
    Fraction returnObj(cn, cm);
    return returnObj;
}

std::ostream& operator <<(std::ostream& output, const Fraction& obj){
    output << obj.n << "/" << obj.m;
    return output;
}

std::istream& operator >>(std::istream& input, Fraction& obj){
    input >> obj.n >> obj.m;
    return input;
}

Fraction Fraction::operator+(Fraction ob)
{
    int cm=m;
    int cn=n;
    cm=cmmdc(m,ob.m);
    cn=cm/m*n+cm/ob.m*ob.n;
    Fraction f(cn,cm);
    return f;
}
