#include "Location.hpp"

using namespace std;

ostream& operator<<(ostream& out, const Location loc)
{
    out << "(" << loc.x + 1 << "," << loc.y + 1 << ")";
    return out;
}

bool operator==(Location l1, Location l2)
{
    return ((l1.x == l2.x) && (l1.y == l2.y));
}

bool operator!=(Location l1, Location l2)
{
    return !(l1 == l2);
}
