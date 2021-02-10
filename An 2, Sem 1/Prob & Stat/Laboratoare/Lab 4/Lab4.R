f1 = function(x = 1, y = 1 ){
  return(x + y)
}

f1(2)
f1(x = 5)
f1(y = 3)

f2 = function(x = 1, y = 1, ... ){
  plot(x, y, ...)
}

f2 (y = 3, col = "red")

paste("sir1", "sir2", "sir3")
args(paste)

x = 1.5

if(x > 2){
  print(x)
}else if (x > 0){
  print(x ^ 2)
}else{
  print("Mai mic decat 0")
}

v = 1:10

ifelse(v %% 2 == 0, "par", "impar")

for (i in v){
  print(i)
}

vector = letters[1:10]

for (i in vector){
  print(i)
}

for (i in seq_along(vector)){
  print(vector[i])
}

# M - 1000 x 1000 cu elementele M[i,j] = sin(i) / cos(j ^ 2)
# outer



M = matrix(0, nrow = 1000, ncol = 1000)

for (i in 1:nrow(M)){
  for(j in 1:nrow(M)){
    M[i,j] = sin(i) / cos(j^2)
  }
}

options(max.print=1000000)

print(M)

?outer

f3 = function(x, y){
  sin(x) / cos(y ^ 2)
}
f3 (1,1)

omie = 1:1000

M3 = matrix(0, nrow = 10000, ncol = 10000)
start = proc.time()
for (i in 1:nrow(M)){
  for(j in 1:nrow(M)){
    M[i,j] = sin(i) / cos(j^2)
  }
}
proc.time()-start

start = proc.time()
M2 = outer(omie, omie, FUN = f3 )
proc.time()-start

rm(M3, M2)

my_sqrt = function(x, tol = 1e-8){ # 1e-8 = 10^-8
  if (x < 0) stop("Nr. negativ.")
  y = x / 2
  while(abs(y ^ 2 - x) > tol){
    y = (y + x / y) * 0.5
  }
  return (y)
}
my_sqrt(16)
my_sqrt(1024)
my_sqrt(2)
my_sqrt(1)

x = seq(0, 2 * pi, length.out = 100)

y = sin(x)
plot(x, y, type = "l", main = "Graficul functiei sin", xlab = "t", ylab = "sin(t)", col = "red", lwd = 5, lty = 2, bty = "n", 
     xlim = c(1,5), cex.axis = 0.7)

z = cos(x)
plot(x, z, type = "l", main = "Graficul functiei cos", xlab = "t", ylab = "cos(t)", col = "red", lwd = 5, lty = 2, bty = "n")

points(x, z, col = "blue", lwd = 5, lty = 2) # deseneaza peste graficul deja desenat cu puncte

lines(x, z, col = "blue", lwd = 5, lty = 2) # # deseneaza peste graficul deja desenat cu linie punctata



x1 = seq(-5, 10, length.out = 15)

y1 = ifelse(x1 < 0, x1^2, x1)



plot(x1, y1, type = "l",
     
     xlab = "t",
     
     ylab = "sin(t)",
     
     col = "red",
     
     lwd = 3,
     
     lty = 2,
     
     bty = "n",
     
     cex.axis = 0.7)



x2=seq(0,2*pi,length.out = 50)

y2=sin(x2^2)+cos(x2^2)

z2=2*sin(x2)*cos(x2)



plot(x2,y2,type= "l",
     
     main="Graficul a 3 functii",
     
     xlab="x",
     
     ylab="func(x)",
     
     lwd=4,
     
)


lines(x2, z2, col="red", lwd=3)


f4 = function(x){
  if(x > 0){
    sin(x^2)*log(x)
  }else{
    exp(x)/(2 + cos(x^3))
  }
}

f4 = Vectorize(f2, "x4")

x4 = seq(-2, 2, length.out = 100)
y4 = f4(x4)

plot(x4, y4, type = "l")



a = sample(c("H", "T"), 1000, replace = TRUE)
pH = sum(a == "H")/ length(a)
pH

a1 = sample(c("H", "T"), 1000, replace = TRUE, prob = c(0.3, 0.7))
pH1 = sum(a1 == "H")/ length(a1)
pH1



















