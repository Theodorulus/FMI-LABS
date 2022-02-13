#include <ctime>

struct Location {
    int x;
    int y;
}

class Map {
    int size_;
    char ** data_;
    public:
    Location TopLeft() {
        Location l;
        l.x = 0;
        l.y = 0;
        return l;
    }
    Location TopRight() {
        Location l = TopLeft();
        l.x = size_ - 1;
        return l;
    }

    Location RandomLocation() {
        Location l;
        l.x = rand() % size_;
        l.y = rand() % size_;
        return l;
    }

    void MovePlayer(Player &player, Location toLocation) {
        Location fromLocation = PlayerLocation(player);
        cout << "Moving Player from " << fromLocation << "to " << toLocation;
    }
};

enum ObjectType {
    playerA = 0,
    playerB,
    placerC
    item,
    capcana
};

class Object {
    public:
    virtual ObjectType GetType() = 0;
}

class Player: Object {
    public:
    ObjectType GetType() {
        return ObjectType::player;
    }

    virtual void Move(Map&) = 0;
    // vs?
    virtual Location* NextMove(Map&) = 0;
}

class PlayerA {
    public:
    virtual void Move(Map& map) {
        // MutaPlayerA(this);

        Location loc = map.PlayerLocation(this);
        loc.x += 1;
        if (map.LocationAvailable(loc)) {
            map.MovePlayer(this, loc);
        }
    }
};

class PlayerB {
    public:
    virtual void Move(Map& map) {
        Location loc = map.PlayerLocation(this);
        loc.x += 1;
        loc.y += 1;
        if (map.LocationAvailable(loc)) {
            map.MovePlayer(this, loc);
        }
    }
}

class Game {
    Map map_;
    vector<Player *> players_;

    void DistributePlayers() {
        // map_[0][0] = player1;
        // vs
        // map_.PlacePlayer(player1, map_.TopLeft());
    }

    // Run a game round
    void Update() {

    }
    // Prints current game status
    void Render() {

    }
    public:
    void Run(int numRounds) {
        // i = 0.. numRounds
        //    Update();
        //    Render();
    }
};

void MutaPlayerA(PlayerA *player) {

}

int main() {
    srand(time(NULL));

    Player* player1 = new PlayerA;
    Player* player2 = new PlayerB;

    vector<Player *> players;
    players.push_back(player1);
    players.push_back(player2);

    for (int i = 0; i < numarRunde; i++) {
        /*
        for (int j = 0; j < numarJucatori; j++) {
            // jucator poz j
            Player* player = players[j];

            /*
            if (PlayerA* playerA = dynamic_cast<PlayerA*>(player)) {
                // mut player la dreapta
            } else if (PlayerB* playerB = dynamic_cast<PlayerB*>(player)) {
                // mut player la stanga
            }

            // vs

            player->Move(map);
        } */

        for (int j = 0; j < numarObiecte; j++) {
            Object* object = objects[j];

            switch (object.GetType()) {
                // case playerA:
                //     PlayerA *player = dynamic_cast<PlayerA*>(object);
                //     // ...
                //     break;
                // case playerB:
                //     break;
                // case playerC:
                //     break;
                case player:
                    Player* player = dynamic_cast<Player*>(object);
                    player->Move(map);
                    break;
                case item:
                    // ...
                    break;
                case capcana:
                    // ...
                    break;
            }
        }

    }


}
