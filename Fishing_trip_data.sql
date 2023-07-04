DROP DATABASE IF EXISTS fishing_trip;
CREATE DATABASE fishing_trip;
USE fishing_trip;

-- *************************************** Create Tables ***************************************

CREATE TABLE fishing_poles(
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL
);

CREATE TABLE fish (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    fish_name VARCHAR(100) NOT NULL
);

CREATE TABLE bait (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    bait_name VARCHAR(50) NOT NULL
);

CREATE TABLE boats (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    boat_name VARCHAR(50) NOT NULL,
    cost_usd INTEGER NOT NULL
);

CREATE TABLE fishers (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    fishing_pole INTEGER NOT NULL,
    boat_owned INTEGER, 
    FOREIGN KEY (fishing_pole) REFERENCES fishing_poles(id),
    FOREIGN KEY (boat_owned) REFERENCES boats(id)
);

CREATE TABLE catches (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    fish INTEGER NOT NULL,
    size_inches INTEGER NOT NULL,
    weight_lbs INTEGER NOT NULL,
    time_caught TIME,
    bait_type INTEGER NOT NULL,
    fisherman INTEGER NOT NULL,
    FOREIGN KEY (fish) REFERENCES fish (id),
    FOREIGN KEY (bait_type) REFERENCES bait(id),
    FOREIGN KEY (fisherman) REFERENCES fishers(id)
);
-- *************************************** Insert Data ***************************************
INSERT INTO fishing_poles (brand) VALUES ('Abu Garcia'), ('Daiwa'), ('Okuma Fishing'), ('Orvis'), ('Penn'), ('Shimano');
INSERT INTO fish (fish_name) VALUES ('Cobia'), ('Kingfish'), ('Mahi-Mahi'), ('Marlin'), ('Sailfish'), ('Shark'), ('Tarpon'), ('Tuna'), ('Wahoo');
INSERT INTO bait (bait_name) VALUES ('Baitfish'), ('Cut Bait'), ('Shellfish'), ('Shrimp'), ('Worm');
INSERT INTO boats (brand, boat_name, cost_usd) VALUES ('Robalo', 'R302', 239900), ('Robalo', 'R222', 62500), ('Blackfin', '252 CC', 179999), ('Wellcraft', '222 Fisherman', 78999), ('Sea Chaser', '24 HFC', 98000), ('Robalo', 'R242', 99900);
INSERT INTO fishers (full_name, age, fishing_pole, boat_owned) VALUES ('David Tran', 31, 4, 1), ('Amanda White', 25, 3, 2), ('Johnny Barios', 45, 2, 3), ('Lexi Jefferson', 42, 1, 4), ('Kassie Belle', 24, 5, 6), ('Amy Smith', 56, 6, 5);
INSERT INTO catches (fish, size_inches, weight_lbs, time_caught, bait_type, fisherman) VALUES (8, 65, 553, '09:01:00', 1, 1), (8, 60, 540, '09:02:00', 1, 6), (7, 51, 62, '09:08:00', 4, 2), (9, 66, 26, '9:40:00', 2, 3), (2, 14, 33, '11:01:00', 4, 1), (6, 99, 3000, '11:03:00', 3, 1), (1, 33, 82, '11:58:00', 3, 5), (1, 27, 80, '12:15:00', 2, 5), (2, 18, 3, '12:16:00', 1, 6);
INSERT INTO catches (fish, size_inches, weight_lbs, time_caught, bait_type, fisherman) VALUES (1, 33, 75, '12:17:00', 3, 2), (2, 15, 35, '12:23:00', 4, 2), (3, 51, 53, '12:45:00', 1, 1), (9, 71, 30, '13:01:00', 2, 3), (4, 80, 240, '14:01:00', 3, 6), (5, 110, 211, '14:25:00', 4, 2), (2, 18, 3, '14:51:00', 4, 1), (3, 52, 55, '14:59:00', 2, 5), (8, 55, 498, '15:16:00', 1, 6);

-- *************************************** See Tables ***************************************
SELECT * FROM fishing_poles;
SELECT * FROM fish;
SELECT * FROM bait;
SELECT * FROM boats;
SELECT * FROM fishers;
SELECT * FROM catches;

-- *************************************** Show a List of Who Had The Most Catches In Descending Order ***************************************
SELECT fishers.full_name, COUNT(catches.fisherman) AS 'number of catches' FROM catches
JOIN fishers
ON catches.fisherman = fishers.id
GROUP BY catches.fisherman
ORDER BY COUNT(catches.fisherman) DESC;

-- *************************************** Who Had Zero Catches? ***************************************
SELECT fishers.full_name, catches.fisherman AS 'number of catches' FROM catches
RIGHT JOIN fishers
ON catches.fisherman = fishers.id
WHERE catches.fisherman IS NULL;
-- Use the right join to have all the names listen even if has a null value

-- *************************************** What Was The Heaviest Catch? ***************************************
SELECT fish.fish_name, weight_lbs
FROM catches
JOIN fish
ON catches.fish = fish.id
WHERE weight_lbs = 
	(SELECT max(weight_lbs)
	FROM catches)
;

-- *************************************** What Was The Length of The Heaviest Catch? ***************************************
SELECT fish.fish_name, size_inches
FROM catches
JOIN fish
ON catches.fish = fish.id
WHERE weight_lbs = 
	(SELECT max(weight_lbs)
	FROM catches)
;

-- *************************************** What Was The Length of The Longest Catch? ***************************************
SELECT fish.fish_name, size_inches
FROM catches
JOIN fish
ON catches.fish = fish.id
WHERE size_inches = 
	(SELECT max(size_inches)
	FROM catches)
;

-- *************************************** What Bait Was Used to Catch The Longest Length Catch? ***************************************
SELECT bait.bait_name, size_inches
FROM catches
JOIN bait
ON catches.bait_type = bait.id
WHERE size_inches = 
	(SELECT max(size_inches)
	FROM catches)
;

-- *************************************** What Boat Was Used to Catch The Heaviest Catch? ***************************************
SELECT brand, boat_name
FROM boats
WHERE id =  
	(SELECT fishers.boat_owned
	FROM fishers
	JOIN catches
	ON fishers.id = catches.fisherman
	WHERE weight_lbs = 
		(SELECT max(weight_lbs)
		FROM catches)
	)
;

-- *************************************** What Bait Did Not Catch Any Fish? ***************************************
SELECT bait.bait_name, catches.bait_type AS 'bait used?'
FROM bait
LEFT JOIN catches
ON bait.id = catches.bait_type 
WHERE bait_type IS NULL;
-- Use left join to have all baits listed because we are looking for one with a null value

-- *************************************** What Fish Was Caught The Most? ***************************************
SELECT fish.fish_name, COUNT(catches.fish) AS times_caught
FROM fish
JOIN catches
ON fish.id = catches.fish
GROUP BY catches.fish
ORDER BY times_caught DESC
LIMIT 1;

-- *************************************** Which People Caught The Fish That Was The Most Caught? ***************************************
SELECT fishers.full_name
FROM fishers
JOIN catches
ON fishers.id = catches.fisherman
WHERE catches.fish = (
	SELECT catches.fish
	FROM fish
	JOIN catches
	ON fish.id = catches.fish
	GROUP BY catches.fish
	ORDER BY COUNT(catches.fish) DESC
	LIMIT 1
    )
GROUP BY full_name;

-- *************************************** What Fishing Poles Used to Catch The Most Caught Fish? ***************************************
SELECT fishing_poles.brand
FROM fishing_poles
JOIN (
	SELECT fishers.fishing_pole
	FROM fishers
	JOIN catches 
	ON fishers.id = catches.fisherman
	WHERE fish = (
		SELECT fish
		FROM catches
		GROUP BY fish
		ORDER BY COUNT(fish) DESC
		LIMIT 1)
	GROUP BY fishing_pole) AS poles_used
ON fishing_poles.id = poles_used.fishing_pole;

-- 1st find which fish was caught the most
-- Then find out which fishers caught that fish
-- Then find out what fishing pole ids those fishers used
-- Then find out which brands of fishing poles those fishing pole ids were

-- *************************************** Show databases ***************************************
-- SHOW DATABASES;