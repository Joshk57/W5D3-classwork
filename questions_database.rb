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
    attr_accessor :id, :fname, :lname
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

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id) 
        SELECT
            *
        FROM
            users
        WHERE
            id = ?

        SQL
        return nil unless user.length > 0

        Users.new(user.first)
    end

    def authored_questions
        Questions.find_by_author_id(self.id)
    end

    def authored_replies
        Replies.find_by_replier_id(self.id)
    end

end


class Questions
    attr_accessor :id, :body, :title, :author_id
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions')
        data.map { |datum| Questions.new(datum) }
    end
    
    def initialize(questions_data)
        @id = questions_data['id']
        @title = questions_data['title']
        @body = questions_data['body']
        @author_id = questions_data['author_id']
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id) 
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?

        SQL
        return nil unless question.length > 0

        Questions.new(question.first)
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id) 
        SELECT
            *
        FROM
            questions
        WHERE
            author_id = ?

        SQL
        return nil unless question.length > 0

        question.map { |data|  Questions.new(data) }    
    end

    def author
        author_data = QuestionsDatabase.instance.execute(<<-SQL, self.author_id) 
        SELECT
            *
        FROM
            users
        WHERE
            id = ?

        SQL
        return nil unless author_data.length > 0

        Users.new(author_data.first)
    end

    def replies
        Replies.find_by_question_id(self.id)
    end

end

class QuestionsFollows
    attr_accessor :id, :author_id, :question_id
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM questions_follows')
        data.map { |datum| QuestionsFollows.new(datum) }
    end

    def self.find_by_id(id)
        question_follows = QuestionsDatabase.instance.execute(<<-SQL, id) 
        SELECT
            *
        FROM
            questions_follows
        WHERE
            id = ?

        SQL
        return nil unless question_follows.length > 0

        QuestionsFollows.new(question_follows.first)
    end

    def initialize(questions_follows_data)
        @id = questions_follows_data['id']
        @author_id = questions_follows_data['author_id']
        @question_id = questions_follows_data['question_id']
    end

    def self.followers_for_question_id(question_id)
        followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            id, fname, lname
        FROM
            users
        JOIN
            questions_follows ON users.id = questions_follows.author_id
        WHERE
            question_id = users.id
        SQL

        followers.map { |data| Users.new(data) }
    end

end


class Replies
    attr_accessor :id, :body, :question_id, :replier_id, :reply_id
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM replies')
        data.map { |datum| Replies.new(datum) }
    end

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id) 
        SELECT
            *
        FROM
            replies
        WHERE
            id = ?

        SQL
        return nil unless reply.length > 0

        Replies.new(reply.first)
    end

    def self.find_by_replier_id(replier_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, replier_id) 
        SELECT
            *
        FROM
            replies
        WHERE
            replier_id = ?

        SQL
        return nil unless reply.length > 0

        reply.map { |data| Replies.new(data) }
    end

    def self.find_by_question_id(question_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, question_id) 
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?

        SQL
        return nil unless reply.length > 0

        reply.map { |data| Replies.new(data) }
    end

    def initialize(replies_data)
        @id = replies_data['id']
        @body = replies_data['body']
        @question_id = replies_data['question_id']
        @replier_id = replies_data['replier_id']
        @reply_id = replies_data['reply_id']
    end
    def author
        author_data = QuestionsDatabase.instance.execute(<<-SQL, self.replier_id) 
        SELECT
            *
        FROM
            users
        WHERE
            id = ?

        SQL
        return nil unless author_data.length > 0

        Users.new(author_data.first)
    end
    def question
        question_data = QuestionsDatabase.instance.execute(<<-SQL, self.question_id) 
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?

        SQL
        return nil unless question_data.length > 0

        Questions.new(question_data.first)
    end

    def parent_reply
        reply_data = QuestionsDatabase.instance.execute(<<-SQL, self.question_id) 
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?

        SQL
        return nil unless reply_data.length > 0

        raw_data = reply_data.map {|data| Replies.new(data) }
        raw_data.each do |reply|
            return reply if reply.reply_id == nil
        end

    end

    def child_replies
        reply_data = QuestionsDatabase.instance.execute(<<-SQL, self.question_id) 
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?

        SQL
        return nil unless reply_data.length > 0

        raw_data = reply_data.map {|data| Replies.new(data) }
        raw_data.select do |reply|
            reply.reply_id != nil
        end

    end
end


class QuestionLikes
    attr_accessor :id, :user_who_liked, :question_id
    def self.all
        data = QuestionsDatabase.instance.execute('SELECT * FROM question_likes')
        data.map { |datum| QuestionLikes.new(datum) }
    end

    def self.find_by_id(id)
        likes = QuestionsDatabase.instance.execute(<<-SQL, id) 
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ?

        SQL
        return nil unless likes.length > 0

       QuestionLikes.new(likes.first)
    end

    def initialize(likes_data)
        @id = likes_data['id']
        @user_who_liked = likes_data['user_who_liked']
        @question_id = likes_data['question_id']

    end

end