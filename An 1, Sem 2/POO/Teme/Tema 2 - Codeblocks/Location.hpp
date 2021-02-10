#ifndef LOCATION_HPP_INCLUDED
#define LOCATION_HPP_INCLUDED

#include <iostream>

using namespace std;

struct Location
{
    int x;
    int y;
};

ostream& operator<<(ostream& out, const Location loc);

bool operator==(Location l1, Location l2);

bool operator!=(Location l1, Location l2);

#endif // LOCATION_H_INCLUDED
