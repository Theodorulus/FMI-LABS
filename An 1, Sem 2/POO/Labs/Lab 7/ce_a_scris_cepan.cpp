#include <iostream>
#include <string>

using namespace std;

class Person {
    string name_;
    int age_;
    public:
    Person(const string& name, int age) : name_(name), age_(age) {
        // ...
    }

    virtual void Greet(const Person& other) {
        cout << "Hello " << other.name() << endl;
    }

    void GrowOlder() {
        age_++;
    }

    string name() const { return name_; }
    int age() const { return age_; }

    virtual ~Person() { }

    friend ostream& operator<<(ostream& out, const Person& person) {
        out << "Name: " << person.name_ << "Age: " << person.age_;
        return out;
    }
};

class Employee: public Person {
    long employeeID_;
};

class Student: public Person {
    long studentID_;

    public:
    Student(const string& name, int age, long studentID) : Person(name, age), studentID_(studentID) {
        // ...
    }

    void Greet(const Person& other) {
        cout << "Hey " << other.name() << endl;
    }

    long studentID() const { return studentID_; }

    friend ostream& operator<<(ostream& out, const Student& student) {
        // out << student.name() << student.age()
        out << static_cast<Person>(student) << " ";
        out << "StudentID: " << student.studentID_;
        return out;
    }
};

void Take(Person* p) {
    cout << "I met " << (*p).name() << endl;
    if (Student* s = dynamic_cast<Student*>(p)) {
        cout << "His student ID is " << s->studentID() << endl;
    }
    p->Greet(Person("Liviu", 27));
}

Student* CreateStudent(const string& name, int age, long studentID) {
    return new Student(name, age, studentID);
}


void DeletePerson(Person* person) {
    delete person;
}

int main() {
    string name;
    cout << "Name? ";
    getline(cin, name);
    cout << "Age? ";
    int age;
    cin >> age;

    long studentID;
    cin >> studentID;

    Person p("Georgescu", 19);
    // cout << p.name() << " " << p.age();

    Student s("Popescu", 26, 12345678);
    // cout << s.name() << " " << s.age() << " " << s.studentID();

    p.Greet(s); // Hello s
    s.Greet(p); // Hey p

    cout << s.age() << endl;
    s.GrowOlder();
    cout << s.age() << endl;

    Take(&p);
    Take(&s);

    cout << s;
}
