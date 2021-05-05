#ifndef MAP_HPP_INCLUDED
#define MAP_HPP_INCLUDED

#include <iostream>
#include "Location.hpp"

class Map
{
    int size_;
    char** data_;

    const char symbol_;
public:
    Map(int size, char symbol);
    ~Map();

    void MarkLocation(Location loc, char symbol);

    bool IsLocationMarked(Location loc) const;

    void Clear();

    bool ContainsLocation(Location loc) const ;


    Location RandomLocation();

    friend std::ostream& operator<<(std::ostream& out, const Map& map);
};

#endif // MAP_HPP_INCLUDED
