matrix(1:12, nrow = 4)

m = matrix(1:12, nrow = 4, byrow = T)
m
m[1,3]
m[,1]
m[2,]

# cbind, rbind

dim(m)
t(m) #transpusa

m %*% t(m)

det(m %*% t(m))

solve(m %*% t(m)) # nu merge pentru ca det e 0

a = matrix(c(1:8, 10), 3)
det(a)

solve(a) %*% a

l = list(a = 1, b = 1:10, c = TRUE)

str(l)

str(l[2])

l[[2]]

l[1] = NULL
l


#data.frame

d = data.frame(
  a = 1:3,
  b = c("a", "b", "c")
)
str(d)

str(iris)

head(iris)