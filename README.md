# website

## node

install node and npm. 

## make

Install required node modules.
```
make modules
```

## python  

Any recent python version.  I use miniconda3.

## python env

Create a new virtual env.  Don't need any other python packages, just nbconvert and 
its dependencies.   We don't edit the ipynb files in this virtual env. It is only 
used to convert them to markdown.
```
conda create -n website python nbconvert
```
usually not required to manually activate and deactivate the env.  The makefile takes care of
it.  Use the following if needed:
```
conda activate website
conda deactivate
```

## building website

The most common commands:
```
make clean     # delete public website folder
make allclean  # delete public website, generated assets, converted ipynb files.
make modules   # install node modules
make ipynb     # convert to markdown
make serve     # local test server, includes drafts
make build     # build public website, excl drafts
make publish   # deploy to github pages
```
