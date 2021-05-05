//
//  Location.h
//
//

#ifndef LOCATION_H
#define LOCATION_H

#include <iostream>

using namespace std;

struct Location {
    int x;
    int y;
};

ostream& operator<<(ostream& out, Location loc);

bool operator==(Location lhs, Location rhs);
bool operator!=(Location lhs, Location rhs);

#endif /* LOCATION_H */
