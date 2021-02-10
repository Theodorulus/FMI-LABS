#ifndef _NODE_H
#define _NODE_H

#include <iostream>

class List;

class Node {
    int info;
    Node* next;
    static int counter;
public:
    Node(int, Node*);
    friend class List;
    ~Node();
};

inline Node::Node (int i, Node* n = NULL) : info(i), next(n) {
    counter++;
}

int Node::counter = 0;

#endif // _NODE_H
