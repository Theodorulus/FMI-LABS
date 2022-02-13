# character
a <- "text"
typeof(a)

# numeric/double
b = 3.5
typeof(b)

# integer
x = 2L
typeof(x)
x

# logical
t = T
f = F
typeof(t)
typeof(f)

# complex
typeof(1 + 3i)

# vector
v = vector("numeric", 10)
v

numeric(10)
character(10)
logical(10)

# c() -> concatenare
x = c(1, 2.5, 6)
x
x = c(0, x)
x
x = c(x, 7)
x

y = c(1.5, TRUE, FALSE, 5L)
y
y = c(1.5, TRUE, "test", 5L) 
y

# progresii + sequence
1:10
1.3:10
10:1

seq(2, 8, by = 0.5)
seq(2, 8, length.out = 10)

rep(1:4, each = 2)
rep(1:4, c(2, 2, 3, 4))

a = 1:10
b = 5

a + b

a = 1:10
b = 1:4

a + b
c(b, b, 1:2)

exp(a)
sin(a)
min(a)
max(a)
prod(a)
length(a)
unique(c(1, 2, 2, 3, 1, 4))

table(c(1, 2, 2, 3, 1, 4))

# []
a = 1:10
a[c(1, 3, 7)]
a[-5] # ->toate elem inafara de cel de pe pozitia 5
a[-c(1, 3, 7)]

a > 4

a[a>4]

a[(a > 2) & (a < 7)]







