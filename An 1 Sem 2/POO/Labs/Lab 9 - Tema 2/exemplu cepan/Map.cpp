//
//  Map.cpp
//

#include "Map.h"

#include <iostream>
#include <cassert>

Map::Map(int size, char symbol) : size_(size), symbol_(symbol) {
    data_ = new char*[size_];
    for (int i = 0; i < size_; i++) {
        data_[i] = new char[size_];
        for (int j = 0; j < size_; j++) {
            data_[i][j] = symbol_;
        }
    }
}

void Map::MarkLocation(Location loc, char symbol) {
    assert(symbol != symbol_);
    data_[loc.y][loc.x] = symbol;
}

bool Map::IsLocationMarked(Location loc) const {
    return data_[loc.y][loc.x] != symbol_;
}

void Map::Clear() {
    for (int i = 0; i < size_; i++) {
        for (int j = 0; j < size_; j++) {
            data_[i][j] = symbol_;
        }
    }
}

Map::~Map() {
    for (int i = 0; i < size_; i++) {
        delete [] data_[i];
    }
    delete [] data_;
}

Location Map::RandomLocation() {
    Location l;
    l.x = rand() % size_;
    l.y = rand() % size_;
    return l;
}

std::ostream& operator<<(std::ostream& out, const Map& map) {
    for (int i = 0; i < map.size_; i++) {
        for (int j = 0; j < map.size_; j++) {
            out << map.data_[i][j] << " ";
        }
        out << std::endl;
    }
    return out;
}
