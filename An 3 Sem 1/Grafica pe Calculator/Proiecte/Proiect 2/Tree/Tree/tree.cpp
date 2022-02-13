// Survolarea unei sfere.
#include <windows.h>  // biblioteci care urmeaza sa fie incluse
#include <stdlib.h> // necesare pentru citirea shader-elor
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <GL/glew.h> // glew apare inainte de freeglut
#include <GL/freeglut.h> // nu trebuie uitat freeglut.h
#include "loadShaders.h"
#include "glm/glm/glm.hpp"  
#include "glm/glm/gtc/matrix_transform.hpp"
#include "glm/glm/gtx/transform.hpp"
#include "glm/glm/gtc/type_ptr.hpp"
using namespace std;

// identificatori 
GLuint
VaoId,
VboId,
EboId,
VBModelMat,
ProgramId,
viewLocation,
projLocation,
codColLocation;

float const PI = 3.141592f;
// Elemente pentru reprezentarea suprafetei
// (1) intervalele pentru parametrii considerati (u si v)
float const U_MIN = -PI * 0.33, U_MAX = PI * 0.5f, V_MIN = PI * 1.4, V_MAX = 1.7 * PI;
// (2) numarul de paralele/meridiane, de fapt numarul de valori ptr parametri
int const NR_PARR = 5, NR_MERID = 6;
// (3) pasul cu care vom incrementa u, respectiv v
float step_u = (U_MAX - U_MIN) / NR_PARR, step_v = (V_MAX - V_MIN) / NR_MERID;


float const U_MIN_CON = -PI, U_MAX_CON = PI, V_MIN_CON = PI * -120, V_MAX_CON = 0 * PI;
// (2) numarul de paralele/meridiane, de fapt numarul de valori ptr parametri
int const NR_PARR_CON = 6, NR_MERID_CON = 5;
// (3) pasul cu care vom incrementa u, respectiv v
float step_u_CON = (U_MAX_CON - U_MIN_CON) / NR_PARR_CON, step_v_CON = (V_MAX_CON - V_MIN_CON) / NR_MERID_CON;


// alte variabile
int codCol;
float radius = 30;
int index, index_aux;

// variabile pentru matricea de vizualizare
float Refx = 0.0f, Refy = 0.0f, Refz = 0.0f;
float alpha = 0.0f, beta = 0.0f, dist = 300.0f;
float Obsx, Obsy, Obsz;
float Vx = 0.0f, Vy = 0.0f, Vz = -1.0f;
float incr_alpha1 = 0.01f, incr_alpha2 = 0.01f;

// variabile pentru matricea de proiectie
float width = 800, height = 600, znear = 1, fov = 30;

// pentru fereastra de vizualizare 
GLint winWidth = 1000, winHeight = 600;

// vectori
glm::vec3 Obs, PctRef, Vert;

// matrice utilizate
glm::mat4 view, projection;

void processNormalKeys(unsigned char key, int x, int y)
{
	switch (key) {
	case '-':
		dist -= 5.0;
		break;
	case '+':
		dist += 5.0;
		break;
	}
	if (key == 27)
		exit(0);
}
void processSpecialKeys(int key, int xx, int yy)
{
	switch (key)
	{
	case GLUT_KEY_LEFT:
		beta -= 0.05f;
		break;
	case GLUT_KEY_RIGHT:
		beta += 0.05f;
		break;
	case GLUT_KEY_UP:
		alpha += incr_alpha1;
		if (abs(alpha - PI / 2) < 0.05)
		{
			incr_alpha1 = 0.f;
		}
		else
		{
			incr_alpha1 = 0.05f;
		}
		break;
	case GLUT_KEY_DOWN:
		alpha -= incr_alpha2;
		if (abs(alpha + PI / 2) < 0.05)
		{
			incr_alpha2 = 0.f;
		}
		else
		{
			incr_alpha2 = 0.05f;
		}
		break;
	}
}

void CreateVBO(void)
{
	// varfurile 
	// (4) Matricele pentru varfuri, culori, indici
	glm::vec4 Vertices[(NR_PARR + 1) * NR_MERID];
	glm::vec3 Colors[(NR_PARR + 1) * NR_MERID];
	GLushort Indices[2 * (NR_PARR + 1) * NR_MERID + 4 * (NR_PARR + 1) * NR_MERID];
	for (int merid = 0; merid < NR_MERID; merid++)
	{
		for (int parr = 0; parr < NR_PARR + 1; parr++)
		{
			// implementarea reprezentarii parametrice 
			float u = U_MIN + parr * step_u; // valori pentru u si v
			float v = V_MIN + merid * step_v;
			float x_vf = radius * cosf(u) * cosf(v); // coordonatele varfului corespunzator lui (u,v)
			float y_vf = radius * cosf(u) * sinf(v);
			float z_vf = radius * sinf(u);
			// identificator ptr varf; coordonate + culoare + indice la parcurgerea meridianelor
			index = merid * (NR_PARR + 1) + parr;
			Vertices[index] = glm::vec4(x_vf, y_vf, z_vf * 2, 1.0);
			Colors[index] = glm::vec3(0.0f, 0.35f, 0.0f);//glm::vec3(0.5f + sinf(u), 0.5f + cosf(v), 0.5f + -1.5 * sinf(u));
			Indices[index] = index;
			// indice ptr acelasi varf la parcurgerea paralelelor
			index_aux = parr * (NR_MERID)+merid;
			Indices[(NR_PARR + 1) * NR_MERID + index_aux] = index;
			// indicii pentru desenarea fetelor, pentru varful curent sunt definite 4 varfuri
			if ((parr + 1) % (NR_PARR + 1) != 0) // varful considerat sa nu fie Polul Nord
			{
				int AUX = 2 * (NR_PARR + 1) * NR_MERID;
				int index1 = index; // varful v considerat
				int index2 = index + (NR_PARR + 1); // dreapta lui v, pe meridianul urmator
				int index3 = index2 + 1;  // dreapta sus fata de v
				int index4 = index + 1;  // deasupra lui v, pe acelasi meridian
				if (merid == NR_MERID - 1)  // la ultimul meridian, trebuie revenit la meridianul initial
				{
					index2 = index2 % (NR_PARR + 1);
					index3 = index3 % (NR_PARR + 1);
				}
				Indices[AUX + 4 * index] = index1;  // unele valori ale lui Indices, corespunzatoare Polului Nord, au valori neadecvate
				Indices[AUX + 4 * index + 1] = index2;
				Indices[AUX + 4 * index + 2] = index3;
				Indices[AUX + 4 * index + 3] = index4;
			}
		}
	};

	glm::mat4 MatModel[20];
	for (int n = 0; n < 20; n++)
	{
		MatModel[n] = glm::translate(glm::mat4(1.0f), glm::vec3(80 * n * sin(10.f * n * 180 / PI), 80 * n * cos(10.f * n * 180 / PI), 0.0)) * glm::rotate(glm::mat4(1.0f), n * PI / 8, glm::vec3(n, 2 * n * n, n / 3));
	}

	// generare VAO/buffere
	glGenBuffers(1, &VboId); // atribute
	glGenBuffers(1, &EboId); // indici
	glGenBuffers(1, &VBModelMat);

	// legare+"incarcare" buffer
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);

	//glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices) + sizeof(Colors), NULL, GL_STATIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, VBModelMat);
	glBufferData(GL_ARRAY_BUFFER, sizeof(MatModel), MatModel, GL_STATIC_DRAW);
	for (int i = 0; i < 4; i++) // Pentru fiecare coloana
	{
		glEnableVertexAttribArray(2 + i);
		glVertexAttribPointer(2 + i,              // Location
			4, GL_FLOAT, GL_FALSE,                // vec4
			sizeof(glm::mat4),                    // Stride
			(void*)(sizeof(glm::vec4) * i));      // Start offset
		glVertexAttribDivisor(2 + i, 1);
	}

	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertices), Vertices);
	glBufferSubData(GL_ARRAY_BUFFER, sizeof(Vertices), sizeof(Colors), Colors);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);

	// atributele; 
	glEnableVertexAttribArray(0); // atributul 0 = pozitie
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
	glEnableVertexAttribArray(1); // atributul 1 = culoare
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)sizeof(Vertices));
}

void CreateVBO2(void)
{
	// CON

	// varfurile 
	// (4) Matricele pentru varfuri, culori, indici
	glm::vec4 Vertices[(NR_PARR_CON + 1) * NR_MERID_CON + 5];
	glm::vec3 Colors[(NR_PARR_CON + 1) * NR_MERID_CON + 5];
	GLushort Indices[2 * (NR_PARR_CON + 1) * NR_MERID_CON + 4 * (NR_PARR_CON + 1) * NR_MERID_CON + 5];
	for (int merid = 0; merid < NR_MERID_CON; merid++)
	{
		for (int parr = 0; parr < NR_PARR_CON + 1; parr++)
		{
			// implementarea reprezentarii parametrice 
			float u = U_MIN_CON + parr * step_u_CON; // valori pentru u si v
			float v = V_MIN_CON + merid * step_v_CON;
			float x_vf = v * cosf(u); // coordonatele varfului corespunzator lui (u,v)
			float y_vf = v * sinf(u);
			float z_vf = v;
			// identificator ptr varf; coordonate + culoare + indice la parcurgerea meridianelor
			index = merid * (NR_PARR_CON + 1) + parr;
			Vertices[index] = glm::vec4(x_vf / 20, y_vf / 20, z_vf, 1.0);
			Colors[index] = glm::vec3(0.34f, 0.21f, 0.13f); //glm::vec3(0.9f + sinf(u), 0.9f + cosf(v), 0.9f + -1.5 * sinf(u));
			Indices[index] = index;
			// indice ptr acelasi varf la parcurgerea paralelelor
			index_aux = parr * (NR_MERID_CON)+merid;
			Indices[(NR_PARR_CON + 1) * NR_MERID_CON + index_aux] = index;
			// indicii pentru desenarea fetelor, pentru varful curent sunt definite 4 varfuri
			if ((parr + 1) % (NR_PARR_CON + 1) != 0) // varful considerat sa nu fie Polul Nord
			{
				int AUX = 2 * (NR_PARR_CON + 1) * NR_MERID_CON;
				int index1 = index; // varful v considerat
				int index2 = index + (NR_PARR_CON + 1); // dreapta lui v, pe meridianul urmator
				int index3 = index2 + 1;  // dreapta sus fata de v
				int index4 = index + 1;  // deasupra lui v, pe acelasi meridian
				if (merid == NR_MERID_CON - 1)  // la ultimul meridian, trebuie revenit la meridianul initial
				{
					index2 = index2 % (NR_PARR_CON + 1);
					index3 = index3 % (NR_PARR_CON + 1);
				}
				Indices[AUX + 4 * index] = index1;  // unele valori ale lui Indices, corespunzatoare Polului Nord, au valori neadecvate
				Indices[AUX + 4 * index + 1] = index2;
				Indices[AUX + 4 * index + 2] = index3;
				Indices[AUX + 4 * index + 3] = index4;
			}
		}
	};


	// background
	Vertices[(NR_PARR_CON + 1) * NR_MERID_CON + 1] = glm::vec4(0.f, 0.f, 0.f, 1.0);
	Vertices[(NR_PARR_CON + 1) * NR_MERID_CON + 2] = glm::vec4(100.f, 0.f, 0.f, 1.0);
	Vertices[(NR_PARR_CON + 1) * NR_MERID_CON + 3] = glm::vec4(0.f, 0.f, 0.f, 1.0);
	Vertices[(NR_PARR_CON + 1) * NR_MERID_CON + 4] = glm::vec4(0.f, 100.f, 0.f, 1.0);

	Colors[(NR_PARR_CON + 1) * NR_MERID_CON + 1] = glm::vec3(0.f, 0.f, 0.f);
	Colors[(NR_PARR_CON + 1) * NR_MERID_CON + 2] = glm::vec3(0.f, 0.f, 0.f);
	Colors[(NR_PARR_CON + 1) * NR_MERID_CON + 3] = glm::vec3(0.f, 0.f, 0.f);
	Colors[(NR_PARR_CON + 1) * NR_MERID_CON + 4] = glm::vec3(0.f, 0.f, 0.f);

	Indices[2 * (NR_PARR_CON + 1) * NR_MERID_CON + 4 * (NR_PARR_CON + 1) * NR_MERID_CON + 1] = (NR_PARR_CON + 1) * NR_MERID_CON + 1;
	Indices[2 * (NR_PARR_CON + 1) * NR_MERID_CON + 4 * (NR_PARR_CON + 1) * NR_MERID_CON + 2] = (NR_PARR_CON + 1) * NR_MERID_CON + 2;
	Indices[2 * (NR_PARR_CON + 1) * NR_MERID_CON + 4 * (NR_PARR_CON + 1) * NR_MERID_CON + 3] = (NR_PARR_CON + 1) * NR_MERID_CON + 3;
	Indices[2 * (NR_PARR_CON + 1) * NR_MERID_CON + 4 * (NR_PARR_CON + 1) * NR_MERID_CON + 4] = (NR_PARR_CON + 1) * NR_MERID_CON + 4;


	// generare VAO/buffere
	glGenBuffers(1, &VboId); // atribute
	glGenBuffers(1, &EboId); // indici

	// legare+"incarcare" buffer
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices) + sizeof(Colors), NULL, GL_STATIC_DRAW);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertices), Vertices);
	glBufferSubData(GL_ARRAY_BUFFER, sizeof(Vertices), sizeof(Colors), Colors);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);

	// atributele; 
	glEnableVertexAttribArray(0); // atributul 0 = pozitie
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
	glEnableVertexAttribArray(1); // atributul 1 = culoare
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)sizeof(Vertices));
}

void CreateVBO3(void)
{
	// background

	// varfurile 
	// (4) Matricele pentru varfuri, culori, indici
	glm::vec4 Vertices[4];
	glm::vec3 Colors[4];
	GLushort Indices[4];

	// background
	Vertices[0] = glm::vec4(0.f, 0.f, 0.f, 1.0);
	Vertices[1] = glm::vec4(5000.f, 0.f, 0.f, 1.0);
	Vertices[2] = glm::vec4(0.f, -5000.f, 0.f, 1.0);
	Vertices[3] = glm::vec4(0.f, -100.f, 0.f, 1.0);

	Colors[0] = glm::vec3(0.f, 0.f, 0.f);
	Colors[1] = glm::vec3(0.f, 0.f, 0.f);
	Colors[2] = glm::vec3(0.f, 0.f, 0.f);
	Colors[3] = glm::vec3(0.f, 0.f, 0.f);

	Indices[0] = 0;
	Indices[1] = 1;
	Indices[2] = 2;
	Indices[3] = 3;


	// generare VAO/buffere
	glGenBuffers(1, &VboId); // atribute
	glGenBuffers(1, &EboId); // indici

	// legare+"incarcare" buffer
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices) + sizeof(Colors), NULL, GL_STATIC_DRAW);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertices), Vertices);
	glBufferSubData(GL_ARRAY_BUFFER, sizeof(Vertices), sizeof(Colors), Colors);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);

	// atributele; 
	glEnableVertexAttribArray(0); // atributul 0 = pozitie
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
	glEnableVertexAttribArray(1); // atributul 1 = culoare
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)sizeof(Vertices));
}


void DestroyVBO(void)
{
	glDisableVertexAttribArray(1);
	glDisableVertexAttribArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(1, &VboId);
	glDeleteBuffers(1, &EboId);
	glDeleteBuffers(1, &VBModelMat);
}
void CreateShaders(void)
{
	ProgramId = LoadShaders("09_03_Shader.vert", "09_03_Shader.frag");
	glUseProgram(ProgramId);
}
void DestroyShaders(void)
{
	glDeleteProgram(ProgramId);
}
void Initialize(void)
{
	glClearColor(1.0f, 1.0f, 1.0f, 0.0f); // culoarea de fond a ecranului

	// Creare VBO+shader
	//CreateVBO();
	CreateShaders();

	// Locatii ptr shader
	viewLocation = glGetUniformLocation(ProgramId, "viewShader");
	projLocation = glGetUniformLocation(ProgramId, "projectionShader");
	codColLocation = glGetUniformLocation(ProgramId, "codCol");
}
void reshapeFcn(GLint newWidth, GLint newHeight)
{
	glViewport(0, 0, newWidth, newHeight);
	winWidth = newWidth;
	winHeight = newHeight;
	width = winWidth / 10, height = winHeight / 10;
}

glm::mat4 offset(float x, float y, float z) {
	// x -> fata-spate
	// y -> stanga-dreapta
	// z -> sus-jos
	return glm::translate(glm::mat4(1.f), glm::vec3(x, y, z));
}

glm::mat4 scaling(float ratio) {
	return glm::scale(glm::mat4(1.f), glm::vec3(ratio, ratio, ratio));
}

void RenderFunction(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glEnable(GL_DEPTH_TEST);

	// background
	CreateVBO3(); // decomentati acest rand daca este cazul 
	glBindVertexArray(VaoId);
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);

	//pozitia observatorului
	Obsx = Refx + dist * cos(alpha) * cos(beta);
	Obsy = Refy + dist * cos(alpha) * sin(beta);
	Obsz = Refz + dist * sin(alpha);

	// reperul de vizualizare
	glm::vec3 Obs = glm::vec3(Obsx, Obsy, Obsz);   // se schimba pozitia observatorului	
	glm::vec3 PctRef = glm::vec3(Refx, Refy, Refz); // pozitia punctului de referinta
	glm::vec3 Vert = glm::vec3(Vx, Vy, Vz); // verticala din planul de vizualizare 

	view = glm::lookAt(Obs, PctRef, Vert) * glm::translate(glm::mat4(1.f), glm::vec3(0, 0, 150));
	//view = glm::lookAt(Obs, PctRef, Vert);
	glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);

	// matricea de proiectie 
	projection = glm::infinitePerspective(fov, GLfloat(width) / GLfloat(height), znear);
	glUniformMatrix4fv(projLocation, 1, GL_FALSE, &projection[0][0]);

	glDrawElements(GL_POLYGON, 4, GL_UNSIGNED_INT, ((void*)(0 * sizeof(GLuint)))); //FUNDAL




	CreateVBO2(); // decomentati acest rand daca este cazul 
	glBindVertexArray(VaoId);
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);

	//pozitia observatorului
	Obsx = Refx + dist * cos(alpha) * cos(beta);
	Obsy = Refy + dist * cos(alpha) * sin(beta);
	Obsz = Refz + dist * sin(alpha);

	// reperul de vizualizare
	//glm::vec3 Obs = glm::vec3(Obsx, Obsy, Obsz);   // se schimba pozitia observatorului	
	//glm::vec3 PctRef = glm::vec3(Refx, Refy, Refz); // pozitia punctului de referinta
	//glm::vec3 Vert = glm::vec3(Vx, Vy, Vz); // verticala din planul de vizualizare 

	view = glm::lookAt(Obs, PctRef, Vert) * glm::translate(glm::mat4(1.f), glm::vec3(0, 0, 150));
	//view = glm::lookAt(Obs, PctRef, Vert);
	glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);

	// matricea de proiectie 
	projection = glm::infinitePerspective(fov, GLfloat(width) / GLfloat(height), znear);
	glUniformMatrix4fv(projLocation, 1, GL_FALSE, &projection[0][0]);

	
	// desenarea fetelor
	codCol = 0;
	glUniform1i(codColLocation, codCol);
	for (int patr = 0; patr < (NR_PARR_CON + 1) * NR_MERID_CON; patr++)
	{
		if ((patr + 1) % (NR_PARR_CON + 1) != 0) // nu sunt considerate fetele in care in stanga jos este Polul Nord
			glDrawElements(GL_QUADS, 4, GL_UNSIGNED_SHORT, (GLvoid*)((2 * (NR_PARR_CON + 1) * (NR_MERID_CON)+4 * patr) * sizeof(GLushort)));
	}


	CreateVBO();

	

	glm::mat4 leaning = glm::rotate(glm::mat4(1), PI * 0.7f, glm::vec3(1.f, 0.f, 0.0f));

	//glm::mat4 offset = glm::translate(glm::mat4(1.f), glm::vec3(0.0f, -50, 30.0f));
	
	view = glm::lookAt(Obs, PctRef, Vert);
	glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);


	codCol = 0;
	glUniform1i(codColLocation, codCol);
	int nr_straturi = 7;
	for (int strat = 0; strat < nr_straturi; strat++) {
		int nr_frunze = strat*2 + 6;
		for (int frunza = 0; frunza < nr_frunze; frunza++)
		{
			
			glm::mat4 current_view = view * scaling(glm::pow(1.1, (float)strat) -0.4)*  glm::rotate(glm::mat4(1), (2 * PI / nr_frunze) * frunza, glm::vec3(0.f, 0.f, 1.f)) * offset(0, -(50+(float)strat/10), 110-(float)strat*(180/ (float)nr_straturi)) * leaning;

			glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &current_view[0][0]);
			for (int patr = 0; patr < (NR_PARR + 1) * NR_MERID; patr++)
			{
				if ((patr + 1) % (NR_PARR + 1) != 0) // nu sunt considerate fetele in care in stanga jos este Polul Nord
					glDrawElements(GL_QUADS, 4, GL_UNSIGNED_SHORT, (GLvoid*)((2 * (NR_PARR + 1) * (NR_MERID)+4 * patr) * sizeof(GLushort)));
			}
		}
	}
	
	



	glutSwapBuffers();
	glFlush();
}
void Cleanup(void)
{
	DestroyShaders();
	DestroyVBO();
}
int main(int argc, char* argv[])
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE);
	glutInitWindowPosition(100, 100);
	glutInitWindowSize(winWidth, winHeight);
	glutCreateWindow("Desenarea si survolarea unei sfere");
	glewInit();
	Initialize();
	glutDisplayFunc(RenderFunction);
	glutIdleFunc(RenderFunction);
	glutKeyboardFunc(processNormalKeys);
	glutSpecialFunc(processSpecialKeys);
	glutReshapeFunc(reshapeFcn);
	glutCloseFunc(Cleanup);
	glutMainLoop();
}