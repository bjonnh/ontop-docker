# Create Ontop RDF4J Workbench repositories from SQL databases

Usage
## Create configs

Create a configs/<yourendpoint> directory that contains the following files:

- **id**: a text file that contains the identifier (must be URL compatible)
- **title**: a text file that contains the title of that directory
- **mapping.obda**: the obda mapping file
- **ontology.owl**: the associated ontology
- **jdbc.properties**: the configuration for the database

```
docker build . -t wb
docker run -it --rm --name wb -v $PWD/configs:/configs wb
```

# TODO

- [ ] Support R2RML format if present
- [ ] Allow user to add new repositories by running a script (refactor the for loop?)
- [ ] Add a healtcheck instead of a hardcoded sleep
