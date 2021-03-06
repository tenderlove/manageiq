class ApiController
  module Tags
    #
    # Tags Subcollection Supporting Methods
    #
    # Signature <<subcollection>>_<<action>>_resource(object, type, id, data)
    #

    def tags_query_resource(object)
      object ? object.tags : {}
    end

    def tags_assign_resource(object, _type, id = nil, data = nil)
      category, name = tag_specified(id, data)
      ci_set_tag(object, category, name)   if category && name
    end

    def tags_unassign_resource(object, _type, id = nil, data = nil)
      category, name = tag_specified(id, data)
      ci_unset_tag(object, category, name) if category && name
    end

    #
    # Helper Procs
    #

    private

    def tag_specified(id, data)
      if id.to_i > 0
        klass  = collection_config[:tags][:klass].constantize
        tagobj = klass.find(id)
        return tag_path_to_name(tagobj.name) unless tagobj.id.blank?
      end

      parse_tag(data)
    end

    def parse_tag(data)
      return [nil, nil] if data.blank?

      category = data["category"]
      name     = data["name"]
      return [category, name] if category && name
      return tag_path_to_name(name) if name && name[0] == '/'

      parse_tag_from_href(data)
    end

    def parse_tag_from_href(data)
      href = data["href"]
      tag  = if href && href.match(%r{^.*/tags/[0-9]+$})
               klass = collection_config[:tags][:klass].constantize
               klass.find(href.split('/').last)
             end
      tag.present? ? tag_path_to_name(tag.name) : [nil, nil]
    end

    def tag_path_to_name(path)
      tag_path = (path[0..7] == TAG_NAMESPACE) ? path[8..-1] : path
      parts    = tag_path.split('/')
      [parts[1], parts[2]]
    end

    def ci_set_tag(ci, category, name)
      return true if ci.is_tagged_with?(name, :ns => "#{TAG_NAMESPACE}/#{category}")
      Classification.classify(ci, category, name)
    end

    def ci_unset_tag(ci, category, name)
      return true unless ci.is_tagged_with?(name, :ns => "#{TAG_NAMESPACE}/#{category}")
      Classification.unclassify(ci, category, name)
    end
  end
end
