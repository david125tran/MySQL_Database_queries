DROP DATABASE IF EXISTS bjj_tourney_clone;
CREATE DATABASE bjj_tourney_clone;
USE bjj_tourney_clone;

-- *************************************** Create Tables ***************************************

CREATE TABLE weight_classes(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	weight_class VARCHAR(50) NOT NULL 
);

CREATE TABLE competitors (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	full_name VARCHAR(100) NOT NULL,
	weight_class INT NOT NULL,
	FOREIGN KEY(weight_class) REFERENCES weight_classes(id) 
);

CREATE TABLE submissions (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	submission VARCHAR(100) NOT NULL
);

CREATE TABLE results (
	winner INT NOT NULL,
	loser INT NOT NULL,
	submission INT NOT NULL,
	FOREIGN KEY(winner) REFERENCES competitors(id),
	FOREIGN KEY(loser) REFERENCES competitors(id), 
	FOREIGN KEY(submission) REFERENCES submissions(id) 
);

-- *************************************** Insert Data ***************************************
INSERT INTO weight_classes(weight_class) VALUES ('125 lbs'), ('150 lbs'), ('175 lbs'), ('200 lbs'), ('230 lbs'), ('285 lbs');
INSERT INTO competitors(full_name, weight_class) VALUES ('Samantha Craig', 1), ('Peter Joe', 2), ('Tim Chestnut', 4), ('Gary Black', 2), ('Tony Clark', 5), ('Ian Humprey', 5), ('Al Munt', 4), ('Tom Donathon', 6), ('Kathy Marble', 1), ('Issac Lee', 6), ('David Tran', 2), ('Tim John', 1), ('Sally Jones', 3), ('Bill Jones', 3), ('David Smith', 3), ('Jon Smith', 1), ('Pete Greg', 1), ('Timmy Lou', 5), ('Mike Grey', 5), ('Joey Tom', 6), ('Sue Jones', 4), ('Danny Tran', 3) ;
INSERT INTO submissions(submission) VALUES ('Triangle Choke'), ('Armbar'), ('Omoplata'), ('Ezekiel'), ('Clock Choke'), ('Guillotine'), ('Rear Naked Choke'), ('Bow and Arrow Choke'), ('Cross Collar Choke'), ('Baseball Bat Choke'), ('Darce Choke'), ('Arm Triangle'), ('North-South Choke'), ('Crucifix Choke'), ('Andaconda Choke'), ('Peruvian Choke'), ('Japanese Necktie'), ('Loop Choke'), ('Paper Cutter Choke'), ('Gogoplata'), ('Americana'), ('Kimura'), ('Bicep Slicer'), ('Calf Slicer'), ('Wristlock'), ('Heel Hook'), ('Knee Bar'), ('Straight Ankle Lock'), ('Other/Misc.');
INSERT INTO results(winner, loser, submission) VALUES 
	-- 125 lbs Bracket
	(1, 9, 28), (1, 12, 16), (1, 16, 17), (1, 17, 29), (9, 17, 2), (9, 12, 4), (9, 16, 5), (12, 17, 22), (12, 16, 16), (16, 17, 11),
	-- 150 lbs Bracket
	(11, 4, 21), (11, 2, 25), (2, 4, 19), 
	-- 175 lbs Bracket
    	(14, 13, 17), (14, 15, 28), (13, 15, 11), (22, 14, 21), (22, 15, 26), (22, 13, 19),
	-- 200 lbs Bracket
	(3, 21, 11), (3, 7, 10), (21, 7, 7),
	-- 230 lbs Bracket
	(6, 5, 3), (6, 18, 2), (6, 19, 11), (19, 18, 1), (19, 5, 4), (5, 18, 26),
	-- 285 lbs Bracket
	(8, 20, 20), (8, 10, 16), (10, 20, 25)
;

-- *************************************** See Tables ***************************************
SELECT * FROM weight_classes;
SELECT * FROM competitors;
SELECT * FROM submissions; 
SELECT * FROM results;

-- *************************************** See Competitors at 125 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '1';

-- *************************************** See Competitors at 150 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '2';

-- *************************************** See Competitors at 175 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '3';

-- *************************************** See Competitors at 200 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '4';

-- *************************************** See Competitors at 230 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '5';

-- *************************************** See Competitors at 285 lbs ***************************************
SELECT * FROM competitors WHERE weight_class LIKE '6';

-- *************************************** See Results at 125 lbs ***************************************

-- Use the 'LEFT JOIN' to also reveal competitors without wins because the right join and inner join won't show them. 
-- Inner join only shows when there is a match 
-- Left join returns all rows from left table (competitors table) 
SELECT competitors.full_name AS winner, results.submission, results.loser AS loser
FROM competitors 
LEFT JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '1'
;

-- *************************************** See Placement at 125 lbs Bracket***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '1'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** See Placement at 150 lbs Bracket***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '2'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** See Placement at 175 lbs Bracket ***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '3'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** See Placement at 200 lbs Bracket***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '4'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** See Placement at 230 lbs Bracket ***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '5'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** See Placement at 285 lbs Bracket***************************************
SELECT competitors.full_name, count(*) AS wins
FROM competitors
INNER JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '6'
GROUP BY full_name
ORDER BY wins DESC
;

-- *************************************** How many times did the average competitor win at 125 lbs? ***************************************

-- Nest select functions inside of a select function to do math
-- 'average amount of wins in weight class' = total wins / total competitors 
SELECT(
	(
	SELECT
	COUNT(*)
	FROM competitors
	INNER JOIN results
	ON results.winner = competitors.id
	WHERE weight_class LIKE '1')
/
	(
	SELECT
	COUNT(*)
	FROM competitors
	WHERE weight_class LIKE '1')
) 

AS 'average amount of wins in weight class';

-- *************************************** Which 3 weight classes has the most # of competitors? ***************************************

SELECT  weight_classes.weight_class, COUNT(*) as Competitors
FROM weight_classes
INNER JOIN competitors
ON weight_classes.id = competitors.weight_class
GROUP BY weight_classes.weight_class
ORDER BY Competitors DESC
LIMIT 3;

-- *************************************** What were the most common submissions at the tournament? ***************************************

-- You can use either the 'INNER JOIN' or 'LEFT JOIN' to only show submissions that were a match for what submissions were used 
-- You cannot use the 'RIGHT JOIN' or else it will show all submissions even if they were not a match (used in tourney) and list it as being used 1x. 
SELECT submissions.submission, COUNT(*) AS count
FROM results
INNER JOIN submissions
ON submissions.id = results.submission
GROUP BY submission
ORDER BY count DESC;

-- *************************************** What submissions were not used at the tournament? ***************************************

-- Use the 'LEFT JOIN' to get all of the submissions.  Look in the column 'submissions' from table 'results' to see where there is not a match
-- You cannot use the 'INNER JOIN' or it will only show where there are matches.  
SELECT submissions.submission AS 'Submissions Not Used at Tourney'
FROM submissions
LEFT JOIN results
ON submissions.id = results.submission
WHERE results.submission IS NULL
;

-- *************************************** See who did not win at 150 lb bracket ***************************************

-- Use the 'LEFT JOIN' to also reveal competitors without wins because the right join and inner join won't show them. 
-- Inner join only shows when there is a match 
-- Left join returns all rows from left table (competitors table) 
-- Use the 'IS NULL' and 'WHERE' search query to find who did not have any wins 

SELECT competitors.full_name AS 'Last Place in Weighted Bracket'
FROM competitors 
LEFT JOIN results
ON results.winner = competitors.id
WHERE weight_class LIKE '2' AND submission IS NULL;

-- *************************************** How many competitors were there per weight class? ***************************************

SELECT weight_classes.weight_class, COUNT(*) as '# of Competitors'
FROM weight_classes
INNER JOIN competitors
ON weight_classes.id = competitors.weight_class
GROUP BY weight_classes.weight_class;
 
-- *************************************** See competitors whose first names start with a 'B' ***************************************
SELECT full_name
FROM competitors
WHERE full_name LIKE 'b%';

-- *************************************** See competitors whose last names is 'Smith' ***************************************
SELECT full_name
FROM competitors
WHERE full_name LIKE '%Smith';

-- *************************************** Change a column name and change it back ***************************************
ALTER TABLE competitors
RENAME COLUMN full_name TO name;

SELECT * FROM competitors;

ALTER TABLE competitors
RENAME COLUMN name TO full_name;

SELECT * FROM competitors;

-- *************************************** Who had the most wins in the tournament out of all competitors?***************************************
SELECT full_name, COUNT(*) as wins
FROM competitors
INNER JOIN results
ON competitors.id = results.winner
GROUP BY full_name
ORDER BY wins DESC;

-- *************************************** Who had the zero wins in the tournament out of all competitors?***************************************

-- Use the 'LEFT JOIN' to show all competitors.  Filter through 'winner' column of 'results' table to find null results to find out who did not win. 
SELECT competitors.full_name AS 'last place competitors'
FROM competitors
LEFT JOIN results
ON competitors.id = results.winner
WHERE results.winner IS NULL
;

-- *************************************** Show databases ***************************************
SHOW DATABASES;
