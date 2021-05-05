#include <iostream>
#include "Location.hpp"

using namespace std;

int main()
{
    Location l;
    l.x = 0;
    l.y = 2;
    cout << l;
    /*cout << p.location();
    p.Move();
    cout << p.location();*/
    /*Location l;
    l.x = 0;
    l.y = 2;
    Map m(5,'0');
    m.MarkLocation(l,'A');
    cout << m;
    cout << m.IsLocationMarked(l)<<endl;
    Location l1;
    l1.x = 1;
    l1.y = 2;
    cout << m.IsLocationMarked(l1) << endl;
    m.Clear();
    cout << m;
    Location l2;
    l2.x = 10;
    l2.y = 1;
    cout << m.ContainsLocation(l) << endl;
    cout << m.ContainsLocation(l2) << endl;
    cout << m.RandomLocation();*/
    return 0;
}
