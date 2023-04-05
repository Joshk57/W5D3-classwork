CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);

CREATE TABLE questions (    -- ask about tables connections
    id INTEGER PRIMARY KEY, 
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE questions_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL, 

    FOREIGN KEY (user_id) REFERENCES questions(author_id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    question_id INTEGER NOT NULL,
    reply TEXT NOT NULL,
    FOREIGN KEY (question_id) REFERENCES questions(id)
);