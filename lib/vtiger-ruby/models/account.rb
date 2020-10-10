module VtigerRuby
  class Account < VtigerModel
    VTIGER_MODULE = 'Accounts'.freeze

    def self.all
      all_from_vtiger(self, 'select * from Accounts where :record_filter_clause')
    end

    def self.fetch(sql_query = nil)
      fetch_from_vtiger(self, sql_query)
    end
  end
end
