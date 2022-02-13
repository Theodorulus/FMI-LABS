/* INDEXARE
Elemente de noutate:
   - folosirea indecsilor: elemente asociate (matrice, buffer)
   - cele 4 functii de desenare (glDrawArrays, glDrawElements, glDrawElementsBaseVertex, glDrawArraysInstanced) */
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
#include "SOIL.h"

using namespace std;

//////////////////////////////////////

GLuint
VaoId,
VboId,
EboId,
ColorBufferId,
ProgramId,
myMatrixLocation,
viewLocation,
projLocation;

GLuint texture;


//float width = 80.f, height = 60.f;
//glm::mat4 myMatrix, resizeMatrix=glm::ortho(-width, width, -height, height);
glm::mat4 myMatrix, resizeMatrix = glm::ortho(-80.f, 80.f, -60.f, 60.f);
glm::mat4 matrScale, matrTransl;

// elemente pentru matricea de vizualizare
float Obsx = 0.0, Obsy = 0.0, Obsz = 800.f;
float Refx = 0.0f, Refy = 0.0f;
float Vx = 0.0;
glm::mat4 view;

// elemente pentru matricea de proiectie
float width = 800, height = 600, xwmin = -800.f, xwmax = 800, ywmin = -600, ywmax = 600, znear = 0, zfar = 1000, fov = 45;
glm::mat4 projection;

void CreateVBO(void)
{
    // coordonatele varfurilor
    static const GLfloat vf_pos[] =
    {
    -5.0f, -5.0f, 0.0f, 1.0f,
     5.0f,  -5.0f, 0.0f, 1.0f,
     5.0f,  5.0f, 0.0f, 1.0f,
    -5.0f,  5.0f, 0.0f, 1.0f,
 
    };
    // culorile varfurilor
    static const GLfloat vf_col[] =
    {
    0.0f, 0.5f, 0.0f, 1.0f,
    0.0f, 0.5f, 0.0f, 1.0f,
    0.0f, 0.5f, 0.0f, 1.0f,
    0.0f, 0.5f, 0.0f, 1.0f,
    };
    // indici pentru trasarea unui triunghi
    static const GLuint vf_ind[] =
    {
    0, 1, 2, 2, 3, 0
    };
 
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

void LoadTexture(void)
{

    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    int width, height;
    unsigned char* image = SOIL_load_image("text_smiley_face.png", &width, &height, 0, SOIL_LOAD_RGB);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
    glGenerateMipmap(GL_TEXTURE_2D);

    SOIL_free_image_data(image);
    glBindTexture(GL_TEXTURE_2D, 0);

}

void CreateShaders(void)
{
    ProgramId = LoadShaders("06_02_Shader.vert", "06_02_Shader.frag");
    glUseProgram(ProgramId);
}

void DestroyShaders(void)
{
    glDeleteProgram(ProgramId);
}

void Initialize(void)
{
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f); // culoarea de fond a ecranului
    CreateShaders();
}
void RenderFunction(void)
{
    glClear(GL_COLOR_BUFFER_BIT);
    // Creare VBO
    CreateVBO();

    matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(2.0f, 0.5f, 1.0));
    matrTransl = glm::translate(glm::mat4(1.0f), glm::vec3(30.f, 30.f, 0.0));

    // Transmitere variabile uniforme
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    
    // Desen scalare apoi translatie
    myMatrix = resizeMatrix * matrTransl * matrScale;
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, (void*)(0));



    // se schimba pozitia observatorului
    glm::vec3 Obs = glm::vec3(Obsx, Obsy, Obsz);

    // pozitia punctului de referinta
    Refx = Obsx; Refy = Obsy;
    glm::vec3 PctRef = glm::vec3(Refx, Refy, -1.0f);

    // verticala din planul de vizualizare 

    glm::vec3 Vert = glm::vec3(Vx, 1.0f, 0.0f);


    view = glm::lookAt(Obs, PctRef, Vert);

    // Desen translatie apoi scalare
    myMatrix = view * resizeMatrix * matrScale * matrTransl;
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
    viewLocation = glGetUniformLocation(ProgramId, "view");
    glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);
    projLocation = glGetUniformLocation(ProgramId, "projection");
    glUniformMatrix4fv(projLocation, 1, GL_FALSE, &projection[0][0]);
    // variabile uniforme pentru shaderul de fragmente
    glUniform1i(glGetUniformLocation(ProgramId, "myTexture"), 0);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, (void*)(0));

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
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Utilizarea indexarii varfurilor");
    glewInit();
    Initialize();
    glutDisplayFunc(RenderFunction);
    glutCloseFunc(Cleanup);

    glutMainLoop();


}

