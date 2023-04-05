require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class Users
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM users')
        data.map { |datum| Users.new(datum) }
    end

    def initialize(user_data)
        @id = user_data['id']
        @fname = user_data['fname']
        @lname = user_data['lname']
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname) 
        SELECT
            *
        FROM
            users
        WHERE
            fname = ?
        AND
            lname = ?

        SQL
        return nil unless user.length > 0

        Users.new(user.first)
    end
end