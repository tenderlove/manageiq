if ActiveRecord::Base.connection.respond_to? :truncate
  puts "Rails is new enough to have truncate, please remove this: #{__FILE__}"
else
  module ArTruncate
    def truncate(table_name, name = nil)
      execute("TRUNCATE TABLE #{quote_table_name(table_name)}", name)
    end
  end

  # Patch the already created connection object and any future ones
  ActiveRecord::Base.connection.extend ArTruncate

  class << ActiveRecord::Base.connection.class
    include ArTruncate
  end
end
