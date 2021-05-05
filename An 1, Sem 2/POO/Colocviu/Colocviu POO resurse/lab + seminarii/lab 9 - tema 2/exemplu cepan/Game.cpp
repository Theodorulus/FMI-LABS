//
//  Game.cpp
//

#include "Game.h"
#include <iostream>
#include "Player.cpp"

using namespace std;

Game::Game() : map_(10, '-'), round_(0) {
    Location loc;
    do {
        loc = map_.RandomLocation();
    } while (map_.IsLocationMarked(loc));

    players_.push_back(new PlayerB(loc));
    map_.MarkLocation(loc, '*');

    cout << "Player1 joins the game at " << loc << endl;
    cout << map_;
}

Game::~Game() {
    while (!players_.empty()) {
        Player *player = players_.back();
        players_.pop_back();
        delete player;
    }
}

void Game::Run(int numRounds) {
    for (int i = 0; i < numRounds; i++) {
        bool hadMovement = false;

        ++round_;
        cout << "Round " << round_ << endl;

        map_.Clear();

        for (int j = 0; j < players_.size(); j++) {
            Player *player = players_[j];
            Location fromLocation = player->location();
            player->Move(map_);
            Location toLocation = player->location();

            map_.MarkLocation(toLocation, '*');

            if (fromLocation != toLocation) {
                hadMovement = true;
                cout << "Player" << j+1 << " moved from " << fromLocation << " to " << toLocation << endl;
            }
        }

        cout << "Map" << endl;
        cout << map_;

        if (!hadMovement) {
            cout << "Nobody moved" << endl;
            break;
        }
    }
}
