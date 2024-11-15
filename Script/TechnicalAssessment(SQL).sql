
CREATE TABLE tblAuthor (
  AuthorId INT PRIMARY KEY,
  AuthorName VARCHAR(100) NOT NULL
);
CREATE TABLE tblDoctor (
  DoctorId INT PRIMARY KEY,
  DoctorNumber INT NOT NULL,
  DoctorName VARCHAR(100) NOT NULL,
  BirthDate DATE NOT NULL,
  FirstEpisodeDate DATE NOT NULL,
  LastEpisodeDate DATE NOT NULL
);
CREATE TABLE tblEpisode (
  EpisodeId INT PRIMARY KEY,
  EpisodeNumber INT NOT NULL,
  EpisodeType VARCHAR(50) NOT NULL,
  Title VARCHAR(200) NOT NULL,
  EpisodeDate DATE NOT NULL,
  AuthorId INT NOT NULL,
  DoctorId INT NOT NULL,
  FOREIGN KEY (AuthorId) REFERENCES tblAuthor(AuthorId),
  FOREIGN KEY (DoctorId) REFERENCES tblDoctor(DoctorId)
);
CREATE TABLE tblEnemyEnemy (
  EnemyId INT PRIMARY KEY,
  EnemyName VARCHAR(100) NOT NULL
);
CREATE TABLE tblEpisodeEnemy (
  EpisodeId INT NOT NULL,
  EnemyId INT NOT NULL,
  FOREIGN KEY (EpisodeId) REFERENCES tblEpisode(EpisodeId),
  FOREIGN KEY (EnemyId) REFERENCES tblEnemyEnemy(EnemyId)
);
CREATE TABLE tblEpisodeCompanion (
  EpisodeCompanionId INT PRIMARY KEY,
  EpisodeId INT NOT NULL,
  CompanionId INT NOT NULL,
  FOREIGN KEY (EpisodeId) REFERENCES tblEpisode(EpisodeId)
);
CREATE TABLE tblCompanion (
  CompanionId INT PRIMARY KEY,
  CompanionName VARCHAR(100) NOT NULL,
  WhoPlayed VARCHAR(100) NOT NULL
);
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
-- tblAuthor
INSERT INTO tblAuthor (AuthorId, AuthorName) VALUES
  (1, 'Douglas Adams'),
  (2, 'Neil Gaiman'),
  (3, 'Steven Moffat');

-- tblDoctor
INSERT INTO tblDoctor (DoctorId, DoctorNumber, DoctorName, BirthDate, FirstEpisodeDate, LastEpisodeDate) VALUES
  (9, 9, 'Christopher Eccleston', '1964-02-16', '2005-03-26', '2005-06-18'),
  (10, 10, 'David Tennant', '1971-04-18', '2005-12-25', '2010-01-01'),
  (11, 11, 'Matt Smith', '1982-10-28', '2010-04-03', '2013-12-25');

-- tblEpisode
INSERT INTO tblEpisode (EpisodeId, EpisodeNumber, EpisodeType, Title, EpisodeDate, AuthorId, DoctorId) VALUES
  (1, 1, 'Season Premiere', 'The Empty Child', '2005-06-18', 3, 9),
  (2, 2, 'Regular', 'The Doctor Dances', '2005-06-25', 3, 9),
  (3, 1, 'Season Premiere', 'New Earth', '2006-04-15', 2, 10),
  (4, 2, 'Regular', 'Tooth and Claw', '2006-04-22', 3, 10),
  (5, 1, 'Season Premiere', 'Smith and Jones', '2007-03-31', 3, 10),
  (6, 2, 'Regular', 'The Shakespeare Code', '2007-04-07', 3, 10);


-- tblEnemyEnemy
INSERT INTO tblEnemyEnemy (EnemyId, EnemyName) VALUES
  (1, 'Daleks'),
  (2, 'Cybermen'),
  (3, 'Weeping Angels');

-- tblEpisodeEnemy
INSERT INTO tblEpisodeEnemy (EpisodeId, EnemyId) VALUES
  (1, 1),
  (1, 2),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 1),
  (6, 3);

-- tblEpisodeCompanion
INSERT INTO tblEpisodeCompanion (EpisodeCompanionId, EpisodeId, CompanionId) VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 2),
  (4, 4, 2),
  (5, 5, 3),
  (6, 6, 3);

-- tblCompanion
INSERT INTO tblCompanion (CompanionId, CompanionName, WhoPlayed) VALUES
  (1, 'Rose Tyler', 'Billie Piper'),
  (2, 'Martha Jones', 'Freema Agyeman'),
  (3, 'Amy Pond', 'Karen Gillan');


INSERT INTO employees VALUES
(1, 'Alvin', 'Smith', NULL),
(2, 'Jose', 'Jones', 1),
(3, 'Amado', 'Taylor', 1),
(4, 'Stuart', 'Williams', 1),
(5, 'Demarcus', 'Brown', 2),
(6, 'Mark', 'Davies', 2),
(7, 'Merlin', 'Evans', 2),
(8, 'Elroy', 'Wilson', 7),
(9, 'Charles', 'Thomas', 7),
(10, 'Rudolph', 'Roberts', 7);


--Question 1: Using the following ERD which contains authors and episodes write a query to show for each author:
-- The number of episodes they wrote.
-- Their earliest episode date.
-- Their latest episode date.

SELECT
  tblAuthor.AuthorName,
  COUNT(tblEpisode.EpisodeId) AS NumEpisodes,
  MIN(tblEpisode.EpisodeDate) AS EarliestEpisodeDate,
  MAX(tblEpisode.EpisodeDate) AS LatestEpisodeDate
FROM tblAuthor
LEFT JOIN tblEpisode ON tblAuthor.AuthorId = tblEpisode.AuthorId
GROUP BY tblAuthor.AuthorName;



-- Question 2: Using the following ERD which contains authors, doctors and episodes write a query to
-- list out for each author and doctor the number of episodes made, but restrict your output to
-- show only the author/doctor combinations for which more than 5 episodes have been written

SELECT
  tblAuthor.AuthorName,
  tblDoctor.DoctorName,
  COUNT(tblEpisode.EpisodeId) AS NumEpisodes
FROM tblAuthor
JOIN tblEpisode ON tblAuthor.AuthorId = tblEpisode.AuthorId
JOIN tblDoctor ON tblEpisode.DoctorId = tblDoctor.DoctorId
GROUP BY tblAuthor.AuthorName, tblDoctor.DoctorName
HAVING COUNT(tblEpisode.EpisodeId) > 5;


-- Question 3: Using the following ERD write a query to list out for each episode year and enemy the number of episodes made, but in addition:
-- a.	Only show episodes made by doctors born before 1970; and
-- b.	Omit rows where an enemy appeared in only one episode in a particular year.

SELECT
  DATE_PART('year', tblEpisode.EpisodeDate) AS EpisodeYear,
  tblEnemyEnemy.EnemyName,
  COUNT(tblEpisodeEnemy.EpisodeId) AS NumEpisodes
FROM tblEpisode
JOIN tblEpisodeEnemy ON tblEpisode.EpisodeId = tblEpisodeEnemy.EpisodeId
JOIN tblEnemyEnemy ON tblEpisodeEnemy.EnemyId = tblEnemyEnemy.EnemyId
JOIN tblDoctor ON tblEpisode.DoctorId = tblDoctor.DoctorId
WHERE tblDoctor.BirthDate < '1970-01-01'
GROUP BY EpisodeYear, tblEnemyEnemy.EnemyName
HAVING COUNT(tblEpisodeEnemy.EpisodeId) > 1;


-- Question 4: Create a query to display the hierarchical relationship between a certain employee
-- and his direct and indirect managers.

WITH RECURSIVE emp_hierarchy AS (
    SELECT
        e.employee_id,
        e.First_Name,
        e.Last_Name,
        e.manager_id,
        1 as level,
        CAST(e.First_Name AS VARCHAR(1000)) as hierarchy_path
    FROM employees e
    WHERE e.employee_id = 7 --base employee

    UNION ALL

    SELECT
        e.employee_id,
        e.First_Name,
        e.Last_Name,
        e.manager_id,
        h.level + 1,
        CAST(e.First_Name || ' -> ' || h.hierarchy_path AS VARCHAR(1000))
    FROM employees e
    INNER JOIN emp_hierarchy h ON e.employee_id = h.manager_id
)

SELECT
    level,
    employee_id,
    First_Name,
    Last_Name,
    manager_id,
    hierarchy_path
FROM emp_hierarchy
ORDER BY level;