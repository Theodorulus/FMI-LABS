#include <iostream>
#include <string>

using namespace std;

class Person
{
    string name;
    int age;
public:
    Person (const string& nume, int varsta): name(nume), age(varsta) {}
    string get_name() const {return name;}
    int get_age() const {return age;}
    virtual void Greet(const Person& other)
    {
        cout << "Hello " << other.name << endl;
    }
    void GrowOlder()
    {
        age++;
    }
    /*virtual ~Person()
    {

    }*/
    friend ostream& operator<<(ostream& out, const Person& person);
};

class Student: public Person
{
    long studentID;
public:
    Student(const string& nume, int varsta, long id): Person(nume, varsta), studentID(id) {}
    long get_id() const {return studentID;}
    void Greet(const Person& other)
    {
        cout << "Hey " << other.get_name() << endl;
    }
    friend ostream& operator<<(ostream& out, const Student& stud);
};

class Employee: public Person
{
    long employeeID;
};

ostream& operator<<(ostream& out, const Person& person)
{
    out << "Name: " << person.name << ", Age: " << person.age;
    return out;
}

ostream& operator<<(ostream& out, const Student& stud)
{
    out << static_cast<Person>(stud);
    out << " id: " << stud.studentID;
    return out;
}

void Take(Person* p)
{
    cout << "I met " << p->get_name();
    if(Student* s = dynamic_cast<Student*>(p))
        cout << ". His student ID is " << s->get_id();
    cout << endl;
    p->Greet(Person("Liviu", 27));
}

Student* CreateStudent(const string& name, int age, long studentID)
{
    return new Student(name, age, studentID);
}

void DeletePerson(Person* person)
{
    delete person;
}

int main()
{
    string nume;
    cout << "Nume: ";
    getline (cin, nume);
    cout << "Varsta? ";
    int varsta;
    cin >> varsta;
    Person p(nume, varsta);
    cout << p.get_name() << " " << p.get_age() << endl;
    Student s(nume, varsta, 1);
    s.GrowOlder();
    cout << s.get_name() << " " << s.get_age() << " " << s.get_id() << endl;
    Take(&p);
    Take(&s);
    p.Greet(s);
    s.Greet(p);
    cout << p << endl;
    cout << s << endl;
    return 0;
}
