#include "list.hpp"

List::List(){
    start = NULL;
    end = NULL;
    size = 0;
}

void List::Insert(int val){
    if(start == NULL){
        start = end = new Node(val);
    }
    else{
        Node *aux = new Node(val);
        end -> next = aux;
        end = aux;
    }
    size ++;
}

List::List(int x, int y) : List() {
    for(int i=1;i<=x;i++)
        Insert(y);
}

static void List::Print(List &list){
    if(list.start == NULL){
        return;
    }

    Node *aux = list.start;
    for(int i=0; i<list.size; i++)
    {
        cout<<aux->info<<" ";
        aux = aux->next;
    }
}

List::~List(){
    if(start == NULL)
        return;
    Node *aux1 = start;
    Node *aux2 = start;
    while(aux1 != NULL){
        aux2 = aux1->next;
        delete aux1;
        aux1 = aux2;
    }
}
bool List::verif(int x){
    if(start == NULL)
        return false;
    Node *aux = start;
    while(aux!=NULL)
    {
        if(aux->info==x)
            return true;
        aux=aux->next;
    }
    return false;
}
