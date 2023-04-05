PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

);

CREATE TABLE questions ( 
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
    FOREIGN KEY (question_id) REFERENCES questions(id)
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
    ('Hello', 'How are you?', 1),
    ('Hi', 'What''s for lunch?', 2),
    ('Not much', 'Weather is fine', 1);

INSERT INTO
    questions_follows (author_id, question_id)
VALUES
    (1, 1),
    (2, 2),
    (1, 3);

INSERT INTO
    replies (body, question_id, replier_id, reply_id) 
VALUES
    ('I''m doing good', 1, 4, NULL),
    ('How about you?', 1, 1, 1),
    ('Chicken and rice', 2, 2, NULL),
    ('Super warm', 3, 2, NULL);

INSERT INTO
    question_likes (user_who_liked, question_id)
VALUES
    (1, 2),
    (3, 1),
    (4, 2);




