#include <iostream>

using namespace std;

class ArrayDouble;

class ArrayInt {
  // ArrayInt operator+(ArrayDouble &);
};
class ArrayDouble {
};
// class ArrayPerecheIntDouble {
// };
// class ArrayPerecheDoubleInt {
// };

class Increment {
  public:
  Increment(int num) : num_(num) { }
  int operator()(int x) { return x + num_; }
  private:
  int num_;
};
// functor

template <class T>
class Object {
  public:
  Object(T value) : value_(value) { }

  const T& value() const { return value_; }

  void Apply(void (*func)(T)) {
    func(value_);
  }

  template<class F>
  void Transform(F func) {
    value_ = func(value_);
  }

  template<>
  void Transform<>(Increment inc) {
    cout << "!";
    value_ = inc(value_);
  }
  
  private:
    T value_;
};

// template<>
// class Object {
 
// }

// Object ob;
// ob.value()++;

class IntObject {
  public:
  IntObject(int v) : value(v) { }
  int value;
  void Transform(int (*func)(int)) {
    value = func(value);
  }
};

int increment(int x) { return x + 1; }

void print_increment(int x) { cout << x + 1; }

char * to_upper(char *s) {
  int idx = 0;
  while (s[idx] != '\0') {
    s[idx] -= 32;
    idx++;
  }
  return s;
}

int main() {
  Increment twoIncrementer(2);
  // cout << twoIncrementer(5) << endl;
  // cout << Increment(10)(5) << endl; // 15 

  IntObject obj0(5);
  obj0.Transform(increment);
  cout << obj0.value << endl;

  Object<int> obj1(3);
  obj1.Transform(increment); // 4
  cout << obj1.value() << endl;
  obj1.Transform(twoIncrementer); // 6
  // obj1.Apply(print_increment);
  char string[] = {'h', 'e', 'l', 'l', 'o', '\0'};
  Object<char*> obj2(string);
  obj2.Transform(to_upper);

  cout << obj1.value() << endl;
  cout << obj2.value() << endl;
  // Array<int> l1;
  // Array<double> l2;
}

// template <class T>
// class Array {
//   public:
//   void Add(T value);
// };

// template <class T, class U>
// class ArrayPair {
//   public:
//   void AddPair(T value1, U value2);
// };


/*-comment section-





*/

