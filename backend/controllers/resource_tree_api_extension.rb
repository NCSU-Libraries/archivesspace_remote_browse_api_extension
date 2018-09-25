class ArchivesSpaceService < Sinatra::Base

  Endpoint.get('/repositories/:repo_id/resources/:id/children')
    .description("Get the children of an Archival Object")
    .params(["id", :id],
            ["repo_id", :repo_id])
    .permissions([:view_repository])
    .returns([200, "a list of archival object references"],
             [404, "Not found"]) \
  do
    resource = Resource.get_or_die(params[:id])
    json_response(resource.children.map {|child|
                    ArchivalObject.to_jsonmodel(child)
                  })
  end


  Endpoint.get('/repositories/:repo_id/resources/:id/tree_level')
    .description("Get the children of a given parent node as a single level of a Resource tree.
        Returns children of resource if no parent_uri is provided.")
    .params(["id", :id],
            ["parent_uri", String, "An Archival Object URI", :optional => true],
            ["display_mode", String, "Specifies format of node data in response -
                'sparse' or 'full', defaults to 'full'", :optional => true],
            ["repo_id", :repo_id])
    .permissions([:view_repository])
    .returns([200, "OK"]) \
  do
    resource = Resource.get_or_die(params[:id])

    if params[:parent_uri]
      ref = JSONModel.parse_reference(params[:parent_uri])
      if ref
        parent = ArchivalObject[ref[:id]]
      else
        raise BadParamsException.new(:limit_to => ["Invalid value"])
      end
    else
      parent = nil
    end

    display_mode = (params[:display_mode] && params[:display_mode] == 'sparse') ? :sparse : :full
    tree = resource.tree_level(parent, display_mode)
    json_response(tree)
  end

end
