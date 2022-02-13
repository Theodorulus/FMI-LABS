#include <iostream>
#include <cassert>
#include <stdexcept>

using namespace std;

class List{
    struct Node{
        int val;
        Node* next;
        Node(int v):val(v), next(NULL) {}
    };
    Node* head;
    Node* tail;

    void Clear()
    {
        if(head == NULL)
            return;
        Node* node = head;
        Node* p;
        do
        {
            p = node;
            node = node->next;
            delete p;
        } while(node != NULL);
        head = NULL;
        tail = NULL;
    }
public:
    List(): head(NULL), tail(NULL){}

    ~List()
    {
        Clear();
    }

    void Append(int val)
    {
        Node* node = new Node(val);
        if (tail != NULL)
            tail->next = node;
        else
        {
            assert(head == NULL);
            head = node;
        }
        tail = node;
    }
    const int& operator[](int pos) const
    {
        Node* node = head;
        while(node != NULL && pos > 0)
        {
            pos--;
            node = node->next;
        }
        if(node == NULL)
            throw out_of_range("index out of range");
        return node->val;
    }
    int Size() const
    {
        int size = 0;
        Node* node = head;
        while(node != NULL)
        {
            size++;
            node = node->next;
        }
    }

    List& operator=(const List& other)
    {
        if(&other != this)
        {
            Clear();
            Node* node_other = other.head;
            if(node_other != NULL)
                head = new Node (node_other->val);
                tail = head;
                node_other = node_other->next;
                while(node_other != NULL)
                {
                    Node* node = new Node(node_other->val);
                    tail->next = node;
                    tail = node;

                    node_other = node_other->next;
                }
        }
        return *this;
    }

    friend ostream& operator<<(ostream& out, const List& l);
    friend istream& operator>>(istream& in, List& l);
};

ostream& operator<<(ostream&out, const List& l)
{
    List::Node* node = l.head;
    while(node != NULL)
    {
        out << node->val <<' ';
        node = node->next;
    }
    return out;
}

istream& operator>>(istream& in, List &l)
{
    l.Clear();
    int size;
    in>>size;
    int value;
    while(size > 0)
    {
        in>>value;
        l.Append(value);
        size--;
    }
    return in;
}


void PrintListElements(const List& list) {
    for (int i = 0; i < list.Size(); i++) {
        cout << list[i] << " ";
    }
}

int main()
{
    List l1, l2;
    l1.Append(2);
    l1.Append(7);
    l1.Append(-3);
    l1.Append(4);
    cout << l1 << endl;
    try
    {
    cout<< l1[1] << endl;
    }
    catch(const exception& e)
    {
        cout << e.what() << endl;
    }
    cin >> l2;
    l1 = l2;
    cout << l1;

    return 0;
}
