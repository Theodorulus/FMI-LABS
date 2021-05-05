import numpy as np
from PIL import Image
from sklearn.preprocessing import StandardScaler
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score

# citim numele imaginilor de training
fin = open("train.txt")
train = fin.read().split("\n")
fin.close()
print(train)

# impart lista "train" dupa ','
for i in range(len(train)):
  train[i] = train[i].split(",")
del train[-1] # "\n" -> cauza o eroare

# initializam array-urile pentru imagini si labels
train_images = np.array([])
train_labels = np.array([])

# citesc imaginile din folderul "train"
for x in train:
  print(x[0]) # printez numele imaginii pentru a sti statusul citirii (deoarece dureaza foarte mult)
  image = Image.open("train/" + x[0])
  img = np.asarray(image)
  train_images = np.append(train_images, img)
  train_labels = np.append(train_labels, x[1])

print(train_images.shape)
# obervam shape de (30721024,)
# asa ca dam reshape la (30001(nr de imagini), 1024(dimensiunea imaginilor -> 32 * 32))
train_images = train_images.reshape(30001,1024)
# transformam etichetele in variabile de tip int
train_labels = train_labels.astype(np.int)

print(train_images.shape)
#observam ca avem shape-ul dorit

# citim imaginile pentru validare la fel ca pe cele de training
fin = open("validation.txt")
validation = fin.read().split("\n")
for i in range(len(validation)):
  validation[i] = validation[i].split(",")
del validation[-1] # "\n"

validation_images = np.array([])
validation_labels = np.array([])

for x in validation:
  print(x[0])
  image = Image.open("validation/" + x[0])
  img = np.asarray(image)
  validation_images = np.append(validation_images, img)
  validation_labels = np.append(validation_labels, x[1])

#la fel ca la training, face reshape la datele de validare
print(validation_images.shape)

validation_images = validation_images.reshape(5000,1024)
validation_labels = validation_labels.astype(np.int)

print(validation_images.shape)

print(train_images.min())
print(train_images.max())

print(train_labels.min())
print(train_labels.max())

# observam ca valorile pixelilor se afla intre 0 si 255
# observam ca valorile etichetelor se afla intre 0 si 8

def confusion_matrix(actual_labels, predicted_labels):
    A = np.zeros((9, 9)).astype(np.int)
    for i in range(len(actual_labels)):
        A[actual_labels[i]][predicted_labels[i]] += 1
    return A

def print_confusion_matrix(A):
  print(end="      ")
  for i in range(9):
    print(i, end="    ")
  print()
  for i in range(len(A)):
    print(i, end=": ")
    x = A[i]
    for y in x:
      if y < 10:
        print(end="   ")
      elif y < 100:
        print(end="  ")
      elif y < 1000:
        print(end=" ")
      print(y, end=" ")
    print()

# Citesc imaginile de test, la fel ca si celelalte doua seturi de imagini
fin = open("test.txt")
test = fin.read().split("\n")
del test[-1] # "\n"

test_images = np.array([])

for x in test:
  print(x)
  image = Image.open("test/" + x)
  img = np.asarray(image)
  test_images = np.append(test_images, img)

# La fel ca la celelalte doua seturi de imagini, observam ca nu avem shape-ul dorit, asa ca facem reshape.
print(test_images.shape)
test_images = test_images.reshape(5000,1024)
print(test_images.shape)

def predict_test(p):
  fout = open("prediction.csv", "w")
  i = 0
  fout.write("id,label" + "\n")
  for x in p:
    fout.write(test[i] + "," + str(x) + "\n")
    i += 1

# Normalizam datele folosind un StandardScaler din sklearn
scaler = StandardScaler()

X = scaler.fit_transform(train_images)
X_validation = scaler.transform(validation_images)

y = train_labels
y_validation = validation_labels

def predict_mlp_and_print_confusion_matrix(activation, hidden_layer_sizes, learning_rate_init, momentum, max_iter):
  mlp_classifier_model = MLPClassifier(activation=activation, hidden_layer_sizes=hidden_layer_sizes, learning_rate_init=learning_rate_init, momentum=momentum, max_iter=max_iter)
  mlp_classifier_model.fit(X, y)
  p = mlp_classifier_model.predict(X_validation)

  accuracy = accuracy_score(p, y_validation)
  print("Accuracy: ", accuracy)
  print("Confusion matrix:")
  conf = confusion_matrix(validation_labels, p)
  print_confusion_matrix(conf)
  return p

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(1), learning_rate_init=1e-2, momentum=0, max_iter=200)

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=1e-2, momentum=0, max_iter=200)

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=1e-5, momentum=0, max_iter=200)

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=10, momentum=0, max_iter=200)

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(10), learning_rate_init=1e-2, momentum=0, max_iter=20)

predict_mlp_and_print_confusion_matrix(activation='tanh', hidden_layer_sizes=(10, 10), learning_rate_init=1e-2, momentum=0, max_iter=2000)

predict_mlp_and_print_confusion_matrix(activation='relu', hidden_layer_sizes=(10, 10), learning_rate_init=1e-2, momentum=0, max_iter=2000)

predict_mlp_and_print_confusion_matrix(activation='relu', hidden_layer_sizes=(100, 100), learning_rate_init=1e-2, momentum=0, max_iter=2000)