#ifndef _LIST_H_
#define _LIST_H_

#include "node.hpp"

class List {
    Node* start;
    Node* end;
    unsigned size;
public:
    List();
    void Insert(int);
    List (int x,int y);
    static void Print(List&);
    bool verif(int);
    ~List();
};

#endif // _LIST_H
