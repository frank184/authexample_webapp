module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module StatusCodeHelpers
    def status_code
      response.status
    end
  end

  module HeadersHelpers
    def default_headers(options = nil)
      defaults = { 'HTTP_HOST': 'api.lvh.me:3000' }
      defaults.merge!(options) if options
      return defaults
    end
  end
end
