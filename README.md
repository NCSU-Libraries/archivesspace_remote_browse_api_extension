## ArchivesSpace remote browse API extension plugin

A plugin for ArchivesSpace that adds API enpoints to enable discovery and browse of resource contents from a remote host application.

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

Both parameters are required, and Repository and Resource must exist.

* id (integer) – The ID of the resource
* repo_id (integer) – The Repository ID

####Returns

* 200 – a list of archival object references
* 404 – Not found


###[:GET] /repositories/:repo_id/resources/:id/tree_level

Get the archival object children of a specified parent within a resource. Retuns children of root if no parent_uri is supplied

####Parameters

`id` and `resource_id` are required and Repository and Resource must exist.

* id (integer) – The ID of the resource
* repo_id (integer) – The Repository ID
* parent_uri (string) - URI of the parent record (defaults to root if not provided)
* display_mode (string) - 'sparse' or 'full' (default)

####Returns

* 200 – a list of archival object references
* 404 – Not found

