//
//  Location.cpp
//

#include "Location.h"
#include <stdexcept>

using namespace std;

ostream& operator<<(ostream& out, Location loc)
{
    out << "(" << loc.x + 1 << "," << loc.y + 1 << ")";
    return out;
}

bool operator==(Location lhs, Location rhs) {
    return lhs.x == rhs.x && lhs.y == rhs.y;
}

bool operator!=(Location lhs, Location rhs) {
    return !(lhs == rhs);
}
