---
title: "Sample Data"
date: 2020-12-04
subtitle: 'Samples included or made available by standard libraries'
description: ''
tags: [ml, samples]
---
## scikit-learn

See the documentation at <https://scikit-learn.org/stable/datasets/index.html>

### Included datasets  (sklearn.datasets)


For all included datasets below use `return_X_y=True` parameter to return `(X,y)`, otherwise a Bunch dictlike object will be returned with various attributes including `data, target, feature_names, target_names`.   Use `as_frame=True` to return `pandas DataFrame or Series` objects

* `load_boston(*[, return_X_y])` (regression).
* `load_iris(*[, return_X_y, as_frame])` (classification).
* `load_diabetes(*[, return_X_y, as_frame])` (regression).
* `load_digits(*[, n_class, return_X_y, as_frame])` (classification).
* `load_linnerud(*[, return_X_y, as_frame])` (multi-ouput regression)
* `load_wine(*[, return_X_y, as_frame])` (classification).
* `load_breast_cancer(*[, return_X_y, as_frame])` (classification).


```python
from sklearn import datasets
X, y = datasets.load_boston(return_X_y=True)
X.shape
```




    (506, 13)



### Large Datasets (sklearn.datasets)

These datasets are not included in the library but must be downloaded from the internet. The `data_home` parameter is the download location, `~/scikit_learn_data` if not specified.  Usually easier to just work with the Bunch objects for return values.

* `fetch_olivetti_faces(*[, data_home, …])` (classification)
* `fetch_20newsgroups(*[, data_home, subset, …])` (classification).
* `fetch_20newsgroups_vectorized(*[, subset, …])` (classification).
* `fetch_lfw_people(*[, data_home, funneled, …])` (classification).
* `fetch_lfw_pairs(*[, subset, data_home, …])` (classification).
* `fetch_covtype(*[, data_home, …])` (classification).
* `fetch_rcv1(*[, data_home, subset, …])` (classification).
* `fetch_kddcup99(*[, subset, data_home, …])` (classification).
* `fetch_california_housing(*[, data_home, …])` (regression).


```python
from sklearn import datasets
from pprint import pprint
newsgroups_train = datasets.fetch_20newsgroups(subset='train')
pprint(list(newsgroups_train.target_names))
```

    ['alt.atheism',
     'comp.graphics',
     'comp.os.ms-windows.misc',
     'comp.sys.ibm.pc.hardware',
     'comp.sys.mac.hardware',
     'comp.windows.x',
     'misc.forsale',
     'rec.autos',
     'rec.motorcycles',
     'rec.sport.baseball',
     'rec.sport.hockey',
     'sci.crypt',
     'sci.electronics',
     'sci.med',
     'sci.space',
     'soc.religion.christian',
     'talk.politics.guns',
     'talk.politics.mideast',
     'talk.politics.misc',
     'talk.religion.misc']

