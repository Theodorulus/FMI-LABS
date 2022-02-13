 /* Proiect realizat de Burta Mihai, Tudorache Theodor si Zaharia Catalin.

    Am ales sa implementam un monitor pentru a rezolva problema filosofilor la masa.
Aceasta problema spune: La o masa se afla N filosofi, intre fiecare dintre ei fiind cate un tacam,
iar in fata fiecaruia se afla o farfurie cu mancare. Pentru a manca, au nevoie de ambele tacamuri
(tacamul din stanga si cel din dreapta); astfel acestia nu pot manca toti in acelasi timp, asa ca au nevoie
de un mod in care pot manca toti, pe rand.
    Noi am rezolvat problema filosofilor folosind monitoare.

*/
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <ctype.h>
#include <semaphore.h>
#include <time.h>
#include <string.h>

#define N 5
#define REPETARI 1
#define GANDESTE 0
#define FLAMAND 1
#define MANANCA 2
#define STANGA (i+N-1)%N
#define DREAPTA (i+1)%N

//semafoarele pentru a implementa monitorul
sem_t mutex;
sem_t urm;

//variabila care numara cati filosofi asteapta la semafor in continuare
int nr_urm = 0;

//tablou care tine minte de cate ori a mancat fiecare filosof
int timesEaten[100] = {0};

//implementam o variabila conditionala folosind un semafor
//semaforul si variabila int inlocuiesc variabila conditionala
typedef struct
{
	sem_t sem;
	//variabila count pentru filosofi care asteapta conditia sem
	int count;
}conditie;
conditie x[N];

//starea fiecarui filosof (GANDESTE, FLAMAND, MANANCA)
int stare[N];

//variabila orientare corespunde fiecarui chopstick
//daca filosoful i vrea sa manance, atunci orientare[i] si orientare[STANGA] trebuie sa fie i
//(adica sa fie "indreptate" catre filosoful i)
int orientare[N];

//asteapta conditia
void asteapta(int i)
{
	x[i].count++;
	if(nr_urm > 0)
	{
		//anuntam semaforul urm
		sem_post(&urm);
	}
	else
	{
		//anuntam semaforul mutex
		sem_post(&mutex);
	}
	sem_wait(&x[i].sem);
	x[i].count--;
}

//semnal pentru conditie
void anunta(int i)
{
	if(x[i].count > 0)
	{
		nr_urm++;
		//anuntam semaforul x[i].sem
		sem_post(&x[i].sem);
		//asteptam semaforul urm
		sem_wait(&urm);
		nr_urm--;
	}
}

//testam daca filosoful i poate manca
void testeaza(int i)
{
	if(stare[i] == FLAMAND && stare[STANGA] != MANANCA && stare[DREAPTA] != MANANCA && orientare[i] == i && orientare[STANGA] == i)
	{
		stare[i] = MANANCA;

		//anuntam atunci cand se indeplineste conditia
		anunta(i);
	}
}

//filosoful i ridica tacamurile
void ridica_tacamuri(int i)
{
	//asteptam semaforul mutex
	sem_wait(&mutex);
	stare[i] = FLAMAND;
	testeaza(i);
	while(stare[i] == FLAMAND)
	{
		//printf("\t [Debug] \t Thread %d asteapta conditia.\n",i);

		//asteptam conditia
		asteapta(i);
	}
	if(nr_urm > 0)
	{
		//anuntam semaforul urm
		sem_post(&urm);
	}
	else
	{
		//anuntam semaforul mutex
		sem_post(&mutex);
	}
}

//filosoful i pune jos tacamurile
void lasa_tacamuri(int i)
{
	//asteptam semaforul mutex
	sem_wait(&mutex);
	stare[i] = GANDESTE;
	//setam variabila orientare sa indice catre filosofii din stanga (STANGA) si din dreapta (DREAPTA)
	orientare[i] = DREAPTA;
	orientare[STANGA] = STANGA;

	printf("[F%d,St%d,Dr%d] \t Filosoful %d  i-a dat filosofului %d tacamul din stanga, iar filosofului %d tacamul din dreapta. \n", i, orientare[i], orientare[STANGA], i, orientare[i], orientare[STANGA]);

	testeaza(STANGA);
	testeaza(DREAPTA);

	if(nr_urm > 0)
	{
		//anuntam semaforul urm
		sem_post(&urm);
	}
	else
	{
		//anuntam semaforul mutex
		sem_post(&mutex);
	}
}

void initializeaza()
{
	int i;
	int k;
	int cnt;
	sem_init(&mutex,0,1);
	sem_init(&urm,0,0);
	for(i = 0;i < N;i++)
	{
		stare[i] = GANDESTE;
		sem_init(&x[i].sem, 0, 0);
		x[i].count = 0;
		orientare[i] = i;
	}
	//Pentru 7 filosofi: setam variabilele orientare astfel incat filosofii 0, 2 si 4 sa poata lua imediat chopstick-urile
	/*
	orientare[1] = 2;
	orientare[3] = 4;
	orientare[6] = 0;
    */

    //Pentru 9 filosofi: setam variabilele orientare astfel incat filosofii 0, 2, 4 si 6 sa poata lua imediat chopstick-urile
	/*
	orientare[1] = 2;
	orientare[3] = 4;
	orientare[5] = 6;
	orientare[8] = 0;
    */

    //Pentru 11 filosofi: setam variabilele orientare astfel incat filosofii 0, 2, 4, 6 si 8 sa poata lua imediat chopstick-urile
	/*
	orientare[1] = 2;
	orientare[3] = 4;
	orientare[5] = 6;
	orientare[7] = 8;
	orientare[10] = 0;
    */

    cnt = 1;
    for(i=1;i<N && cnt<(N/2);i+=2)
    {
        orientare[i] = i+1;
        cnt++;
    }
    orientare[N-1] = 0;

    /*
    for(i = 0;i < N;i++)
	{
		printf("\t [Debug] \t orientare[%d] : %d \n", i, orientare[i]);
	}
    printf("\n");
    */

    //Bucata de cod de mai jos randomizeaza orientarile tacamurilor
    /*
    srand(time(NULL));
    for(i=0;i<N;i++)
    {
        k = giveRandom(1,N);
        while(k == i)
            k = giveRandom(1,N);
        orientare[i] = k;
    }
    */
}

int giveRandom(int lower, int upper)
{
    int num = (rand() % (upper - lower + 1)) + lower;
    return num;
}

void *filosof(void *i)
{
    int cnt = 0;
	while(cnt <= REPETARI)
	{
		//variabila ce reprezinta filosoful
		int self = *(int *) i;
		int j, k;

		//j = rand();
		//j = j % 11;
		j = giveRandom(1,5);
		printf("[Gnd/%d] \t Filosoful %d se gandeste sa manance, timp de %d secunde\n",self,self,j);
		//sleep(j);
		//filosoful ia chopstick-urile
		ridica_tacamuri(self);
		//k = rand();
		//k = k % 4;
		k = giveRandom(1,5);
		printf("[Mnc/%d] \t Filosoful %d mananca, timp de %d secunde\n",self,self,k);
		timesEaten[self]++;
		//sleep(k);
		//filosoful pune jos chopstick-urile
		lasa_tacamuri(self);
		cnt++;
	}
}

int main()
{
	int i, poz[N];
	//cate un thread pentru fiecare filosof
	pthread_t thread[N];
	pthread_attr_t attr;

	srand(time(NULL));

	//initializam semaforul si celelalte variabile
	initializeaza();

	//pthread_attr_init(&attr);

	for (i = 0; i < N; i++)
	{
	    poz[i] = i;
		//pornim un cate thread pentru fiecare filosof
		pthread_create(&thread[i], NULL, filosof, (int *) &poz[i]);
	}

	for (i = 0; i < N; i++)
	{
	    //dam join la threaduri
		pthread_join(thread[i], NULL);
	}

    /*
    printf("\n");
	for(i = 0;i < N;i++)
	{
		printf("\t [Debug] \t orientare[%d] : %d \n", i, orientare[i]);
	}
    printf("\n");
    */

    printf("\n");
    for(i=0;i<N;i++)
        printf("Filosoful %d a mancat de %d ori.\n", i, timesEaten[i]);

	return 0;
}
