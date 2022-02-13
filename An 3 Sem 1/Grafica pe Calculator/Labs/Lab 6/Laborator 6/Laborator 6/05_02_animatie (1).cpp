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

#define PI 3.14159265358979323846264338327950288419716939937510


using namespace std;



//////////////////////////////////////

GLuint
  VaoId,
  VboId,
  EboId,
  ColorBufferId,
  ProgramId,
  myMatrixLocation,
  matrScaleLocation,
  matrTranslLocation,
  matrRotlLocation,
  codColLocation;
 
glm::mat4 myMatrix, resizeMatrix, matrTransl, matrScale1, matrScale2, matrRot, matrDepl; 


int codCol;
 float twoPI=2*3.141592, angle=0;
 float tx=0; float ty=0; 
 int width=500, height=500;
 float i=0.0, alpha=0.0, beta=0.01f;


float rotationMult = 0.0f;
float cycleMult = 0.0;


GLfloat vf_pos[1000];
GLfloat vf_col[1000];
GLuint vf_ind[250];
int ind_sun, ind_earth, ind_moon;


int CreateCircle(GLfloat Cx = 0.0f, GLfloat Cy = 0.0f, GLfloat radius = 10.0f, int noOfVertex = 3, int index = 0, GLfloat red = 0.0f, GLfloat green = 0.0f, GLfloat blue = 0.0f, GLfloat offset = 0.01f)
{
    int initial_index = index;
    int index_pos = index * 4;
    int index_ind;
    if (index)
        index_ind = index + 1;
    else
        index_ind = index;

    float theta = 3.0f * float(PI) / 2;
    GLfloat Px = Cx + radius * GLfloat(glm::cos(theta));
    GLfloat Py = Cy + radius * GLfloat(glm::sin(theta));
    vf_col[index_pos] = red;
    red += offset;
    vf_pos[index_pos++] = Px;
    vf_col[index_pos] = green;
    green += offset;
    vf_pos[index_pos++] = Py;
    vf_col[index_pos] = blue;
    blue += offset;
    vf_pos[index_pos++] = 0.0f;
    vf_col[index_pos] = 1.0f;
    vf_pos[index_pos++] = 1.0f;

    vf_ind[index_ind++] = GLuint(index++);


    //cout << "Px: " << Px << " Py: " << Py << endl;
    //cout << "theta: " << theta << endl;

    for (int i = 0; i < noOfVertex - 1; i++)
    {
        theta = theta + 2 * PI / noOfVertex;
        Px = Cx + radius * GLfloat(glm::cos(theta));
        Py = Cy + radius * GLfloat(glm::sin(theta));
        //cout << "Px: " << Px << " Py: " << Py << endl;
        //cout << "theta: " << theta << endl;
        vf_col[index_pos] = red;
        red += offset;
        vf_pos[index_pos++] = Px;
        vf_col[index_pos] = green;
        green += offset;
        vf_pos[index_pos++] = Py;
        vf_col[index_pos] = blue;
        blue += offset;
        vf_pos[index_pos++] = 0.0f;
        vf_col[index_pos] = 1.0f;
        vf_pos[index_pos++] = 1.0f;

        vf_ind[index_ind++] = index++;
    }

    vf_ind[index_ind] = 0;
    return noOfVertex;
}


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

void miscad (void)
{
	i = i + alpha;
  if ( i > 500.0 )
	  alpha = -10.0;
  else if ( i < -500.0 )
	   alpha = 10.0;
  angle = angle - beta;

  glutPostRedisplay ( );
}

void miscas (void)
{   
	i = i + alpha;
  if ( i < -500.0 )
	  alpha = 10.0;
  else if ( i > 500.0 )
		alpha = -10.0;
  angle = angle + beta;

  rotationMult = (rotationMult + beta);
  if (rotationMult > 1) rotationMult -= 1;

  cycleMult += beta;
  glutPostRedisplay ( );
}

void mouse(int button, int state, int x, int y) 
{
   switch (button) {
      case GLUT_LEFT_BUTTON:
         if (state == GLUT_DOWN)
            alpha = -10.0; glutIdleFunc(miscas);
         break;
      case GLUT_RIGHT_BUTTON:
         if (state == GLUT_DOWN)
            alpha = 10.0; glutIdleFunc(miscad);
         break;
      default:
         break;
   }
}
//
//void CreateVBO(void)
//{
//  // varfurile 
//  GLfloat Vertices[] = {
//
//	 // varfuri pentru axe
//	  -450.0f, 0.0f, 0.0f, 1.0f,
//      450.0f,  0.0f, 0.0f, 1.0f,
//      0.0f, -300.0f, 0.0f, 1.0f,
//	  0.0f, 300.0f, 0.0f, 1.0f,
//	  // varfuri pentru dreptunghi
//     -50.0f,  -50.0f, 0.0f, 1.0f,
//     50.0f, -50.0f, 0.0f, 1.0f,
//	 50.0f,  50.0f, 0.0f, 1.0f,
//	 -50.0f,  50.0f, 0.0f, 1.0f,
// 
//  };
//   
// 
//
//  // culorile varfurilor din colturi
//  GLfloat Colors[] = {
//    1.0f, 1.0f, 1.0f, 1.0f,
//    0.0f, 1.0f, 0.0f, 1.0f,
//    0.0f, 0.0f, 1.0f, 1.0f,
//	1.0f, 0.0f, 0.0f, 1.0f,
//
//	0.0f, 1.0f, 1.0f, 1.0f,
//	0.0f, 1.0f, 1.0f, 1.0f,
//	1.0f, 0.0f, 0.0f, 1.0f,
//	1.0f, 0.0f, 0.0f, 1.0f,
//  };
// 
//
//  // se creeaza un buffer nou
//  glGenBuffers(1, &VboId);
//  // este setat ca buffer curent
//  glBindBuffer(GL_ARRAY_BUFFER, VboId);
//  // punctele sunt "copiate" in bufferul curent
//  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
//  
//  // se creeaza / se leaga un VAO (Vertex Array Object) - util cand se utilizeaza mai multe VBO
//  glGenVertexArrays(1, &VaoId);
//  glBindVertexArray(VaoId);
//  // se activeaza lucrul cu atribute; atributul 0 = pozitie
//  glEnableVertexAttribArray(0);
//  // 
//  glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
// 
//  // un nou buffer, pentru culoare
//  glGenBuffers(1, &ColorBufferId);
//  glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
//  glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
//  // atributul 1 =  culoare
//  glEnableVertexAttribArray(1);
//  glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
//  
//  
// }
//

void CreateVBO(void)
{
    ind_sun = CreateCircle(0.0f, 0.0f, 50.0f, 30, 0, 1.0f, 0.8f, 0.0f, 0.01f);
    ind_earth = CreateCircle(0.0f, 0.0f, 50.0f, 30, 30, 0.0f, 0.2f, 0.5f, -0.015f);
    ind_moon = CreateCircle(0.0f, 0.0f, 50.0f, 30, 61, 1.0f, 1.0f, 0.1f, -0.02f);
    /*
    cout << ind_sun << endl;
    for (int i = 0; i < 4 * ind_sun; i++)
    {
        cout << vf_pos[i] << ' ';
        if ((i + 1) % 4 == 0)
            cout << endl;
    }

    for (int i = 0; i <= ind_sun; i++)
    {
        cout << vf_ind[i] << ' ';
    }

    cout << endl;
    */

    for (int i = 0; i <= ind_sun; i++)
    {
        cout << vf_ind[i] << ' ';
    }

    cout << endl;
    cout << ind_sun << ' ' << ind_earth << endl;

    for (int i = ind_sun + 1; i <= ind_sun + ind_earth; i++)
    {
        cout << vf_ind[i] << ' ';
    }


    // se creeaza un buffer nou pentru varfuri
    glGenBuffers(1, &VboId);
    // buffer pentru indici
    glGenBuffers(1, &EboId);
    // se creeaza / se leaga un VAO (Vertex Array Object)
    glGenVertexArrays(1, &VaoId);

    // legare VAO
    glBindVertexArray(VaoId);

    // buffer-ul este setat ca buffer curent
    glBindBuffer(GL_ARRAY_BUFFER, VboId);

    // buffer-ul va contine atat coordonatele varfurilor, cat si datele de culoare
    glBufferData(GL_ARRAY_BUFFER, sizeof(vf_col) + sizeof(vf_pos), NULL, GL_STATIC_DRAW);
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vf_pos), vf_pos);
    glBufferSubData(GL_ARRAY_BUFFER, sizeof(vf_pos), sizeof(vf_col), vf_col);

    // buffer-ul pentru indici
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vf_ind), vf_ind, GL_STATIC_DRAW);

    // se activeaza lucrul cu atribute; atributul 0 = pozitie, atributul 1 = culoare, acestea sunt indicate corect in VBO
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, NULL);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)sizeof(vf_pos));
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);

}


void DestroyVBO(void)
{
 

  glDisableVertexAttribArray(1);
  glDisableVertexAttribArray(0);

  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glDeleteBuffers(1, &EboId);
  glDeleteBuffers(1, &ColorBufferId);
  glDeleteBuffers(1, &VboId);

  glBindVertexArray(0);
  glDeleteVertexArrays(1, &VaoId);

   
}

void CreateShaders(void)
{
  ProgramId=LoadShaders("05_02_Shader.vert", "05_02_Shader.frag");
  glUseProgram(ProgramId);
}
 
void DestroyShaders(void)
{
  glDeleteProgram(ProgramId);
}
 
void Initialize(void)
{
      glClearColor(1.0f, 1.0f, 1.0f, 0.0f); // culoarea de fond a ecranului
}

glm::highp_mat4 rotationOwnAxis(float speed) {
	return glm::rotate(glm::mat4(1.0f), speed * twoPI * rotationMult, glm::vec3(0.0, 0.0, 1.0));
}

void RenderFunction(void)
{
	float eccentricity = 170; // cat de "lata" este orbita eliptica
	float xOffset = 130;
	float semiMinor = 130; // cat de "inalta" este orbita eliptica

  resizeMatrix= glm::scale(glm::mat4(1.0f), glm::vec3(1.f/width, 1.f/height, 1.0)); // scalam, "aducem" scena la "patratul standard" [-1,1]x[-1,1]
  
  matrTransl=glm::translate(glm::mat4(1.0f), glm::vec3(0, 0, 0.0)); // controleaza translatia de-a lungul lui Ox
  
  glm::mat4 matrTransl2 = glm::translate(glm::mat4(1.0f), glm::vec3(xOffset+ eccentricity* glm::cos(twoPI*rotationMult), 0, 0.0)); // controleaza translatia de-a lungul lui Ox
  
  matrDepl=glm::translate(glm::mat4(1.0f), glm::vec3(semiMinor, 0, 0.0)); // plaseaza Pamantul
  
  glm::mat4 matrDepl2 = glm::translate(glm::mat4(1.0f), glm::vec3(0, -80.0, 0.0)); // plaseaza patratul rosu

  
  matrScale1=glm::scale(glm::mat4(1.0f), glm::vec3(1.1, 0.3, 0.0)); // folosita la desenarea dreptunghiului albastru
  
  matrScale2=glm::scale(glm::mat4(1.0f), glm::vec3(0.33, 0.33, 0.0)); // folosita la desenarea patratului rosu
  
  matrRot=glm::rotate(glm::mat4(1.0f), twoPI*rotationMult, glm::vec3(0.0, 0.0, 1.0)); // rotatie folosita la deplasarea patratului rosu

  //float daysInAYear = 3;
  //glm::mat4 dayRotation = glm::rotate(glm::mat4(1.0f), daysInAYear*twoPI * rotationMult, glm::vec3(0.0, 0.0, 1.0)); // cate zile sunt intr-un an

  glm::mat4 sunScaling = glm::scale(glm::mat4(1.0f), glm::vec3(3, 3, 0.0));
  
  glm::mat4 cycle = glm::rotate(glm::mat4(1.0f), 0.1f*cycleMult * twoPI, glm::vec3(0.0, 0.0, 1.0)); // cate zile sunt intr-un an

  glm::mat4 moonTranslate = glm::translate(glm::mat4(1.0f), glm::vec3(00, 50, 0.0)); // translatia lunii

  glm::mat4 moonScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.25, 0.25, 0.0));

  cout <<"\nangle" << angle << "\ni" << i << "\n";

  glClear(GL_COLOR_BUFFER_BIT);
  CreateVBO();

  // Matricea pentru dreptunghiul albastru 
  myMatrix = resizeMatrix * matrTransl * rotationOwnAxis(1)*  matrScale2 * sunScaling;   
  // Creare shader + transmitere variabile uniforme
  CreateShaders();
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix"); 
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE,  &myMatrix[0][0]);
  codCol=0;
  codColLocation = glGetUniformLocation(ProgramId, "codCol");
  glUniform1i(codColLocation, codCol);
  // Apelare DrawArrays
  //glDrawArrays(GL_POLYGON, 4, 4);
  glDrawElements(GL_POLYGON, ind_sun, GL_UNSIGNED_INT, (void*)(0)); //soare

  // Matricea pentru dreptunghiul rosu 
  myMatrix=resizeMatrix *cycle  *  matrTransl2 * matrRot * matrDepl * rotationOwnAxis(3)* matrScale2;
  // Creare shader + transmitere variabile uniforme
  CreateShaders();
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix"); 
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE,  &myMatrix[0][0]);
  codCol=0;
  codColLocation = glGetUniformLocation(ProgramId, "codCol");
  glUniform1i(codColLocation, codCol);
  //glDrawArrays(GL_POLYGON, 4, 4);
  glDrawElements(GL_POLYGON, ind_earth, GL_UNSIGNED_INT, (void*)((ind_sun + 1) * sizeof(GLuint))); //pamant


  myMatrix = resizeMatrix * cycle * matrTransl2 * matrRot * matrDepl * rotationOwnAxis(3)* moonTranslate *moonScale * matrScale2;
  // Creare shader + transmitere variabile uniforme
  CreateShaders();
  myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
  glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
  codCol = 0;
  codColLocation = glGetUniformLocation(ProgramId, "codCol");
  glUniform1i(codColLocation, codCol);
  //glDrawArrays(GL_POLYGON, 4, 4);
  glDrawElements(GL_POLYGON, ind_moon, GL_UNSIGNED_INT, (void*)((ind_sun + 1 + ind_earth + 1) * sizeof(GLuint))); //luna




  // TO DO: adaugati si alte obiecte
  glutSwapBuffers();
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
  glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB);
  glutInitWindowPosition (100,100); 
  glutInitWindowSize(1000,1000); 
  glutCreateWindow("Compunerea transformarilor. Utilizarea mouse-ului"); 
  glewInit(); 
  Initialize( );
  glutDisplayFunc(RenderFunction);
  glutMouseFunc(mouse);
  glutCloseFunc(Cleanup);

  glutMainLoop();
  
  
}

