#include <iostream>
#include <string>
#include <vector>

using namespace std;

class Shape {
    string name_;
    protected:
    Shape(string name) : name_(name) { }
    public:
    string name() const { return name_; }
    virtual int Perimeter() const = 0;
};

class Triangle: public Shape {
    int side1_;
    int side2_;
    int base_;
    public:
    Triangle(int side1, int side2, int base) : Shape("Triangle"), side1_(side1), side2_(side2), base_(base) { }

    int Perimeter() const { return side1_ + side2_ + base_; }
};

class Rectangle: public Shape {
    int width_;
    int length_;
    // static int instance_count;
    public:
    Rectangle(int width, int length) : Shape("Rectangle"), width_(width), length_(length) { }

    int Perimeter() const { return 2 * (width_ + length_); }
};

int main() {
    // Shape s(); // ??

    Rectangle r(5, 10);
    cout << r.Perimeter();

    Triangle t(2, 5, 4);
    cout << t.Perimeter();

    vector<int> v;
    v.push_back(3);
    int b = 5;
    v.push_back(b);

    // vector<Rectangle> rectangles;
    // rectangles.push_back(r);

    Shape **shapes = new Shape*[10];
    shape[0] = &r;
    shape[1] = &t;

    vector<Shape *> shapes;
    shapes.push_back(&r);
    shapes.push_back(&t);

    for (int i = 0; i < shapes.size(); i++) {
        cout << shapes[i]->name() << " " << shapes[i]->Perimeter();
    }

    for (vector<Shape *>::const_iterator iterator = shapes.begin(); iterator != shapes.end(); ++iterator) {
        cout << (*iterator)->Perimeter();
    }
}
