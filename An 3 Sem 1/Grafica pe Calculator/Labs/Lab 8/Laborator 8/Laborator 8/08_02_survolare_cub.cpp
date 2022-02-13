/*
- Survolarea unui obiect folosind coordonate sferice.
*/
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

#define INSTANCE_COUNT 40

// identificatori 
/*GLuint
VaoId,
VboId,
EboId,
ProgramId,
viewLocation,
projLocation,
codColLocation;*/
GLuint
VaoId,
VBPos,
VBCol,
VBModelMat,
EboId,
ColorBufferId,
ProgramId,
viewLocation,
projLocation,
codColLocation,
codCol;

float const PI = 3.141592;

// variabile
//int codCol;

// variabile pentru matricea de vizualizare
float Refx = 0.0f, Refy = 0.0f, Refz = 0.0f;
float alpha = 0.0f, beta = 0.0f, dist = 200.0f;
float Obsx, Obsy, Obsz;
float Vx = 0.0f, Vy = 0.0f, Vz = -1.0f;
float incr_alpha1 = 0.01, incr_alpha2 = 0.01;

// variabile pentru matricea de proiectie
float width = 800, height = 600, xwmin = -200.f, xwmax = 200, ywmin = -200, ywmax = 200, znear = 1, fov = 30;

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
		beta -= 0.1;
		break;
	case GLUT_KEY_RIGHT:
		beta += 0.1;
		break;
	case GLUT_KEY_UP:
		alpha += incr_alpha1;
		if (abs(alpha - PI / 2) < 0.05)
		{
			incr_alpha1 = 0.f;
		}
		else
		{
			incr_alpha1 = 0.1f;
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
			incr_alpha2 = 0.1f;
		}
		break;
	}
}
void CreateVBO(void)
{
	// varfurile 
	GLfloat Vertices[] =
	{
		/*
		// varfurile din planul z=-50  
		// coordonate                   // culori			
		-50.0f,  -50.0f, -50.0f, 1.0f,  0.0f, 1.0f, 0.0f,
		50.0f,  -50.0f,  -50.0f, 1.0f,   0.0f, 0.9f, 0.0f,
		50.0f,  50.0f,  -50.0f, 1.0f,    0.0f, 0.6f, 0.0f,
		-50.0f,  50.0f, -50.0f, 1.0f,   0.0f, 0.2f, 0.6f,
		// varfurile din planul z=+50  
		// coordonate                   // culori			
		-50.0f,  -50.0f, 50.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		50.0f,  -50.0f,  50.0f, 1.0f,   0.7f, 0.0f, 0.0f,
		50.0f,  50.0f,  50.0f, 1.0f,    0.5f, 0.0f, 0.0f,
		-50.0f,  50.0f, 50.0f, 1.0f,   0.1f, 0.6f, 0.0f,
		*/
		
		/*// coordonate                   // culori			
		-50.0f,  -50.0f, 50.0f, 1.0f,  1.0f, 0.0f, 0.0f,
		50.0f,  -50.0f,  50.0f, 1.0f,   0.7f, 0.0f, 0.0f,
		50.0f,  50.0f,  50.0f, 1.0f,    0.5f, 0.0f, 0.0f,
		-50.0f,  50.0f, 50.0f, 1.0f,   0.1f, 0.0f, 0.0f,
		// am adaugat varful:
		0.0f, 0.0f, -50.0f, 1.0f, 0.0f, 0.0f, 1.0f,*/

		-50.0f,  -50.0f, 50.0f, 1.0f,
		50.0f,  -50.0f,  50.0f, 1.0f,
		50.0f,  50.0f,  50.0f, 1.0f,
		-50.0f,  50.0f, 50.0f, 1.0f,
		0.0f, 0.0f, -50.0f, 1.0f,

	};

	// Culorile instantelor
	glm::vec4 Colors[INSTANCE_COUNT];
	for (int n = 0; n < INSTANCE_COUNT; n++)
	{
		float a = float(n) / 4.0f;
		float b = float(n) / 5.0f;
		float c = float(n) / 6.0f;
		Colors[n][0] = 0.35f + 0.30f * (sinf(a + 2.0f) + 1.0f);
		Colors[n][1] = 0.25f + 0.25f * (sinf(b + 3.0f) + 1.0f);
		Colors[n][2] = 0.25f + 0.35f * (sinf(c + 4.0f) + 1.0f);
		Colors[n][3] = 1.0f;
	}

	// Matricele instantelor
	glm::mat4 MatModel[INSTANCE_COUNT];
	for (int n = 0; n < INSTANCE_COUNT; n++)
	{
		MatModel[n] = glm::translate(glm::mat4(1.0f), glm::vec3(80 * n * sin(10.f * n * 180 / PI), 80 * n * cos(10.f * n * 180 / PI), 80 * n * sin(10.f * n * 180 / PI))) * glm::rotate(glm::mat4(1.0f), n * PI / 8, glm::vec3(n, 2 * n * n, n / 3));
	}


	// indicii pentru varfuri
	GLubyte Indices[] =
	{
		1, 2, 0,   0, 2, 3, //  Fata "de sus"
		0, 1, 4,
		1, 2, 4,
		2, 3, 4,
		0, 3, 4,
		0, 1, 2, 3,  // Contur fata de sus
		0, 4, // Muchii laterale
		1, 4,
		2, 4,
		3, 4
		/*1, 0, 2,   2, 0, 3,  //  Fata "de jos"
		2, 3, 6,   6, 3, 7,  // Lateral 
		7, 3, 4,   4, 3, 0,  // Lateral 
		4, 0, 5,   5, 0, 1,  // Lateral 
		1, 2, 5,   5, 2, 6,  // Lateral 
		5, 6, 4,   4, 6, 7, //  Fata "de sus"
		0, 1, 2, 3,  // Contur fata de jos
		4, 5, 6, 7,  // Contur fata de sus
		0, 4, // Muchie laterala
		1, 5, // Muchie laterala
		2, 6, // Muchie laterala
		3, 7 // Muchie laterala*/
	};

	/*// generare VAO/buffere
	glGenBuffers(1, &VboId); // atribute
	glGenBuffers(1, &EboId); // indici

	// legare+"incarcare" buffer
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW); // "copiere" in bufferul curent
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW); // "copiere" indici in bufferul curent

	// se activeaza lucrul cu atribute; 
	glEnableVertexAttribArray(0); // atributul 0 = pozitie
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), (GLvoid*)0);
	glEnableVertexAttribArray(1); // atributul 1 = culoare
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(GLfloat), (GLvoid*)(4 * sizeof(GLfloat)));*/

	// generare buffere
	glGenVertexArrays(1, &VaoId);
	glGenBuffers(1, &VBPos);
	glGenBuffers(1, &VBCol);
	glGenBuffers(1, &VBModelMat);
	glGenBuffers(1, &EboId);

	// legarea VAO 
	glBindVertexArray(VaoId);

	// 0: Pozitie
	glBindBuffer(GL_ARRAY_BUFFER, VBPos);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), (GLvoid*)0);

	// 1: Culoare
	glBindBuffer(GL_ARRAY_BUFFER, VBCol); // legare buffer
	glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(glm::vec4), (GLvoid*)0);
	glVertexAttribDivisor(1, 1);  // rata cu care are loc distribuirea culorilor per instanta

	// 2..5 (2+i): Matrice de pozitie
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

	// Indicii 
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}
void DestroyVBO(void)
{
	/*glDisableVertexAttribArray(1);
	glDisableVertexAttribArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(1, &VboId);
	glDeleteBuffers(1, &EboId);*/

	glDisableVertexAttribArray(2);
	glDisableVertexAttribArray(1);
	glDisableVertexAttribArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(1, &VBPos);
	glDeleteBuffers(1, &VBCol);
	glDeleteBuffers(1, &VBModelMat);
	glDeleteBuffers(1, &EboId);
	glBindVertexArray(0);
	glDeleteVertexArrays(1, &VaoId);
}
void CreateShaders(void)
{
	//ProgramId = LoadShaders("08_02_Shader.vert", "08_02_Shader.frag");
	ProgramId = LoadShaders("08_03_Shader.vert", "08_03_Shader.frag");
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
	CreateVBO();
	CreateShaders();

	// Locatii ptr shader
	/*viewLocation = glGetUniformLocation(ProgramId, "viewShader");
	projLocation = glGetUniformLocation(ProgramId, "projectionShader");
	codColLocation = glGetUniformLocation(ProgramId, "codCol");*/

	viewLocation = glGetUniformLocation(ProgramId, "viewMatrix");
	projLocation = glGetUniformLocation(ProgramId, "projectionMatrix");
	codColLocation = glGetUniformLocation(ProgramId, "codCol");
}
void RenderFunction(void)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glEnable(GL_DEPTH_TEST);

	// CreateVBO(); // decomentati acest rand daca este cazul 
	/*glBindVertexArray(VaoId);
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);*/

	glBindVertexArray(VaoId);
	glBindBuffer(GL_ARRAY_BUFFER, VBPos);
	glBindBuffer(GL_ARRAY_BUFFER, VBCol);
	glBindBuffer(GL_ARRAY_BUFFER, VBModelMat);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);

	//pozitia observatorului
	Obsx = Refx + dist * cos(alpha) * cos(beta);
	Obsy = Refy + dist * cos(alpha) * sin(beta);
	Obsz = Refz + dist * sin(alpha);

	// reperul de vizualizare
	glm::vec3 Obs = glm::vec3(Obsx, Obsy, Obsz);   // se schimba pozitia observatorului	
	glm::vec3 PctRef = glm::vec3(Refx, Refy, Refz); // pozitia punctului de referinta
	glm::vec3 Vert = glm::vec3(Vx, Vy, Vz); // verticala din planul de vizualizare 
	view = glm::lookAt(Obs, PctRef, Vert);
	glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);

	// matricea de proiectie, pot fi testate si alte variante
	projection = glm::infinitePerspective(fov, GLfloat(width) / GLfloat(height), znear);
	glUniformMatrix4fv(projLocation, 1, GL_FALSE, &projection[0][0]);

	// Fetele
	codCol = 0;
	glUniform1i(codColLocation, codCol);
	//glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, 0);
	//glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_BYTE, 0);

	glDrawElementsInstanced(GL_TRIANGLES, 18, GL_UNSIGNED_BYTE, 0, INSTANCE_COUNT);
	// Muchiile
	codCol = 1;
	glUniform1i(codColLocation, codCol);
	glLineWidth(2.5);
	/*glDrawElements(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, (void*)(36));
	glDrawElements(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, (void*)(40));
	glDrawElements(GL_LINES, 8, GL_UNSIGNED_BYTE, (void*)(44));*/
	//glDrawElements(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, (void*)(18));
	//glDrawElements(GL_LINES, 8, GL_UNSIGNED_BYTE, (void*)(22));

	glDrawElementsInstanced(GL_LINE_LOOP, 4, GL_UNSIGNED_BYTE, (void*)(18), INSTANCE_COUNT);
	glDrawElementsInstanced(GL_LINES, 8, GL_UNSIGNED_BYTE, (void*)(22), INSTANCE_COUNT);

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
	glutInitWindowSize(1200, 900);
	glutCreateWindow("Survolarea unui cub");
	glewInit();
	Initialize();
	glutDisplayFunc(RenderFunction);
	glutIdleFunc(RenderFunction);
	glutKeyboardFunc(processNormalKeys);
	glutSpecialFunc(processSpecialKeys);
	glutCloseFunc(Cleanup);
	glutMainLoop();
}

