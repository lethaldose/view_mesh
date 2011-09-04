module ViewMesh
  class ContentResolver

    def initialize template_name
      @template_name = template_name
      load_html
    end

    def head
      selector_content("head")
    end

    def body
      selector_content("body")
    end

    def div(id)
      selector_content("##{id}")
    end

    def div_class(class_name)
      selector_content("div.#{class_name}")
    end

    private

    def load_html
      content = TemplateLoader.new(@template_name).get_content
      @doc = Nokogiri::HTML(content) if content.present?
    end

    def selector_content query
      @doc.css(query).inner_html.html_safe if (@doc and @doc.content.present?)
    end
  end
end

