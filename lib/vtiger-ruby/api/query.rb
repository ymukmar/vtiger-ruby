module VtigerRuby
  module Api
    class Query
      def initialize(client, sql_query: nil)
        @sql_query = sql_query
        @client = client
      end

      def fetch_all
        result = []
        latest_fetch = fetch

        until latest_fetch.empty?
          result.concat(latest_fetch)
          latest_fetch = fetch
        end
        result
      end

      def fetch(sql_query = nil)
        params = {
          'operation': 'query',
          'sessionName': @client.session_id,
          'query': sql_query || sql_for_records_after(last_record_id)
        }

        @query_response = Faraday.get(@client.endpoint, params) do |req|
          req.headers['User-Agent'] = 'VtigerRuby'
        end

        JSON.parse(@query_response.body).dig('result')
      end

      private
      def sql_for_records_after(record_id)
        <<-SQL
        #{@sql_query.gsub(':record_filter_clause', "id > #{record_id};")}
        SQL
      end

      def last_record_id
        response = @query_response.dup

        unless response.nil? || (response = JSON.parse(response.body).dig('result')).empty?
          response.last.dig('id')
        else
          # returns first N records where N <= 200 records
          'x0'
        end
      end
    end
  end
end
