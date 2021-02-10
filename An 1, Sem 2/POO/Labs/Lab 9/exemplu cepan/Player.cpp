//
//  Player.cpp
//

#include "Player.h"
#include "Map.cpp"

Player::~Player() {

}

void PlayerA::Move(const Map &map) {
    Location location = location_;
    location.x += 1;
    if (map.ContainsLocation(location)) {
        location_ = location;
    }
}

PlayerA::~PlayerA() {

}

void PlayerB::Move(const Map &map) {
    Location location = location_;
    location.y += 1;
    if (map.ContainsLocation(location)) {
        location_ = location;
    }
}

PlayerB::~PlayerB() {

}
