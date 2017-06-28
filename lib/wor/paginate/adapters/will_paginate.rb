# Used when render_paginated is called with an ActiveModel directly, with will_paginate
# already required. Something like
### render_paginated DummyModel
module Wor
  module Paginate
    module Adapters
      class WillPaginate
        attr_reader :page

        def initialize(content, page, limit)
          @content = content
          @page = page
          @limit = limit
        end

        def adapt?
          @content.respond_to? :paginate
        end

        def paginated_content
          @paginated_content ||= @content.paginate(page: @page, per_page: @limit)
        end

        def count
          paginated_content.to_a.size
        end

        def total_count
          paginated_content.count
        end
      end
    end
  end
end
