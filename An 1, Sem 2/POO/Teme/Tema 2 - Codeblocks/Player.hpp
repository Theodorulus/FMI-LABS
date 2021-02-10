#ifndef PLAYER_HPP_INCLUDED
#define PLAYER_HPP_INCLUDED

#include "Location.hpp"
#include "Map.hpp"

class Map;

class Player {
protected:
    Location location_;
public:
    Player(Location location) : location_(location) { }

    Location location() const { return location_; }

    virtual void Move(const Map& map) = 0;
    virtual ~Player() = 0;
};

class PlayerA: public Player {
public:
    using Player::Player;
    ~PlayerA();

    void Move(const Map& map);
};

class PlayerB: public Player {
public:
    using Player::Player;
    ~PlayerB();

    //void Move(const Map& map);
};

#endif // PLAYER_HPP_INCLUDED
