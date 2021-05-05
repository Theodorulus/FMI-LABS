//
//  Map.h
//

#ifndef MAP_H
#define MAP_H

#include <iostream>
#include "Location.cpp"

class Map {
    int size_;
    char** data_;

    const char symbol_;
public:
    Map(int size, char symbol);
    ~Map();

    void MarkLocation(Location loc, char symbol);
    bool IsLocationMarked(Location loc) const;

    void Clear();

    bool ContainsLocation(Location loc) const {
        return loc.x >= 0 && loc.x < size_ && loc.y >= 0 && loc.y < size_;
    }

    Location RandomLocation();

    friend std::ostream& operator<<(std::ostream& out, const Map& map);
};

#endif /* MAP_H */
