#include <iostream>
#include <ctime>
#include <vector>
#include <cassert>

using namespace std;

// Location

struct Location {
    int x;
    int y;
};

Location OffsetLocation(Location loc, int dx, int dy) {
    loc.x += dx;
    loc.y += dy;
    return loc;
}

std::ostream& operator<<(std::ostream& out, Location loc) {
    out << "(" << loc.y + 1 << "," << loc.x + 1 << ")";
    return out;
}

bool operator==(Location lhs, Location rhs) {
    return lhs.x == rhs.x && lhs.y == rhs.y;
}

bool operator!=(Location lhs, Location rhs) {
    return !(lhs == rhs);
}

// Map.h

class Map {
    int size_;
    char** data_;

    const char symbol_;
public:
    Map(int size, char symbol);
    ~Map();

    void MarkLocation(Location loc, char symbol);
    void UnmarkLocation(Location loc);
    bool IsLocationMarked(Location loc) const;

    void Clear();

    bool ContainsLocation(Location loc) const {
        return loc.x >= 0 && loc.x < size_ && loc.y >= 0 && loc.y < size_;
    }

    Location RandomLocation();

    friend std::ostream& operator<<(std::ostream& out, const Map& map);
};

// Map.cpp

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

void Map::UnmarkLocation(Location loc) {
    data_[loc.y][loc.x] = symbol_;
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

// Game.h

class Player;

class Game {
    Map map_;
    std::vector<Player *> players_;
    std::vector<Generator *> generators_;

    int round_;
public:
    Game();
    ~Game();

    void Run(int numRounds);
};

// Unit.h

class Unit {
protected:
    Location location_;
public:
    Unit(Location location) : location_(location) { }

    Location location() const { return location_; }
};

// Player.h

class Map;

class Player : public Unit {
    int numRoundsNoMovement_;
protected:
    void LocationDidChange(Location previousLocation) {
        if (location() != previousLocation) {
            numRoundsNoMovement_ = 0;
        } else {
            numRoundsNoMovement_++;
        }
    }

public:
    Player(Location loc) : Unit(loc), numRoundsNoMovement_(0) { }

    bool Eliminated() { return numRoundsNoMovement_ == 2; }

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

// Generator

class Generator : public Unit {
public:
    using Unit::Unit;

    virtual Player *GeneratePlayer(int round) = 0;
    virtual ~Generator() = 0;
};

class GeneratorY : public Generator {
public:
    using Generator::Generator;

    Player *GeneratePlayer(int round) {
        if (round % 2 == 0) {
            return NULL;
        }

        Location playerLocation = location();
        playerLocation.y -= 1;
        return new PlayerA(playerLocation);
    }
};

// Player.cpp

Player::~Player() {

}

void PlayerA::Move(const Map &map) {
    Location currentLocation = location_;

    Location nextLocation = OffsetLocation(currentLocation, 0, -1);
    // nextlocation.y -= 1;

    if (map.ContainsLocation(nextLocation) && !map.IsLocationMarked(nextLocation)) {
        location_ = nextLocation;
    }

    LocationDidChange(currentLocation);
}

PlayerA::~PlayerA() {

}

void PlayerB::Move(const Map &map) {
    Location location = location_;
    location.y += 1;
    if (map.ContainsLocation(location) && !map.IsLocationMarked(location)) {
        location_ = location;
    }
    // LocationDidChange()
}

PlayerB::~PlayerB() {

}

// Generator.cpp

Generator::~Generator() {

}

// Game.cpp

Game::Game() : map_(10, '-'), round_(0) {
    Generator *generatorY = new GeneratorY(map_.RandomLocation());
    generators_.push_back(generatorY);

    map_.MarkLocation(generatorY->location(), 'Y'); // generatorY.symbol());
    // Location loc;
    // do {
    //     loc = map_.RandomLocation();
    // } while (map_.IsLocationMarked(loc));

    // players_.push_back(new PlayerB(loc));
    // map_.MarkLocation(loc, '*');

    // cout << "Player1 joins the game at " << loc << endl;
    cout << map_;
}

Game::~Game() {
    while (!generators_.empty()) {
        Generator *generator = generators_.back();
        generators_.pop_back();
        delete generator;
    }

    while (!players_.empty()) {
        Player *player = players_.back();
        players_.pop_back();
        delete player;
    }
}

void Game::Run(int numRounds) {
    while (numRounds-- > 0) {
        ++round_;
        cout << "Round " << round_ << endl;

        // Move players
        for (int i = 0; i < players_.size(); i++) {
            Player *player = players_[i];
            map_.UnmarkLocation(player->location());
            player->Move(map_);
            map_.MarkLocation(player->location(), '*');
        }

        // Remove eliminated pleyers
        for (int i = players_.size() - 1; i >= 0; i--) {
            Player *player = players_[i];
            if (player->Eliminated()) {
                players_.erase(players_.begin() + i);
                map_.UnmarkLocation(player->location());
                delete player;
            }
        }

        // Generate new players
        for (int i = 0; i < generators_.size(); i++) {
            Generator *generator = generators_[i];
            Player *player = generator->GeneratePlayer(round_);
            if (player != NULL) {
                if (!map_.IsLocationMarked(player->location())) {
                    players_.push_back(player);
                    map_.MarkLocation(player->location(), '*');
                } else {
                    delete player;
                }
            }
        }

        cout << map_;
    }

    // for (int i = 0; i < numRounds; i++) {
    //     bool hadMovement = false;

    //     ++round_;
    //     cout << "Round " << round_ << endl;

    //     map_.Clear();

    //     for (int j = 0; j < players_.size(); j++) {
    //         Player *player = players_[j];
    //         Location fromLocation = player->location();
    //         player->Move(map_);
    //         Location toLocation = player->location();

    //         map_.MarkLocation(toLocation, '*');

    //         if (fromLocation != toLocation) {
    //             hadMovement = true;
    //             cout << "Player" << j+1 << " moved from " << fromLocation << " to " << toLocation << endl;
    //         }
    //     }

    //     cout << "Map" << endl;
    //     cout << map_;

    //     if (!hadMovement) {
    //         cout << "Nobody moved" << endl;
    //         break;
    //     }
    // }
}

int main(int argc, const char * argv[]) {
    srand(time(NULL));
    Game game;
    game.Run(1);
    game.Run(4);
    return 0;
}
