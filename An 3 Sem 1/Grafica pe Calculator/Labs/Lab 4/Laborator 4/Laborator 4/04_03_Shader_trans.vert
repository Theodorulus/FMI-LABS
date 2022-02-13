
// Shader-ul de fragment / Fragment shader  
 
 #version 400

in vec4 ex_Color;
uniform int codCol;
 
out vec4 out_Color;

void main(void)
  {
	myMatrix =(resizeMatrix*matrTransl*matrTransl2*matrRot*matrTransl1)*in_Position;
  }
 