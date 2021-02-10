#include <stdio.h>

/* Mailul de la facultate */
char *email = "alexandru.tudorache@s.unibuc.ro";

void subiect()
{
    int i = 0;
    int suma = 0;
    while ('\0' != email[i])
    {
        suma = suma + (email[i] % 4);
        i++;
    }
    suma = suma % 4;
    switch (suma)
    {
    case 0:
        puts("Trebuie sa fac lab 5, Ex 2");
        break;
    case 1:
        puts("Trebuie sa fac lab 6, Ex 2");
        break;
    case 2:
        puts("Trebuie sa fac lab 7, Ex 1");
        break;
    case 3:
        puts("Trebuie sa fac lab 7, Ex 2");
        break;
    default:
        puts("Oricare din cele de mai sus");
        break;
    }
}

int main(int argc, char *argv[])
{
    subiect();
    return 0;
}
