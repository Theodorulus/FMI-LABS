#include <iostream>
#include <sstream>
#include <stdlib.h>
#include <vector>

using namespace std;

struct Data
{
    int zi_, luna_, an_;
    Data(int zi, int luna, int an) : zi_(zi), luna_(luna), an_(an) {}
    string to_string()
    {
        stringstream zi, luna, an;
        string str, str_zi, str_luna, str_an;
        zi << zi_;
        str_zi = zi.str();
        luna << luna_;
        str_luna = luna.str();
        an << an_;
        str_an = an.str();
        if(zi_ < 10)
            str_zi = "0" + str_zi;
        if(luna_ < 10)
            str_luna = "0" + str_luna;
        str = str_zi + "." + str_luna + "." + str_an;
        return str;
    }
};

ostream& operator<<(ostream& out, const Data data)
{
    out << data.zi_ << '.' << data.luna_ << '.' << data.an_;
    return out;
}

bool operator ==(Data d1, Data d2)
{
    if(d1.zi_ == d2.zi_ && d1.luna_ == d2.luna_ && d1.an_ == d2.an_)
        return 1;
    return 0;
}

bool operator !=(Data d1, Data d2)
{
    return !(d1 == d2);
}

struct Ora
{
    int ora_, min_;
    Ora(int ora, int min) : ora_(ora), min_(min) {}
    string to_string()
    {
        stringstream ora, min;
        string str, str_ora, str_min;
        ora << ora_;
        str_ora = ora.str();
        min << min_;
        str_min = min.str();
        if(ora_ < 10)
            str_ora = "0" + str_ora;
        if(min_ < 10)
            str_min = "0" + str_min;
        str = str_ora + ":" + str_min;
        return str;
    }
};

ostream& operator<<(ostream& out, const Ora ora)
{
    out << ora.ora_ << ':' << ora.min_ ;
    return out;
}

bool operator ==(Ora o1, Ora o2)
{
    if(o1.ora_ == o2.ora_ && o1.min_ == o2.min_)
        return 1;
    return 0;
}

bool operator !=(Ora o1, Ora o2)
{
    return !(o1 == o2);
}

class Bilet
{
protected:
    string plecare_;
    string sosire_;
    string serie_;
    string id_tren_;
    Data data_;
    Ora ora_;
    int durata_;
    int distanta_;
    float pret_;
    bool cls1_;
    static int nr_;
public:
    Bilet(string plecare, string sosire, Data data, Ora ora, int durata, int distanta, bool cls1) : plecare_(plecare), sosire_(sosire), data_(data), ora_(ora), durata_(durata), distanta_(distanta), cls1_(cls1)
    {
        nr_++;
        stringstream ss;
        ss << nr_;
        string str = ss.str();
        if(cls1)
            serie_ ="I-" + str;
        else
            serie_ = "II-" + str;
        id_tren_ = plecare_ + "-" + sosire_ + "-" + data_.to_string() + "-" + ora_.to_string();
    }
    string Train_Id()
    {
        return id_tren_;
    }
    string serie()
    {
        return serie_;
    }
    bool dist_mai_mare(int val)
    {
        if(distanta_ > val)
            return 1;
        return 0;
    }
    friend ostream& operator<<(ostream& out, const Bilet b);
};

ostream& operator<<(ostream& out, const Bilet b)
{
    out << b.serie_;
    return out;
}


class InterRegio : public Bilet
{
public:
    InterRegio(string plecare, string sosire, Data data, Ora ora, int durata, int distanta, bool cls1) : Bilet(plecare, sosire, data, ora, durata, distanta, cls1)
    {
        serie_ = "IR" + serie_;

        pret_ = 0.7 * distanta_;
        if(cls1)
            pret_ = pret_ * 1.2;
        //cout << serie_ << ' ' << pret_ << endl;
        id_tren_ = "IR-" + id_tren_;
    }
};

class Regio : public Bilet
{
public:
    Regio(string plecare, string sosire, Data data, Ora ora, int durata, int distanta, bool cls1) : Bilet(plecare, sosire, data, ora, durata, distanta, cls1)
    {
        serie_ = "R" + serie_;
        pret_ = 0.39 * distanta_;
        if(cls1)
            pret_ = pret_ * 1.2;
        //cout << serie_ << ' ' << pret_ << endl;
        id_tren_ = "R-" + id_tren_;
    }
};

/*class Tren
{
    string id_;
    string plecare_;
    string sosire_;
    Data data_;
    Ora ora_;
    vector <Bilet> bilete_;
public:
    Tren(string plecare, string sosire, Data data, Ora ora) : plecare_(plecare), sosire_(sosire), data_(data), ora_(ora)
    {
        id_ = plecare_ + "-" + sosire_ + "-" + data_.to_string() + "-" + ora_.to_string();
        cout << id_ << endl;
    }
};*/

int Bilet::nr_ = 0;

int main()
{
    Data d(20, 05, 2019);
    Ora o(18, 50);
    Regio b("Buzau", "Bucuresti", d, o, 120, 100, 1);
    cout << b;
    /*vector<Bilet> bilete;
    cout << "Introduceti detaliile biletelor.\n";
    char c;
    while(c != '0')
    {
        cout << "Ce fel de bilet doriti?(Regio = R, InterRegio = I). Daca ati introdus toate biletele introduceti valoarea 0.\n";
        cin >> c;
        if(c == '0')
            break;
        else
            if(c != 'R' && c != 'I')
                cout << "Ati introdus o valoare gresita.\n";
            else
                if(c == 'R')
                {
                    string plecare, sosire;
                    int durata, distanta, zi, luna, an, o, m;
                    bool cls1;
                    cout << "Care este statia de plecare? ";
                    cin >> plecare;
                    cout << "Care este statia de sosire? ";
                    cin >> sosire;
                    cout << "Care este data plecarii?(Formatul dd mm aaaa) ";
                    cin >> zi >> luna >> an;
                    Data data(zi, luna, an);
                    cout << "Care este ora plecarii?(Formatul hh mm) ";
                    cin >> o >> m;
                    Ora ora(o, m);
                    cout << "Care este durata calatoriei?(min) ";
                    cin >> durata;
                    cout << "Care este distanta parcursa?(km) ";
                    cin >> distanta;
                    cout << "Doriti bilet la clasa I? (1 pentru da, 0 pentru nu) ";
                    cin >> cls1;
                    Regio b(plecare, sosire, data, ora, durata, distanta, cls1);
                    bilete.push_back(b);
                }
                else
                {
                    string plecare, sosire;
                    int durata, distanta, zi, luna, an, o, m;
                    bool cls1;
                    cout << "Care este statia de plecare? ";
                    cin >> plecare;
                    cout << "Care este statia de sosire? ";
                    cin >> sosire;
                    cout << "Care este data plecarii?(Formatul dd mm aaaa) ";
                    cin >> zi >> luna >> an;
                    Data data(zi, luna, an);
                    cout << "Care este ora plecarii?(Formatul hh mm) ";
                    cin >> o >> m;
                    Ora ora(o, m);
                    cout << "Care este durata calatoriei?(min) ";
                    cin >> durata;
                    cout << "Care este distanta parcursa?(km) ";
                    cin >> distanta;
                    cout << "Doriti bilet la clasa I? (1 pentru da, 0 pentru nu) ";
                    cin >> cls1;
                    InterRegio b(plecare, sosire, data, ora, durata, distanta, cls1);
                    bilete.push_back(b);
                }
    }
    cout << "\nCare este codul trenului pentru care doriti listarea biletelor?(Codul trenului este de forma 'IR/R-Statire plecare-Statie sosire-data(formatul dd.mm.aaaa)-ora(formatul hh:mm)')\n";
    string cod;
    cin >> cod;
    for(int i = 0; i < bilete.size(); i++)
        if(bilete[i].Train_Id() == cod)
            cout << bilete[i].serie() << ' ';
    cout << endl;
    cout << "\nCare este valoarea data?\n";
    int val;
    cin >> val;
    for(int i = 0; i < bilete.size(); i++)
        if(bilete[i].dist_mai_mare(val))
            cout << bilete[i].serie() << ' ';
    cout << "\nCare este seria biletului pe care doriti sa-l anulati?";
    string serie;
    int indice = -1;
    cin >> serie;
    for(int i = 0; i < bilete.size() && indice == -1; i++)
        if(bilete[i].serie() == serie)
            indice = i;
    if(indice != -1)
        bilete.erase (bilete.begin() + indice);
    else
        cout << "Nu exista niciun bilet cu seria mentionata.";
    for(int i = 0; i < bilete.size(); i++)
        cout << bilete[i].serie() << ' ';*/
    return 0;
}

/*
I Buzau Bucuresti 26 05 2020 15 01 120 100 1
I Buzau Bucuresti 26 05 2020 15 01 120 100 1
I Buzau Bucuresti 26 05 2020 15 01 120 100 1
R Buzau Bucuresti 26 05 2020 15 01 120 100 1
R Buzau Bucuresti 26 05 2020 15 01 15 100 1
I Buzau Bucuresti 26 05 2020 15 01 120 100 1
I Buzau Bucuresti 26 05 2020 15 01 120 100 1
0
IR-Buzau-Bucuresti-26.05.2020-15:01
99
IRI-2
*/
