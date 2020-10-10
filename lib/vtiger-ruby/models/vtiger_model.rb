module VtigerRuby
  class VtigerModel
    def self.class_config(client)
      @@client = client
    end

    def self.all_from_vtiger(klass, sql_query)
      VtigerRuby::Api::Query
        .new(@@client, sql_query: sql_query)
          .fetch_all
            .reduce([]) do |memo, data|
              memo << klass.new(@@client, data)
            end
    end

    def self.fetch_from_vtiger(klass, sql_query)
      VtigerRuby::Api::Query
        .new(@@client)
          .fetch(sql_query)
            .reduce([]) do |memo, data|
              memo << klass.new(@@client, data)
            end
    end

    def initialize(client, attribs = {})
      @client = client
      self.attributes = attribs unless attribs.empty?
    end

    attr_accessor :fetch_response

    def attributes=(hash)
      @fetch_response = hash
    end
  end
end
