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

    def save 
        if self.id 
            update
        else
            QuestionsDatabase.instance.execute(<<-SQL, *self.instance_vals)
                INSERT INTO 
                    #{self.table_name} (#{self.non_id_cols})
                VALUES
                    #{self.placeholders}
            SQL
            self.id = QuestionsDatabase.instance.last_insert_row_id
        end
    end 

    def column_names
        self.instance_variables.map(&:to_s).map {|el| el.tr("@","") }
    end

    def non_id_cols 
        self.column_names[1..-1].join(", ")
    end

    def instance_vals
        self.instance_variables.map { |var|  self.instance_variable_get(var) }[1..-1]
    end

    def placeholders
        Array.new(instance_vals.length) {"?"}.join(", ")
    end


end 