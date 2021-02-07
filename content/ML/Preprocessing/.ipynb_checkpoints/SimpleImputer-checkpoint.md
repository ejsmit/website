---
title: "SimpleImputer: Imputing missing values"
date: 2020-12-04
subtitle: ''
description: ''
tags: [ml, preprocessing]
---
Replace blanks, NaNs or other placeholders with numerical values. Machine learning usually expects all data to be in arrays without any missing values. One strategy is to delete all rows with missing data, but this is especially bad in small datasets.  A better solution is to infer the values from the data that is present. 

## sklearn.impute.SimpleImputer

```
sklearn.impute.SimpleImputer(missing_values=nan, strategy='mean', fill_value=None)
```

### data

works with anything that `numpy.asarray` can convert to a matrix, including pandas dataframes.

### strategy


* `mean` (numeric) (default)
* `median` (numeric)
* `most_frequent` (string or numeric)
* `constant` (string or numeric) requires `fill_value`

### missing_values

* `np.nan` (default)
* `number`
* `None`

Support strings or pandas categories with `most_frequent` or `constant` strategies


### Methods

* `fit(X)` returns SimpleImputer
* `transform(X)` returns transformed array
* `fit_transform(X)` returns transformed array



```python
import numpy as np
from sklearn.impute import SimpleImputer

X = np.array([[1, 2], [np.nan, 3], [7, 6]])
X
```




    array([[ 1.,  2.],
           [nan,  3.],
           [ 7.,  6.]])




```python
imputer = SimpleImputer(missing_values=np.nan, strategy='mean')
X = imputer.fit_transform(X)
X
```




    array([[1., 2.],
           [4., 3.],
           [7., 6.]])


