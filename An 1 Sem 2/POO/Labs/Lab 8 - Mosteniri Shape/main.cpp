#include <iostream>
#include <vector>

using namespace std;

class Shape{
public:
    virtual int Perimeter() const = 0;
};

class Triangle : public Shape {
    int side1;
    int side2;
    int base;
public:
    Triangle(int s1, int s2, int b) : side1(s1), side2(s2), base(b) { }

    int Perimeter() const { return side1 + side2 + base; }
};

class Rectangle : public Shape{
    int width;
    int length;
public:
    Rectangle(int w, int l) : width(w), length(l) {}

    int Perimeter() const { return 2 * (width + length); }
};

int main()
{
    Rectangle r(5, 10);
    Triangle t(2, 5, 4);
    cout << r.Perimeter() << endl;
    cout << t.Perimeter() << endl;
    cout << endl;
    vector <int> v;
    v.push_back(3);
    int b = 5;
    v.push_back(b);

    /*vector <Rectangle> rectangles;
    rectangles.push_back(r);*/

    vector <Shape *> shapes;
    shapes.push_back(&r);
    shapes.push_back(&t);

    for (int i = 0; i < shapes.size(); i++)
    {
        cout << shapes[i]->Perimeter() <<endl;
    }
    cout << endl;
     // SAU
    for(vector<Shape*>::const_iterator iterator = shapes.begin(); iterator != shapes.end(); iterator++ )
    {
        cout << (*iterator)->Perimeter() << endl;
    }
    cout << endl;
    // sau for(auto iterator = shapes.begin())
    return 0;
}
