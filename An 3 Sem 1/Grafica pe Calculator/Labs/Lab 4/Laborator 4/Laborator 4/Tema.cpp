 /* TRANSFORMARI.
	- utilizarea bibliotecii glm: https://glm.g-truc.net/0.9.9/index.html 
	- transformari variate asupra primitivelor, transmise catre shader
	- colorarea primitivelor folosind variabile uniforme si shader-ul de fragment
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
  
//////////////////////////////////////

GLuint
  VaoId,
  VboId,
  ColorBufferId,
  ProgramId,
  myMatrixLocation,
  resizeMatrixLocation,
  matrScaleLocation,
  matrTranslLocation,
  matrTransl1Location,
  matrTransl2Location,
  matrRotlLocation,
  codColLocation;
 
glm::mat4 myMatrix, resizeMatrix, matrTransl, matrScale, matrTransl1, matrTransl2, matrRot, mTest;


int codCol;
 float PI=3.141592;

 int width=400, height=300;

 

 
void displayMatrix ( )
{
	for (int ii = 0; ii < 4; ii++)
	{
		for (int jj = 0; jj < 4; jj++)
		cout <<  myMatrix[ii][jj] << "  " ;
		cout << endl;
	};
	cout << "\n";
	
};


void CreateVBO(void)
{
  // varfurile 
  GLfloat Vertices[] = {
	  // varfuri pentru dreptunghiul D
     50.0f,  50.0f, 0.0f, 1.0f,
     400.0f, 50.0f, 0.0f, 1.0f,
	 400.0f,  200.0f, 0.0f, 1.0f,
	 50.0f,  200.0f, 0.0f, 1.0f,
      // varfuri pentru poligonul P1 (trapez)
     200.0f,  250.0f, 0.0f, 1.0f,
     250.0f,  350.0f, 0.0f, 1.0f,
     350.0f,  350.0f, 0.0f, 1.0f,
     400.0f, 250.0f, 0.0f, 1.0f,
      // varfuri pentru poligonul P2
      500.0f,  300.0f, 0.0f, 1.0f,
      600.0f,  400.0f, 0.0f, 1.0f,
      500.0f,  500.0f, 0.0f, 1.0f,
      700.0f,  500.0f, 0.0f, 1.0f,
      700.0f,  300.0f, 0.0f, 1.0f,
      // varfuri pentru dreptunghiul de fundal
      0.0f,  0.0f, 0.0f, 1.0f,
      0.0f,  600.0f, 0.0f, 1.0f,
      800.0f,  600.0f, 0.0f, 1.0f,
      800.0f, 0.0f, 0.0f, 1.0f,
      // punct de rotatie
      450.0f,  325.0f, 0.0f, 1.0f,
  };
   
 

  // culorile varfurilor din colturi
  GLfloat Colors[] = {
     // varfuri pentru dreptunghiul D
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
	1.0f, 0.0f, 0.0f, 1.0f,
    // varfuri pentru poligonul P1 (trapez)
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    // varfuri pentru poligonul P2
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    1.0f, 0.0f, 0.0f, 1.0f,
    // varfuri pentru dreptunghiul de fundal
    0.4f, 0.2f, 0.0f, 1.0f,
    0.2f, 0.2f, 0.3f, 1.0f,
    0.0f, 0.2f, 0.8f, 1.0f,
    0.1f, 0.9f, 0.2f, 1.0f,
  };
 

  // se creeaza un buffer nou
  glGenBuffers(1, &VboId);
  // este setat ca buffer curent
  glBindBuffer(GL_ARRAY_BUFFER, VboId);
  // punctele sunt "copiate" in bufferul curent
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
  
  // se creeaza / se leaga un VAO (Vertex Array Object) - util cand se utilizeaza mai multe VBO
  glGenVertexArrays(1, &VaoId);
  glBindVertexArray(VaoId);
  // se activeaza lucrul cu atribute; atributul 0 = pozitie
  glEnableVertexAttribArray(0);
  // 
  glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
 
  // un nou buffer, pentru culoare
  glGenBuffers(1, &ColorBufferId);
  glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
  // atributul 1 =  culoare
  glEnableVertexAttribArray(1);
  glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
  
  
 }
void DestroyVBO(void)
{
 

  glDisableVertexAttribArray(1);
  glDisableVertexAttribArray(0);

  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glDeleteBuffers(1, &ColorBufferId);
  glDeleteBuffers(1, &VboId);

  glBindVertexArray(0);
  glDeleteVertexArrays(1, &VaoId);

   
}

void CreateShaders(void)
{
  ProgramId=LoadShaders("04_03_Shader.vert", "04_03_Shader.frag");
  glUseProgram(ProgramId);
}

void CreateShaders1(void)
{
    ProgramId = LoadShaders("04_03_Shader_trans.vert", "04_03_Shader.frag");
    glUseProgram(ProgramId);
}

 
void DestroyShaders(void)
{
  glDeleteProgram(ProgramId);
}
 
void Initialize(void)
{
 
	resizeMatrix= glm::scale(glm::mat4(1.0f), glm::vec3(1.f/width, 1.f/height, 1.0));
	matrTransl=glm::translate(glm::mat4(1.0f), glm::vec3(-400.f, -300.f, 0.0));

    matrRot = glm::rotate(glm::mat4(1.0f), PI/2, glm::vec3(0.0, 0.0, 1.0));
    matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(-450.0f, -325.0f, 0.0f));
    matrTransl2 = glm::translate(glm::mat4(1.0f), glm::vec3(450.0f, 325.0f, 0.0f));

    matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.3f, 2.0f, 1.0));


	//matrTransl=glm::mat4(glm::translate(glm::mat4(1.0f), glm::vec3(50.f, -20.f, 0.0)));

	//myMatrix=resizeMatrix*matrTransl;
	//displayMatrix();

	//matrTransl=glm::transpose(glm::mat4(glm::translate(glm::mat4(1.0f), glm::vec3(50.f, -20.f, 0.0))));
	 

	// matrice test
	mTest[0][0]=1; mTest[0][1]=2; mTest[0][2]=3; mTest[0][3]=4;
	mTest[1][0]=0; mTest[1][1]=1; mTest[1][2]=1; mTest[1][3]=1;
	mTest[2][0]=0; mTest[2][1]=1; mTest[2][2]=4; mTest[2][3]=-1;
	mTest[3][0]=0; mTest[3][1]=0; mTest[3][2]=0; mTest[3][3]=-2;
	glm::mat4 mTransl=glm::translate(glm::mat4(1.0f), glm::vec3(1.f, 1.f, 1.0));
	//myMatrix=mTransl;
 
	 // myMatrix=mTest;
	 // displayMatrix( );

    

  

  glClearColor(1.0f, 1.0f, 1.0f, 0.0f); // culoarea de fond a ecranului
  CreateVBO();
  CreateShaders();
}
void RenderFunction(void)
{
    glm::mat4 view;
    view = glm::lookAt(glm::vec3(0.0f, 0.0f, 5.f), 
  		   glm::vec3(0.0f, 0.0f, -20.0f), 
  		   glm::vec3(0.0f, 1.0f, 0.0f));

  glClear(GL_COLOR_BUFFER_BIT);
  myMatrix = resizeMatrix * matrTransl;
  // displayMatrix( );

	// matricea de redimensionare (pentru elementele "fixe")
 
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE,  &myMatrix[0][0]);
	// desenare puncte din colturi si axe
  glLineWidth(3.0);
  glDrawArrays(GL_POLYGON, 13, 4);

  glDrawArrays(GL_LINE_LOOP, 0, 4);

  glDrawArrays(GL_LINE_LOOP, 4, 4);

  glDrawArrays(GL_LINE_LOOP, 8, 5);



  glPointSize(7.0);
  glDrawArrays(GL_POINTS, 17, 1);

  myMatrix = myMatrix * matrTransl2 * matrRot * matrTransl1;
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);


  glDrawArrays(GL_LINE_LOOP, 4, 4);

  glDrawArrays(GL_LINE_LOOP, 8, 5);


  
  myMatrix = resizeMatrix * matrTransl;
  myMatrix = myMatrix * matrScale;
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);

  glDrawArrays(GL_LINE_LOOP, 0, 4);

 
  glutPostRedisplay();
  glFlush ( );
}
void Cleanup(void)
{
  DestroyShaders();
  DestroyVBO();
}

int main(int argc, char* argv[])
{

  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
  glutInitWindowPosition (100,100); 
  glutInitWindowSize(800,600); 
  glutCreateWindow("Tema Lab 4"); 
  glewInit(); 
  Initialize( );
  glutDisplayFunc(RenderFunction);
  glutCloseFunc(Cleanup);
  glutMainLoop();
  
  
}

