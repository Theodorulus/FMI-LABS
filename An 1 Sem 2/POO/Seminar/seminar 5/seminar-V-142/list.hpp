#pragma once

#include "node.hpp"
#include <stdexcept>
#include <iostream>

using namespace std;

template <typename T>
class List
{
    Node<T> *start, *last;
    unsigned size;

    void cleanup ();
public:
    List ();
    List (const unsigned&, const T&);
    List (const List<T>&);
    ~List();
    void push (const T&);
    void pop (const T&);
    T operator[] (const unsigned&) const;
    List<T>& operator= (const List<T>&);

    template <typename U>
    friend ostream& operator<<(ostream&, const List<U>&);

    template <typename U>
    friend istream& operator>>(istream&, List<U>&);
};

template<typename T>
List<T>::List():start(NULL), last(NULL), size(0){
}

template<typename T>
void List<T>::push(const T& val){
  if(start == NULL){
    last = start = new Node<T>(val);
    size++;
    return;
  }
  Node<T> *aux = new Node<T>(val);
  last->next = aux;
  last = aux;
  size++;
}

template<typename T>
List<T>::List(const unsigned& s, const T& val):List()
{
  for(int i=0; i<s;i++)
    push(val);
}

template<typename T>
List<T>::List(const List<T>& lista):List(){
    Node<T> *Nou=lista.start;
    while(Nou)
    {
      push(Nou->info);
      Nou=Nou->next;
    }
}

template <typename T>
void List<T>::cleanup () {
   while(start)
  {
    Node<T> *aux=this->start;
    start=start->next;
    delete aux;
  }
  this->size=0;
  this->start=this->last=NULL;
}


template<typename T>
List<T>::~List()
{
  this->cleanup();
}

template<typename T>
void List<T>::pop(const T& val)
{
  if(start->info==val)
  {
    Node<T> *Aux=start;
    start=start->next;
    delete Aux;
    size--;
    return;
  }
  Node<T> *aux=start->next;
  Node<T> *aux2=start;
  while(aux)
  {
      if(aux->info==val){
        aux2->next=aux->next;
        if (aux->next == NULL) {
          last = aux2;
        }
        delete aux;
        size--;
        return;
      }
      aux2=aux;
      aux=aux->next;
  }
}

template<typename T>
T List<T>::operator[] (const unsigned& i) const
{
  if(i >= size)
    throw out_of_range("index invalid");
  Node<T> *cnt = start;
  for(int j = 1; j <= i; ++j)
    cnt = cnt->next;

  return cnt->info;
}

template <typename T>
List<T>& List<T>::operator= (const List<T>& L){
  if(&L==this)
    return *this;
  this->cleanup();
  Node<T> *Nou=L.start;
  while(Nou)
  {
    push(Nou->info);
    Nou=Nou->next;
  }
  return *this;
  // List l2, l = List(l2);
 
}

template <typename U>
ostream& operator<<(ostream& out, const List<U>& L)
{
  Node<U> *nou=new Node(L.start->info,L.start->next);
  while(nou)
  {
    out<<nou->info<<",";
    nou=nou->next;
  }
  return out;
}

template <typename U>
istream& operator>>(istream& in, List<U>& L)
{
  L.cleanup();
  int c_size;
  in>>c_size;
  for(int i=0;i<c_size;i++)
    {
      U val;
      in>>val;
      L.push(val);
    }
  return in;
}





/*




*/