import numpy as np
from PIL import Image
import tensorflow as tf
from tensorflow.keras import layers
from tensorflow.keras import regularizers
from sklearn.preprocessing import StandardScaler

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

scaler = StandardScaler()

X_train_scaled = scaler.transform(train_images)
X_validation_scaled = scaler.transform(validation_images)

# MODEL CU BIAS REGULIZER

# imaginile au marimea de 32x32
inputs = tf.keras.Input(shape=(32, 32, 1))

# cream o stiva de layere Conv2D si MaxPooling2D
x = layers.Conv2D(filters=16, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True, bias_regularizer=regularizers.l2(1e-3))(inputs)
x = layers.MaxPooling2D()(x)
x = layers.Conv2D(filters=32, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True, bias_regularizer=regularizers.l2(1e-3))(x)
x = layers.MaxPooling2D(pool_size=(2, 2))(x)
x = layers.Conv2D(filters=64, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True, bias_regularizer=regularizers.l2(1e-3))(x)
# adagam la stiva si Dropout pentru a reduce overfitting-ul
x = layers.Dropout(0.4)(x)

x = layers.Flatten()(x)

outputs = layers.Dense(10, activation='softmax')(x)

model = tf.keras.Model(inputs=inputs, outputs=outputs)

model.summary()

# compilam modelul cu optimizer Adam si learning rate 0.0003
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=3e-4), loss=tf.keras.losses.SparseCategoricalCrossentropy(), metrics='accuracy')

# antrenam modelul cu batch size 256 si 32 de epoci
# trebuie folosit reshape pe X_train_scaled si X_validation_scaled pentru a avea acelasi size cu input-ul modelului
# folosim shuffle pentru a amesteca datele si a antrena mai bine modelul
model.fit(X_train_scaled.reshape(-1, 32, 32, 1), train_labels, batch_size=256, epochs=32, validation_data=(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels), shuffle=True)

model.evaluate(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels)

predictions = model.predict(X_validation_scaled.reshape(-1, 32, 32, 1), batch_size=256)
p = []
for x in predictions:
  y = np.argmax(x)
  p.append(y)
p = np.array(p)
print("Confusion matrix:")
conf = confusion_matrix(validation_labels, p)
print_confusion_matrix(conf)

# compilam modelul cu optimizer Adam si learning rate 0.0003
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=3e-4), loss=tf.keras.losses.SparseCategoricalCrossentropy(), metrics='accuracy')

# Dupa recompilarea modelului
# reantrenam modelul cu batch size 64 si 32 de epoci
model.fit(X_train_scaled.reshape(-1, 32, 32, 1), train_labels, batch_size=64, epochs=32, validation_data=(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels), shuffle=True)

model.evaluate(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels)
predictions = model.predict(X_validation_scaled.reshape(-1, 32, 32, 1), batch_size=64)
p = []
for x in predictions:
  y = np.argmax(x)
  p.append(y)
p = np.array(p)
print("Confusion matrix:")
conf = confusion_matrix(validation_labels, p)
print_confusion_matrix(conf)

# MODEL FARA BIAS REGULIZER

inputs = tf.keras.Input(shape=(32, 32, 1))

x = layers.Conv2D(filters=16, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True)(inputs)
x = layers.MaxPooling2D()(x)
x = layers.Conv2D(filters=32, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True)(x)
x = layers.MaxPooling2D(pool_size=(2, 2))(x)
x = layers.Conv2D(filters=64, kernel_size=(3, 3), padding="same", activation="relu", use_bias=True)(x)
x = layers.Dropout(0.4)(x)

x = layers.Flatten()(x)

outputs = layers.Dense(10, activation='softmax')(x)

model = tf.keras.Model(inputs=inputs, outputs=outputs)

model.summary()

# compilam noul model cu optimizer Adam si learning rate 0.003
model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=3e-3), loss=tf.keras.losses.SparseCategoricalCrossentropy(), metrics='accuracy')

# antrenam noul model cu batch size 256 si 8 de epoci
model.fit(X_train_scaled.reshape(-1, 32, 32, 1), train_labels, batch_size=256, epochs=8, validation_data=(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels), shuffle=True)

model.evaluate(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels)
predictions = model.predict(X_validation_scaled.reshape(-1, 32, 32, 1), batch_size=256)
p = []
for x in predictions:
  y = np.argmax(x)
  p.append(y)
p = np.array(p)
print("Confusion matrix:")
conf = confusion_matrix(validation_labels, p)
print_confusion_matrix(conf)

# Dupa recompilarea modelului
# reantrenam noul model cu batch size 128 si 8 de epoci
model.fit(X_train_scaled.reshape(-1, 32, 32, 1), train_labels, batch_size=128, epochs=8, validation_data=(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels), shuffle=True)

model.evaluate(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels)
predictions = model.predict(X_validation_scaled.reshape(-1, 32, 32, 1), batch_size=128)
p = []
for x in predictions:
  y = np.argmax(x)
  p.append(y)
p = np.array(p)
print("Confusion matrix:")
conf = confusion_matrix(validation_labels, p)
print_confusion_matrix(conf)

# Dupa recompilarea modelului
# reantrenam noul model cu batch size 64 si 8 de epoci
model.fit(X_train_scaled.reshape(-1, 32, 32, 1), train_labels, batch_size=64, epochs=8, validation_data=(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels), shuffle=True)

model.evaluate(X_validation_scaled.reshape(-1, 32, 32, 1), validation_labels)
predictions = model.predict(X_validation_scaled.reshape(-1, 32, 32, 1), batch_size=64)
p = []
for x in predictions:
  y = np.argmax(x)
  p.append(y)
p = np.array(p)
print("Confusion matrix:")
conf = confusion_matrix(validation_labels, p)
print_confusion_matrix(conf)