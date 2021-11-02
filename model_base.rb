require 'active_support/inflector' 

class ModelBase

    def self.table_name
        self.name.tableize
    end
    
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM #{self.table_name}")
        data.map { |datum| self.new(datum) }
    end

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM #{self.table_name}
            WHERE id = ?
        SQL
        self.new(data[0])
    end

end 