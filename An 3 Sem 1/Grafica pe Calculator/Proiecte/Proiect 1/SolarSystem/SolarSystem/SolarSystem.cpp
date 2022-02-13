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

#include <ctime>


#define PI 3.141592f

using namespace std;


GLuint
VaoId,
VboId,
EboId,
ColorBufferId,
ProgramId,
myMatrixLocation,
codColLocation;

glm::mat4 myMatrix, resizeMatrix, circleScaling, ellipseRotation, ellipseSize, ellipseMovement, sunScaling, cycle, moonTranslate, moonScale;

int codCol;
float twoPI = 2 * PI;
float tx = 0; float ty = 0;
int width = 500, height = 500;
float beta = 0.01f;


float rotationMult = 0.0f;
float mercuryMult = 0.0f;
float cycleMult = 0.0;


GLfloat vf_pos[1000];
GLfloat vf_col[1000];
GLuint vf_ind[250];
int ind_sun, ind_earth, ind_moon, ind_mercury, ind_star, ind_background;


int CreateCircle(GLfloat Cx = 0.0f, GLfloat Cy = 0.0f, GLfloat radius = 10.0f, int noOfVertex = 3, int index = 0, GLfloat red = 0.0f, GLfloat green = 0.0f, GLfloat blue = 0.0f, GLfloat offset = 0.01f)
{
    int initial_index = index;
    int index_pos = index * 4;
    int index_ind;
    if (index)
        index_ind = index + 1;
    else
        index_ind = index;

    float theta = PI * 1.5f;
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

    for (int i = 0; i < noOfVertex - 1; i++)
    {
        theta += twoPI / noOfVertex;
        Px = Cx + radius * GLfloat(glm::cos(theta));
        Py = Cy + radius * GLfloat(glm::sin(theta));
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

void miscas(void)
{
    rotationMult = (rotationMult + beta);
    if (rotationMult > 1) rotationMult -= 1;

    mercuryMult = (mercuryMult + beta / 2);
    if (mercuryMult > 1) mercuryMult -= 1;

    cycleMult += beta;
    glutPostRedisplay();
}

void mouse(int button, int state, int x, int y)
{
    switch (button) {
    case GLUT_LEFT_BUTTON:
        if (state == GLUT_DOWN)
            glutIdleFunc(miscas);
        break;
    default:
        break;
    }
}

void CreateVBO(void)
{
    srand((unsigned)time(0));
    ind_sun = CreateCircle(0.0f, 0.0f, 50.0f, 30, 0, 1.0f, 0.8f, 0.0f, 0.01f);
    ind_earth = CreateCircle(0.0f, 0.0f, 50.0f, 30, 30, 0.0f, 0.2f, 0.5f, -0.015f);
    ind_moon = CreateCircle(0.0f, 0.0f, 50.0f, 30, 61, 1.0f, 1.0f, 0.1f, -0.02f);
    ind_mercury = CreateCircle(0.0f, 0.0f, 50.0f, 30, 92, 0.8f, 0.2f, 0.2f, -0.015f);
    ind_star = CreateCircle(0.0f, 0.0f, 5.0f, 6, 123, 1, 1, 1, 0);
    ind_background = CreateCircle(0.0f, 0.0f, 1000.0f, 4, 130, 0.0f, 0.0f, 0.1f, 0.05f);

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
    ProgramId = LoadShaders("05_02_Shader.vert", "05_02_Shader.frag");
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

glm::highp_mat4 randomStar() {
    float randX = (rand() % width * 2) - width;
    float randY = (rand() % height * 2) - height;
    return glm::translate(glm::mat4(1.0f), glm::vec3(randX, randY, 0));
}

void setMatrix(glm::mat4 myMatrix) {
    CreateShaders();
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
}

void RenderFunction(void)
{
    float eccentricity = 170; // dimensiunea mare a elipsei
    float xOffset = 130;
    float semiMinor = 170; // dimensiunea mica a elipsei
    float moonOffset = 50;

    resizeMatrix = glm::scale(glm::mat4(1.0f), glm::vec3(1.f / width, 1.f / height, 1.0)); // scalam, "aducem" scena la "patratul standard" [-1,1]x[-1,1]

    ellipseMovement = glm::translate(glm::mat4(1.0f), glm::vec3(xOffset + eccentricity * glm::cos(twoPI * rotationMult), 0, 0.0)); // seteaza distanta elipsei fata de centru

    ellipseSize = glm::translate(glm::mat4(1.0f), glm::vec3(semiMinor, 0, 0.0)); // seteaza cat de lata va fi elipsa

    circleScaling = glm::scale(glm::mat4(1.0f), glm::vec3(0.33, 0.33, 0.0));

    ellipseRotation = glm::rotate(glm::mat4(1.0f), twoPI * rotationMult, glm::vec3(0.0, 0.0, 1.0)); // rotatia elipsei

    sunScaling = glm::scale(glm::mat4(1.0f), glm::vec3(3, 3, 0.0));

    cycle = glm::rotate(glm::mat4(1.0f), 0.1f * cycleMult * twoPI, glm::vec3(0.0, 0.0, 1.0)); // cat de repede se roteste elipsa in jurul centrului

    moonTranslate = glm::translate(glm::mat4(1.0f), glm::vec3(moonOffset, 0, 0.0)); // translatia lunii

    moonScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.25, 0.25, 0.0));

    glClear(GL_COLOR_BUFFER_BIT);
    CreateVBO();

    ///////////////

    myMatrix = resizeMatrix;
    setMatrix(myMatrix);
    glDrawElements(GL_POLYGON, ind_background, GL_UNSIGNED_INT, (void*)((ind_sun + 1 + ind_earth + 1 + ind_moon + 1 + ind_mercury + 1 + ind_star + 1) * sizeof(GLuint))); //FUNDAL

    ///////////////

    for (int i = 0; i < 7; i++) {

        myMatrix = resizeMatrix * randomStar();
        setMatrix(myMatrix);
        glDrawElements(GL_POLYGON, ind_star, GL_UNSIGNED_INT, (void*)((ind_sun + 1 + ind_earth + 1 + ind_moon + 1 + ind_mercury + 1) * sizeof(GLuint))); //STELE
    }

    ///////////////

    myMatrix = resizeMatrix * rotationOwnAxis(1) * sunScaling * circleScaling;
    setMatrix(myMatrix);

    glDrawElements(GL_POLYGON, ind_sun, GL_UNSIGNED_INT, (void*)(0)); //SOARE

    ///////////////

    myMatrix = resizeMatrix * cycle * ellipseMovement * ellipseRotation * ellipseSize * rotationOwnAxis(3) * circleScaling;
    setMatrix(myMatrix);

    glDrawElements(GL_POLYGON, ind_earth, GL_UNSIGNED_INT, (void*)((ind_sun + 1) * sizeof(GLuint))); //PAMANT

    ///////////////

    myMatrix = resizeMatrix * cycle * ellipseMovement * ellipseRotation * ellipseSize * rotationOwnAxis(3) * moonTranslate * moonScale * circleScaling;
    setMatrix(myMatrix);

    glDrawElements(GL_POLYGON, ind_moon, GL_UNSIGNED_INT, (void*)((ind_sun + 1 + ind_earth + 1) * sizeof(GLuint))); //LUNA

    ///////////////

    ellipseMovement = glm::translate(glm::mat4(1.0f), glm::vec3(60 + 70 * glm::cos(twoPI * mercuryMult), 0, 0.0)); // seteaza distanta elipsei fata de centru
    ellipseSize = glm::translate(glm::mat4(1.0f), glm::vec3(100, 0, 0.0)); // seteaza cat de lata va fi elipsa
    ellipseRotation = glm::rotate(glm::mat4(1.0f), twoPI * mercuryMult, glm::vec3(0.0, 0.0, 1.0)); // rotatia elipsei


    myMatrix = resizeMatrix * cycle * ellipseMovement * ellipseRotation * ellipseSize * rotationOwnAxis(2) * circleScaling;
    setMatrix(myMatrix);

    glDrawElements(GL_POLYGON, ind_mercury, GL_UNSIGNED_INT, (void*)((ind_sun + 1 + ind_earth + 1 + ind_moon + 1) * sizeof(GLuint))); //MERCUR

    ///////////////

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
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(1000, 1000);
    glutCreateWindow("Orbite 2D");
    glewInit();
    Initialize();
    glutDisplayFunc(RenderFunction);
    glutMouseFunc(mouse);
    glutCloseFunc(Cleanup);
    glutMainLoop();
}

