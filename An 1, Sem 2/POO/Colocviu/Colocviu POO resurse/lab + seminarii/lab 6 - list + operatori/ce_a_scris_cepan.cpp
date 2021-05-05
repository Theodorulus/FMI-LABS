/*
class List:
Clear
Append
InsertAt
Empty
Size
etc.
 */

// 1->2->3->4
// [1, 2, 3, 4, 5, .... 100 ]

#include <cassert>
#include <stdexcept>

using namespace std;

class List {
    struct Node {
        Node(int v) : value(v), next(NULL) { }
        int value;
        Node* next;
    };

    Node* head_;
    Node* tail_;

    void Clear() {
        if (head_ == NULL) {
            return;
        }

        Node* node = head_;
        Node* p;
        do {
            p = node;
            node = node->next;
            delete p;
        } while (node != NULL);

        head_ = NULL;
        tail_ = NULL;
    }

    public:

    List() : head_(NULL), tail_(NULL) { }
    ~List() {
        Clear();
    }

    void Append(int value) {
        Node* node = new Node(value);

        if (tail_ != NULL) {
            tail_->next = node;
        } else {
            assert(head_ == NULL);
            head_ = node;
        }

        tail_ = node;
    }

    int Size() const {
        int size = 0;
        Node* node = head_;
        while (node != NULL) {
            ++size;
            node = node->next;
        }
        return size;
    }

    const int& operator[](int pos) const {
        Node* node = head_;
        while (node != NULL && pos > 0) {
            --pos;
            node = node->next;
        }

        if (node == NULL) {
            throw std::out_of_range("index out of range");
        }

        return node->value;
    }

    List& operator=(const List& other) {
        if (&other != this) {
            Clear();

            Node* node_other = other.head_;
            if (node_other != NULL) {
                head_ = new Node(node_other->value);
                tail_ = head_;

                node_other = node_other->next;
                while (node_other != NULL) {
                    Node* node = new Node(node_other->value);
                    tail_->next = node;
                    tail_ = node;

                    node_other = node_other->next;
                }
            }

            // sau apelez Append in mod repetat cu valori din other
        }

        return *this;
    }

    friend ostream& operator<<(ostream& out, const List& l);
    friend istream& operator>>(istream& in, List&);
};

ostream& operator<<(ostream& out, const List& l) {
    List::Node* node = l.head_;
    while (node != NULL) {
        out << node->value << " ";
        node = node->next;
    }
    return out;
}

istream& operator>>(istream& in, List& list) {
    list.Clear();
    int size;
    in >> size;
    int value;
    while (size > 0) {
        in >> value;
        list.Append(value);
        --size;
    }
    return in;
}

// main.cpp

void PrintListElements(const List& list) {
    for (int i = 0; i < list.Size(); i++) {
        cout << list[i] << " ";
    }
}

int main() {
    List l1;
    l1.Append(2);
    l1.Append(7);
    l1.Append(-3);
    l1.Append(4);
    cout << l1 << endl; // 2 7 -3 4
    try {
        cout << "elem pos 1: " << l1[100] << endl; // 7
    } catch(const exception& e) {
        cout << e.what() << endl;
    }

    List l2;
    cin >> l1;
    cout << l1;

    l2 = l1;
    l1.Append(10);
    cout << l2; // la fel ca la linia 162

}
