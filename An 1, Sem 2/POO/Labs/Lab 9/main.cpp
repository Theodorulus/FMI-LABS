#include <iostream>
#include <ctime>
#include <vector>


using namespace std;

struct Location
{
    int x, y;
};

class Map
{
    int size_;
    char ** data;
public:
    Location TopLeft()
    {
        Location l;
        l.x = 0;
        l.y = 0;
        return l;
    }

    Location TopRight()
    {
        Location l = TopLeft();
        l.x = size_ - 1;
        return l;
    }

    Location RandomLocation()
    {
        Location l;
        l.x = rand() % size_;
        l.y = rand() % size_;
    }

    void MovePlayer(Player& player, Location toLocation)
    {
        Location fromLocation = PlayerLocation(player);
        cout << "Moving Player from " << fromLocation << " to " << toLocation;
    }
};

class Player
{
public:
    virtual void Move(Map& map) = 0;
};

class PlayerA
{
public:
    virtual void Move(Map& map)
    {
        Location loc = map.PlayerLocation(this);
        loc.x ++;
        if (map.LocationAvailable(loc))
        {
            map.MovePlayer(this, loc);
        }
    }
};

class PlayerA
{
public:
    virtual void Move(Map& map)
    {
        Location loc = map.PlayerLocation(this);
        loc.x ++;
        loc.y ++;
        if (map.LocationAvailable(loc))
        {
            map.MovePlayer(this, loc);
        }
    }
};

class Game
{
    Map map_;
    vector <Player *> players;
    void DistributePlayers
    {
        //map_[0][0] = player1;
        //vs
        // map_.PlacePlayer(player1,map_.TopLeft());
    }
    void Update(){}
    void Render(){}
public:
    void Run(int numRounds)
    {
        //...
        //Update()
        //Render()
    }

};




int main()
{
    srand(time(NULL));

    Player* player1 = new PlayerA;
    Player* player2 = new PlayerB;

    vector<Player *> players;
    players.push_back(player1);
    players.push_back(player2);
    for (int i = 0; i < numarRunde; i++) {
        for (int j = 0; j < numarJucatori; j++) {
            // muta jucator j
            // players[j].Move(map)
            Player* player = players[j];
            player -> Move(map);
        }
        for (int j = 0; j < numarObiecte; j++)
        {
            Object* object = objects[j];
            switch (object.GetType())
            {
                case player:
                    //...
                    break;
                case item:
                    //...
                    break;
                case capcana:
                    //...
                    break;
            }
        }
    }
    return 0;
}
