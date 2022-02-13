/* Tudorache Alexandru-Theodor 142
Code::Blocks (mingw32-g++)
Liviu Cepan*/


#include <iostream>
#include <cstdlib>
#include <vector>

using namespace std;

class Masca
{
protected:
    string tip_protectie_;
    Masca():tip_protectie_("ffp1"){}
    Masca(string tip_protectie):tip_protectie_(tip_protectie){}
    virtual float pret() = 0; // pretul trebuie sa fie float deoarece daca se cumpara o masca personalizata si pretul normal este 5 sau 15, atunci pret nu va mai fi nr. intreg
};

class MascaChirugicala : public Masca
{
    string culoare_;
    string personalizare_;
    int nr_pliuri_;
public:
    MascaChirugicala();
    MascaChirugicala(string, string, int, string);
    MascaChirugicala(const MascaChirugicala& mc);
    MascaChirugicala operator=(MascaChirugicala mc);
    friend ostream& operator<<(ostream& out, const MascaChirugicala mc);
    friend istream& operator>>(istream& in, MascaChirugicala& mc);
    float pret();
};

MascaChirugicala::MascaChirugicala(string tip_protectie, string culoare, int nr_pliuri, string personalizare = "") : Masca(tip_protectie), culoare_(culoare), nr_pliuri_(nr_pliuri), personalizare_(personalizare)
{

}

MascaChirugicala::MascaChirugicala() : Masca("ffp1"), culoare_("alb"), nr_pliuri_(3)
{

}

MascaChirugicala::MascaChirugicala(const MascaChirugicala& mc)
{
    tip_protectie_ = mc.tip_protectie_;
    culoare_ = mc.culoare_;
    nr_pliuri_ = mc.nr_pliuri_;
}

MascaChirugicala MascaChirugicala::operator=(MascaChirugicala mc)
{
    tip_protectie_ = mc.tip_protectie_;
    culoare_ = mc.culoare_;
    nr_pliuri_ = mc.nr_pliuri_;
    return *this;
}

ostream& operator<<(ostream& out, const MascaChirugicala mc) {
    out << mc.tip_protectie_ << ' ' << mc.culoare_ << ' ' << mc.nr_pliuri_;
    return out;
}

istream& operator>>(istream& in, MascaChirugicala& mc) {
    in >> mc.tip_protectie_;
    in >> mc.culoare_;
    in >> mc.nr_pliuri_;
    return in;
}

float MascaChirugicala::pret()
{
    float pret;
    if(tip_protectie_ == "ffp1")
        pret = 5;
    else if(tip_protectie_ == "ffp2")
            pret = 10;
        else
            pret = 15;
    if(personalizare_ != "")
        pret = pret * 1.5;
    return pret;
}

class MascaPolicarbonat : public Masca
{
    string tip_prindere_;
public:
    MascaPolicarbonat();
    MascaPolicarbonat(string tip_prindere);
    friend ostream& operator<<(ostream& out, const MascaPolicarbonat mc);
    friend istream& operator>>(istream& in, MascaPolicarbonat& mc);
    float pret();
};

MascaPolicarbonat::MascaPolicarbonat():Masca("ffp0"), tip_prindere_("elastic")
{

}

MascaPolicarbonat::MascaPolicarbonat(string tip_prindere):Masca("ffp0"), tip_prindere_(tip_prindere)
{

}

ostream& operator<<(ostream& out, const MascaPolicarbonat mc)
{
    out << mc.tip_protectie_ << ' ' << mc.tip_prindere_;
    return out;
}

istream& operator>>(istream& in, MascaPolicarbonat& mc) {
    in >> mc.tip_prindere_;
    return in;
}

float MascaPolicarbonat::pret()
{
    return 20;
}

class Dezinfectant
{
protected:
    long specii_ucise_;
    vector<string> ingrediente_;
    vector<string> suprafete_;
public:
    Dezinfectant(long specii_ucise, vector<string>ingrediente, vector<string>suprafete);
    virtual float eficienta() = 0;
    int pret();
};

int Dezinfectant::pret()
{
    if(eficienta() < 0.9)
        return 10;
    else if(eficienta() < 0.95)
            return 20;
    else if(eficienta() < 0.975)
            return 30;
    else if(eficienta() < 0.99)
            return 40;
    else if(eficienta() < 0.9999)
            return 50;
}

Dezinfectant::Dezinfectant(long specii_ucise, vector<string>ingrediente, vector<string>suprafete) : specii_ucise_(specii_ucise)
{
    for(int i = 0; i < ingrediente.size(); i++)
        ingrediente_.push_back(ingrediente[i]);
    for(int i = 0; i < suprafete.size(); i++)
        suprafete_.push_back(suprafete[i]);
}

class DezinfectantBacterii : public Dezinfectant
{
public:
    DezinfectantBacterii(long specii_ucise, vector<string>ingrediente, vector<string>suprafete):Dezinfectant(specii_ucise, ingrediente, suprafete){}
    float eficienta();
};

float DezinfectantBacterii::eficienta()
{
    long total = 1;
    for(int i = 1; i <= 9; i++)
        total *= 10;
    return (float)specii_ucise_/total;
}

class DezinfectantFungi : public Dezinfectant
{
public:
    DezinfectantFungi(long specii_ucise, vector<string>ingrediente, vector<string>suprafete):Dezinfectant(specii_ucise, ingrediente, suprafete){}
    float eficienta();
};

float DezinfectantFungi::eficienta()
{
    long total = 1.5;
    for(int i = 1; i <= 6; i++)
        total *= 10;
    return (float)specii_ucise_/total;
}

class DezinfectantVirusuri : public Dezinfectant
{
public:
    DezinfectantVirusuri(long specii_ucise, vector<string>ingrediente, vector<string>suprafete):Dezinfectant(specii_ucise, ingrediente, suprafete){}
    float eficienta();
};

float DezinfectantVirusuri::eficienta()
{
    long total = 1;
    for(int i = 1; i <= 8; i++)
        total *= 10;
    return (float)specii_ucise_/total;
}

class Achizitie
{
    int zi_, luna_, an_;
    string client_;
    vector<Dezinfectant*> dezinfectanti_;
    vector<Masca*> masti_;
public:
    Achizitie();
    Achizitie(int, int, int, string);
    Achizitie(const Achizitie& a);
    Achizitie operator=(Achizitie a);
    Achizitie operator+=(Masca* m);
    Achizitie operator+=(Dezinfectant* d);
    float total();
    string nume();
};

Achizitie::Achizitie() : zi_(1), luna_(1), an_(2020), client_("Random client"){}

Achizitie::Achizitie(int zi, int luna, int an, string client) : zi_(zi), luna_(luna), an_(an), client_(client){}

Achizitie::Achizitie(const Achizitie& a) : zi_(a.zi_), luna_(a.luna_), an_(a.an_), client_(a.client_)
{
    /*for(int i = 0; i < a.dezinfectanti_.size() ; i++)
        dezinfectanti_[i] = a.dezinfectanti_[i];
    for(int i = 0; i < a.masti_.size() ; i++)
        masti_[i] = a.masti_[i];*/
}

Achizitie Achizitie::operator=(Achizitie a)
{
    zi_ = a.zi_;
    luna_ = a.luna_;
    an_ = a.an_;
    client_ = a.client_;
    for(int i = 0; i < a.dezinfectanti_.size() ; i++)
        dezinfectanti_[i] = a.dezinfectanti_[i];
    for(int i = 0; i < a.masti_.size() ; i++)
        masti_[i] = a.masti_[i];
    return *this;
}

Achizitie Achizitie::operator+=(Masca* m)
{
    masti_.push_back(m);
    return *this;
}

Achizitie Achizitie::operator+=(Dezinfectant* d)
{
    dezinfectanti_.push_back(d);
    return *this;
}

float Achizitie::total()
{
    /*float sum = 0;
    for(int i = 0; i < dezinfectanti_.size() ; i++)
        sum += dezinfectanti_[i].pret();
    for(int i = 0; i < masti_.size() ; i++)
        sum += masti_[i].pret();
    return sum;*/
}

string Achizitie::nume()
{
    return client_;
}

int main()
{

    MascaChirugicala mc1, mc2("ffp2", "verde brotacel", 55), mc3(mc1), mc4, mc5;
    mc4 = mc2;
    //std::cin >> mc5;
    std::cout << mc1 << ' ' << mc2 << endl;
    MascaPolicarbonat* mp1=new MascaPolicarbonat(), * mp2=new MascaPolicarbonat();
    //MascaPolicarbonat mp1, mp2;
    MascaPolicarbonat* mp3 = new MascaPolicarbonat("elastic");
    //std::cin >> *mp1 >> *mp2;
    std::cout << *mp3 << endl;
    //Dezinfectant* d1 = new DezinfectantBacterii(100000000, std::vector<string>({"sulfati non-ionici", "sulfati cationici", "parfumuri", "Linalool", "Metilpropanol butilpentil"}),std::vector<string>({"lemn, sticla, metal, ceramica, marmura"}));
    vector<string> v1;
    v1.push_back("sulfati non-ionici");v1.push_back("sulfati cationici");v1.push_back("parfumuri");v1.push_back("Linalool");v1.push_back("Metilpropanol butilpentil");
    vector<string> v2;
    v2.push_back("lemn");v2.push_back("sticla");v2.push_back("metal");v2.push_back("ceramica");v2.push_back("marmura");
    Dezinfectant* d1 = new DezinfectantBacterii(100000000, v1, v2);

    v1.clear();
    v2.clear();
    v1.push_back("Alkil");v1.push_back("Dimetilm");v1.push_back("Benzil");v1.push_back("Clorura de amoniu");v1.push_back("parfumuri");v1.push_back("Butilpentil metilpropinal");
    v2.push_back("lemn");v2.push_back("sticla");v2.push_back("ceramica");v2.push_back("marmura");
    Dezinfectant* d2 = new DezinfectantVirusuri(50000000, v1, v2);

    v1.clear();
    v2.clear();
    v1.push_back("Alkil");v1.push_back("Etil");v1.push_back("Benzil");v1.push_back("Clorura de amoniu");v1.push_back("parfumuri");v1.push_back("Butilpentil metilpropinal");
    v2.push_back("sticla");v2.push_back("plastic");
    Dezinfectant* d3 = new DezinfectantFungi(1400000, v1, v2);

    std::cout << d1->eficienta() << " " << d2->eficienta() << " " << d3->eficienta() << "\n";
    Achizitie* a1 = new Achizitie(26, 5, 2020, "PlushBio SRL");
    *a1 += mp1; //se adauga masca de policarbonat mp1 in lista de masti achizitionate
    *a1 += (&mc1); //se adauga masca chirugicala mc1 in lista
    *a1 += d3; // se adauga dezinfectantu de fungi d3 in lista de dezinfectanti achizitionati
    Achizitie* a2 = new Achizitie(25, 5, 2020, "Gucci");
    *a2 += d1;
    *a2 += d2;
    *a2 += d2;
    Achizitie a3, a4(*a1);
    a3 = *a2;
    /*if(*a1 < *a2) {
        std::cout << a1->nume() << " are valoarea facturii mai mica.\n";
    }else if (*a1 == *a2) {
        std::cout << a1->nume() << " si " << a2->nume() << " au aceasi valoare a facturii.\n";
        else {
        std::cout << a2->nume() << " are valoarea facturii mai mica.\n";
    }
    */

    int nr ;
    do
    {
        cout << "Ce operatiune doriti sa efectuati?(0 pentru iesire)\n";
        cin >> nr;
        switch(nr)
        {
        case 1:
        {
            cout << "Ce fel de dezinfectant doriti sa adaugati? (1- Bacterii, 2- Fungi, 3- Virusuri)\n";
            int d;
            cin >> d;
            cout << "Scrieti detaliile dezinfectantului.(nr. specii ucise, nr de ingrediente, ingredientele, nr de suprafete, suprafetele)\n";
            long specii;
            cin >> specii;
            int n;
            vector<string>ingrediente;
            cin >> n;
            for(int i = 0 ; i < n; i++)
            {
                string s;
                cin >> s;
                ingrediente.push_back(s);
            }
            vector<string>suprafete;
            cin >> n;
            for(int i = 0 ; i < n; i++)
            {
                string s;
                cin >> s;
                suprafete.push_back(s);
            }
            Dezinfectant* dez;
            switch(d)
            {
            case 1:
            {
                dez = new DezinfectantBacterii(specii, ingrediente, suprafete);
                break;
            }
            case 2:
            {
                dez = new DezinfectantFungi(specii, ingrediente, suprafete);
                break;
            }
            case 3:
            {
                dez = new DezinfectantVirusuri(specii, ingrediente, suprafete);
                break;
            }
            }
            *a1 += dez;
            break;
        }
        case 2:
        {
        cout << "Ce fel de masca doriti sa adaugati? (1- Chirurgicala, 2- Policarbonat)\n";
        int m;
        cin >> m;

        switch(m)
        {
        case 1:
        {

            string protectie;
            string culoare;
            int pliuri;
            cout << "Scrieti detaliile mastii in aceasta ordine: tipul protectiei, culoarea, nr. de pliuri\n";
            cin >> protectie;
            cin >> culoare;
            cin >> pliuri;
            Masca* masca = new MascaChirugicala(protectie, culoare, pliuri);
            break;
        }
        case 2:
        {
            string prindere;
            cout << "Ce tip de prindere are masca?";
            cin >> prindere;
            Masca* masca = new MascaPolicarbonat(prindere);
        }
        }

        }
    }
}while(nr);


    //string s;
    //getline(cin, s);
    return 0;
}
