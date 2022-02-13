
#include <iostream>
#include <string>
#include <cstring>

using namespace std;

class Base {
  public:
  Base() { value = 0; }
  int value;
};

class A: virtual public Base {

};

class B: virtual public Base {
  public:
  void printValue() {
    cout << value;
  }
};

class IPrintable {
  public:
  virtual void Print(ostream &) const = 0;

  virtual ~IPrintable() { }
};

class IIntAdding {
  public:
  virtual void Add(int x) = 0;

  virtual ~IIntAdding() { } 
};

class C: public A, public B, public IPrintable, public IIntAdding {
  public:
  void Print(ostream& os) const {
    os << value;
  }

  void Add(int x) {
    value += x;
  }
};

void PrintToConsole(const IPrintable& printable) {
  cout << "Printing ";
  printable.Print(cout);
  cout << endl;
}

class SomeObject: public IPrintable {
  public:
  void Print(ostream& os) const {
    os << "SomeObject";
  }
};

int main() {
  C c;
  // c.A::value = 3;
  // // c.printValue();
  // cout << c.B::value;
  c.value = 4;
  // cout << c.value;
  PrintToConsole(c);
  PrintToConsole(SomeObject());

  IIntAdding& alias_c = c;
  alias_c.Add(5);

  cout << c.value;

  return 0;
}


// // // forward declarations
// // template<class T>
// // class Object;
// // template<class T>
// // istream& operator>>(istream& is, Object<T>& object);

// template<class T>
// class Comparator {
//   public:
//   bool operator()(T a, T b) {
//     return a == b;
//   }
// };

// template<>
// class Comparator<int> {
//   public:
//   bool operator()(int a, int b) {
//     return (a % 2) != (b % 2);
//   }
// };

// class StrCmp {
//   public:
//   bool operator()(char *a, char *b) {
//     return strcmp(a, b) == 0;
//   }
// };

// template<class T, class C = Comparator<T>>
// class Object {
//   T value_;
//   public:
//   /*explicit*/ Object(T value) : value_(value) { }
//   T value() const { return value_; }

//   bool IsEqual(Object other) {
//     C comp;
//     return comp(value_, other.value_);
//   }

//   friend istream& operator>>(istream& is, Object& object) {
//     is >> object.value_;
//     return is;
//   }
  
//   // template<class U>
//   // friend istream& operator>>(istream& is, Object<U>& object);
//     // friend istream& operator>> <>(istream& is, Object<T>& object);

//     void Adding(Object other) {
//       value_ += other.value_;
//     }    
// };

// // template<class T>
// // istream& operator>>(istream& is, Object<T>& object) {
// //   // cout << Object<string>("un string").value_ << endl;
// //   is >> object.value_;
// //   return is;
// // }

// template<class T, class C>
// ostream& operator<<(ostream& os, const Object<T, C>& object) {
//   os << object.value();
//   return os;
// }

// // template<>
// // ostream& operator<<(ostream& os, const Object<double>& object) {
// //   os << "val double: " << object.value();
// //   return os;
// // }

// int main() {
//   Object<int> obj(11);
//   // cout << obj.value();
//   // cin >> obj;
//   // obj.Adding(Object<int>(3));
//   // cout << obj << endl;
//   cout << obj.IsEqual(Object<int>(10)) << endl;
//   cout << Object<double>(10.0).IsEqual(Object<double>(10.0)) << endl;
//   char cstring1[] = "abc";
//   char cstring2[] = "abd";
//   cout << Object<char*>(cstring1).IsEqual(Object<char*>(cstring1)) << endl;
//   cout << Object<char*, StrCmp>(cstring1).IsEqual(Object<char*, StrCmp>(cstring2));
// }

// /*

// */




