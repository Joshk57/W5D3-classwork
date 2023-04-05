PRAGMA foreign_keys = ON;

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
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL, 

    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    replier_id INTEGER NOT NULL,
    reply_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (replier_id) REFERENCES users(id),
    FOREIGN KEY (reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_who_liked INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_who_liked) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES quesions(id)
);


INSERT INTO
    users (fname, lname)
VALUES
    ('Anton', 'James'),
    ('Joshua', 'Kim'),
    ('Kyle', 'Ginzburg'),
    ('Ayce','Lacap');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('Hello', 'How are you?', (SELECT id FROM users WHERE fname = 'Anton' AND lname = 'James')),
    ('Hi', 'What''s for lunch?', (SELECT id FROM users WHERE fname = 'Joshua' AND lname = 'Kim')),
    ('Not much', 'Weather is fine', (SELECT id FROM users WHERE fname = 'Anton' AND lname = 'James'));

INSERT INTO
    questions_follows (author_id, question_id)
VALUES
    ((SELECT id FROM users WHERE id = 1), (SELECT id FROM questions WHERE id = 1)),
    ((SELECT id FROM users WHERE id = 2), (SELECT id FROM questions WHERE id = 2)),
    ((SELECT id FROM users WHERE id = 1), (SELECT id FROM questions WHERE id = 3));




