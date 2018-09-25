class Trees

  def tree_level(parent = nil, display_mode = :full)
    parent_id = parent ? parent.id : nil
    parent ||= self

    query = build_node_query
    # limit query to children
    query = query.filter(:parent_id => parent_id)

    # And check whether the children have children as cheaply as possible
    has_children = {}
    ids_of_interest = []
    self.class.node_model.
         filter(:parent_id => parent_id,
                :root_record_id => self.id).
         select(:id).all.each do |row|
      ids_of_interest << row[:id]
    end

    self.class.node_model.filter(:parent_id => ids_of_interest).distinct.select(:parent_id).all.each do |row|
      has_children[row[:parent_id]] = true
    end

    properties = {}
    root_type = self.class.root_type
    node_type = self.class.node_type

    offset = 0
    children = {}

    while true
      nodes = query.limit(NODE_PAGE_SIZE, offset).all

      nodes.each do |node|
        properties[node.id] = {
          :title => node[:title],
          :id => node.id,
          :record_uri => self.class.uri_for(node_type, node.id),
          :publish => node.respond_to?(:publish) ? node.publish===1 : true,
          :suppressed => node.respond_to?(:suppressed) ? node.suppressed===1 : false,
          :node_type => node_type.to_s
        }
        properties[node.id]['has_children'] = !!has_children[node.id]

        unless display_mode == :sparse
          load_node_properties(node, properties)
        end
        children[node.position] = properties[node.id]
      end

      if nodes.empty?
        break
      else
        offset += NODE_PAGE_SIZE
      end
    end

    result = {
      title: parent.title,
      id: parent.id,
      record_uri: parent.uri,
      node_type: parent.class.to_s.underscore,
      publish: parent.respond_to?(:publish) ? parent.publish===1 : true,
      suppressed: parent.respond_to?(:suppressed) ? parent.suppressed===1 : false,
      children: children.sort.map { |n| n[1] }
    }

    unless display_mode == :sparse
      if parent.respond_to?(:finding_aid_filing_title) && !parent.finding_aid_filing_title.nil? && parent.finding_aid_filing_title.length > 0
        result[:finding_aid_filing_title] = parent.finding_aid_filing_title
      end

      if parent_id
        node_props = { parent.id => result.clone }
        load_node_properties(parent, node_props)
        result = node_props[parent.id]
      else
        load_root_properties(result)
      end
    end

    JSONModel("#{self.class.root_type}_tree".intern).from_hash(result, true, true)
  end

end
