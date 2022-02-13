# -*- coding: utf-8 -*-
"""Lab3.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1Z8dQsVMdzDCgu8-EohUhWy8i_vm455Xy
"""

!unzip data_MNIST\ .zip

import numpy as np
import matplotlib.pyplot as plt
import math

#1
class KnnClassifier:
  def __init__(self, train_images, train_labels):
    self.train_images = train_images
    self.train_labels = train_labels
  #2
  def classify_image(self, test_image, num_neighbors = 3, metric = 'l2'):
    if metric == 'l1':
      distances = np.sum(abs(self.train_images - test_image), axis = 1)
    else:
      distances = np.sqrt(np.sum((self.train_images - test_image) ** 2, axis = 1))
    indx = np.argsort(distances)
    vec = indx[:num_neighbors] #vecinii
    label_vecini = self.train_labels[vec]
    vote = np.bincount(label_vecini)
    return np.argmax(vote)
    '''
    temp = []
    if metric == 'l1':
      temp = [(ind, sum(np.absolute(img - test_image))) for ind, img in enumerate(self.train_images)]
    else:
      temp = [(ind, math.sqrt(sum((img - test_image)**2))) for ind, img in enumerate(self.train_images)]
    temp.sort(key=lambda x: x[1])
    temp = temp[:num_neighbors]
    ind, pred = max(set(temp), key=temp.count)
    return train_labels[ind]
    '''
  #pentru 3
  def classify_images(self, test_images, num_neighbors = 3, metric = 'l2'):
    nr = test_images.shape[0]
    predict = np.zeros(nr, np.int)
    for i in range(nr):
      predict[i] = self.classify_image(test_images[i, :], num_neighbors = num_neighbors, metric = metric)
    return predict




train_images = np.loadtxt('data/train_images.txt')
train_labels = np.loadtxt('data/train_labels.txt').astype(np.int)

test_images = np.loadtxt('data/test_images.txt')
test_labels = np.loadtxt('data/test_labels.txt').astype(np.int)

KNN = KnnClassifier(train_images, train_labels)
print("Image classified as: ", KNN.classify_image(test_images[0]))
print("Actual image number:", test_labels[0])

#3
predict = KNN.classify_images(test_images, 3, metric = 'l2')
accuracy = (test_labels==predict).mean()
print("Accuracy: ", accuracy)
np.savetxt('predictii_3nn_l2_mnist.txt', [accuracy])

#4.a
n_neighbors = [1, 3, 5, 7, 9] 
predictions = [[KNN.classify_image(img, num_neighbors=i) for img in test_images] for i in n_neighbors]
accuracies = [(np.sum(predictions[i] == test_labels) / len(test_labels)) for i in range(len(predictions))]

plt.plot(n_neighbors, accuracies)
plt.xlabel('number of neighbors')
plt.ylabel('accuracy')
#plt.show()
with open('acuratete_l2.txt', 'w') as f:
    f.write(str(accuracies))

#4.b
def calc_accuracies(num_neighbours, dist):
    scores = []
    for n in num_neighbours:
        acc = (KNN.classify_images(test_images, n, dist) == test_labels).mean()
        scores.append(acc)
    return scores


num_neighbours = [1, 3, 5, 7, 9]
scores_l2 = calc_accuracies(num_neighbours, 'l2')

np.savetxt('acuratete_l2.txt', scores_l2)

plt.plot(num_neighbours, scores_l2)
#plt.show()

scores_l2 = np.loadtxt('acuratete_l2.txt')
scores_l1 = calc_accuracies(num_neighbours, 'l1')

plt.plot(num_neighbours, scores_l2)
plt.plot(num_neighbours, scores_l1)
plt.legend(['L2', 'L1'])
plt.show()

class KnnRegressor:

    def __init__(self, X, y):
        self.X = X
        self.y = y

    def classify_sample(self, t, num_neighbors=3, metric='l2'):
        if metric == 'l1':
            distances = np.sum(abs(self.X - y), axis = 1)
        else:
            distances = np.sqrt(np.sum((self.X - y) ** 2, axis = 1))

        indx = np.argsort(distances)
        vec = indx[:num_neighbors] #vecinii
        label_vecini = self.train_labels[vec]
        

        # CODE GOES HERE
        result = 0

        return result
    
    def classify_samples(self, ts, num_neighbors = 3, metric = 'l2'):
        nr = ts.shape[0]
        predict = np.zeros(nr, np.int)

        for i in range(nr):
            predict[i] = self.classify_sample(ts[i, :], num_neighbors = num_neighbors, metric = metric)

        return predict

import sklearn.datasets as datasets

X, y = datasets.load_boston(return_X_y = True)

KnnR = KnnRegressor(X, y)