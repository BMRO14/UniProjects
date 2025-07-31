import numpy as np
import matplotlib.pyplot as plt

import pandas as pd
import seaborn as sns

from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

data = pd.read_csv('iris.data', header=None)
data.columns = ['SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth', 'Class']
classes=['Iris-setosa', 'Iris-versicolor','Iris-virginica']

print('\n')
print(data.head(3))

print('\n')
print(data.describe())

plt.close()
sns.pairplot(data, hue='Class')

X=data.iloc[:, 4]
T=data['Class'].replace(classes,[0,1,2])

xTrain, xTest, tTrain, tTest = train_test_split(X,T, test_size = 0.2)

net=MLPClassifier(solver='sgd', alpha=1e-5, verbose=1, max_iter=1000, 
                  hidden_layer_sizes=(3, 3), random_state = 1)

net.fit(xTrain, tTrain)

yTest = net.predict(xTest)
print('The accuracy is:',accuracy_score(tTest,yTest)) # accuracy_score(y_true, y_pred)
print('Confusion Matrix is: ')
print(confusion_matrix(tTest,yTest)) # confusion_matrix(y_true, y_pred) - ON LINES!!!

plt.figure()
loss_values = net.loss_curve_
plt.plot(loss_values)
plt.title('Loss function')