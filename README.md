## ArchivesSpace resource tree API extension plugin

A plugin for ArchivesSpace that adds API enpoints to enable retrieval of specified branches of a resource tree.

## Installation

1. Copy the 'resource_tree_api_extension' directory to the 'plugins' directory in ArchivesSpace
2. Add the plugin to the list of plugin to load in `config/config.rb`:

```
AppConfig[:plugins] = ['local', 'lcnaf', 'resource_tree_api_extension']
```


## Endpoints


###[:GET] /repositories/:repo_id/resources/:id/children

Get the archival object children of an Resource

####Parameters

Both parameters are required an, Repository and Resource must exist.

* id (integer) – The ID of the resource
* repo_id (integer) – The Repository ID

####Returns

* 200 – a list of archival object references
* 404 – Not found
