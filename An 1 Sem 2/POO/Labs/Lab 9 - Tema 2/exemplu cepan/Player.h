//
//  Player.h
//

#ifndef PLAYER_H
#define PLAYER_H

#include "Location.cpp"

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

    void Move(const Map& map);
};

#endif /* PLAYER_H */
