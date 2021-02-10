//
//  Game.h
//

#ifndef GAME_H
#define GAME_H

#include <vector>
#include "Map.cpp"

class Player;

class Game {
    Map map_;
    std::vector<Player *> players_;

    int round_;
public:
    Game();
    ~Game();

    void Run(int numRounds);
};

#endif /* GAME_H */
