# installation

conda env create -f environment.yml
conda env list

pip install --upgrade mkdocs-material

conda activate website

## vscode

vscode-yaml

settings.json
{
  "yaml.schemas": {
    "https://squidfunk.github.io/mkdocs-material/schema.json": "mkdocs.yml"
  }
}


## Previewing site

mkdocs serve

## Building site

mkdocs build

## Publish site

mkdocs gh-deploy --force

Currently configured to use github actions, so just commit to main branch.
