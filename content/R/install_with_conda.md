---
title: "Install with conda"
date: 2020-11-19T15:28:53Z
subtitle: 'how to create a R environment using conda'
description: ''
draft: true
---

Install a recent version of minconda. 


First steo is to find latest version of r-base in the r channel.   Don't use the conda-forge versions.

```bash
conda search -c r  r-base
```

Lets asume it is version 3.6.1, which was the latest at the time of writing.  Create a new empty environment
with this version number as part of the environment name.

```bash
conda create -n r_361
conda activate r_361
```

Configure the search path in this new enviornment

```bash
conda config --env --add channels conda-forge
conda config --env --add channels defaults
conda config --env --add channels r
# conda config --env --add channels bioconda
conda config --show channels
```

Finally install R and RStudio

```bash
conda install r-base r-essentials
conda install rstudio
```

Some additional packages that is need

```bash
conda install r-catools
```

### Deleting an environment

Don't be afraid to remove and recreate environments.

```bash
conda env remove -n r_361
```




