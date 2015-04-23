module Wdi6RailsApiMovies
  # bunch'o methods to clean DB, reset pk sequence, ...
  class CleanDB
    attr_accessor :tables

    def initialize
      # Get all the tables, except the table for migrations
      @tables = ActiveRecord::Base.connection.tables - ['schema_migrations']
    end

    def process
      remove_foreign_keys
      delete_tables
    end

    def delete_tables
      tables.each do |table|
        Rails.logger.info "Deleting #{table}"
        # delete all data from the table
        ActiveRecord::Base.connection.execute "DELETE FROM #{table}"

        Rails.logger.info "Resetting primary key sequence for #{table}"
        # reset the primary key sequence for this table, start id column at 1
        ActiveRecord::Base.connection.reset_pk_sequence!("#{table}")
      end
    end

    private

    def remove_foreign_key(table, fk)
      fk_name = fk.options[:name].to_sym if fk

      table.present? && fk_name.present? &&
        ActiveRecord::Migration.remove_foreign_key("#{table}".to_sym,
                                                   name: fk_name)
    rescue ArgumentError => ae
      Rails.logger.info "#{table} #{ae}"
    end

    def remove_foreign_keys
      tables.each do |table|
        ActiveRecord::Migration.foreign_keys("#{table}").each  do |fk|
          remove_foreign_key(table, fk)
        end
      end
    end
  end
end
