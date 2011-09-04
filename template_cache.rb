module ViewMesh
  class TemplateCache

    def initialize template_key
      @template_key = template_key
    end

    def add response
      etag = response.headers["etag"]
      last_modified = response.headers["last-modified"]
      $cache.set(@template_key, {:etag => etag, :last_modified => last_modified, :body => response.body})
    end

    def body_content
      content[:body]
    end

    def is_cached?
     content.present?
    end

    def content
      $cache.get(@template_key)
    end

  end
end
