require 'proxy'


module ViewMesh

  HEADER_CACHE = {}

  class ProxyParty
    include HTTParty
    http_proxy Proxy::HOST, Proxy::PORT if Proxy.as_url
  end

  class TemplateLoader

    def initialize template_name
      @template_name = template_name
      @template_cache = ViewMesh::TemplateCache.new(template_name)
    end

    def get_content
      response = get_response
      return if response.class != HTTParty::Response  or is_error_status?(response.code)
      @template_cache.add(response) unless not_modified?(response)
      @template_cache.body_content
    end

    def cached_response_for template_name
      @template_cache.content
    end

    private

    def http_caching_headers
      return unless @template_cache.is_cached?
      cached_template = @template_cache.content
      headers = {}
      headers["If-None-Match"] = cached_template[:etag] if cached_template[:etag]
      headers["If-Modified-Since"] = cached_template[:last_modified] if cached_template[:last_modified]
      headers
    end

    def is_error_status? code
      code != 200 and code != 304
    end

    def get_response
        ProxyParty.get(SKIN::CMS_BASE_URL + @template_name, :headers => http_caching_headers, :timeout => SKIN::TIMEOUT)
    end

    def not_modified? response
      response.code == 304
    end

  end
end


