---
title: "KNNImputer: Imputing missing values"
date: 2020-04-08
subtitle: ''
description: ''
tags: [ml, preprocessing]
---
Replace blanks, NaNs or other placeholders with numerical values. Machine learning usually expects all data to be in arrays without any missing values. One strategy is to delete all rows with missing data, but this is especially bad in small datasets.  A better solution is to infer the values from the data that is present. This class uses K-Nearest Neighbors to infer the new values

## sklearn.impute.KNNImputer

```
sklearn.impute.KNNImputer(missing_values=nan, n_neighbors=5, weights='uniform')
```
### data

works with anything that `numpy.asarray` can convert to a matrix, including pandas dataframes.

### missing_values:

* `np.nan` (default)
* `number`
* `None`


## weights:

* `uniform` (default) all point have equal weight  
* `distance` euclidean distance where closer points have greater weight

### Methods

* `fit(X)` returns SimpleImputer
* `transform(X)` returns transformed array
* `fit_transform(X)` returns transformed array



```python
import numpy as np
from sklearn.impute import KNNImputer

X = np.array([[1, 2, np.nan], [3, 4, 3], [np.nan, 6, 5], [8, 8, 7]])
print(X)
```

    [[ 1.  2. nan]
     [ 3.  4.  3.]
     [nan  6.  5.]
     [ 8.  8.  7.]]



```python
imputer = KNNImputer(n_neighbors=2, missing_values=np.nan, weights='distance')
print(imputer.fit_transform(X))
```

    [[1.  2.  4. ]
     [3.  4.  3. ]
     [5.5 6.  5. ]
     [8.  8.  7. ]]

