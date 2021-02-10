
a=10;
a="abc";
var b,c,d=8;
//document.write(a+"<br/>")

function f(a,b=4,c=5){
  
  document.write("global "+window.a+"<br/>")
  document.write("local "+b+"<br/>")
  document.write("nr argumente "+arguments.length+"<br/>")
  for(let i=0; i < arguments.length ; i++){
    document.write(arguments[i]+"<br/>")
  }
}


f(1,2,3,4,5,6)  //aici il creeaza pe h
//document.write(h+"<br/>")









a=10;
a="abc";
var b,c,d=8;
w=null
if(!c){
  //c nu a fost definit
}
//document.write(a+"<br/>")
f(1,2,3,4,5,6) 
function f(a,b=4,c=5){
  document.write(1+"<br/>");
}


f(1,2,3,4,5,6)  //aici il creeaza pe h
//document.write(h+"<br/>")
function f(a){
  document.write(2+"<br/>");
}

f(1,2,3,4,5,6) 

f=function(a){
  document.write(3+"<br/>");
}

f(1,2,3,4,5,6) 








