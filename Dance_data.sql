DROP DATABASE IF EXISTS queries1;
CREATE DATABASE queries1;
USE queries1;

-- ********************* Create tables *********************
CREATE TABLE dancers (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL, 
    years_experience INT(5) NOT NULL
);

CREATE TABLE competition_pool (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    dance_pool VARCHAR(10) NOT NULL,
    FOREIGN KEY(id) REFERENCES dancers(id)
);

CREATE TABLE podium (
	id INT NOT NULL,
    placement VARCHAR(5) NOT NULL,
    FOREIGN KEY (id) REFERENCES dancers(id)
);

CREATE TABLE activity (
	id INT NOT NULL,
    event_date DATE NOT NULL
);

CREATE TABLE sponsorship (
	id INT NOT NULL,
    sponsor_name VARCHAR(50) NOT NULL,
    pay INT,
    FOREIGN KEY (id) REFERENCES dancers(id)
);

CREATE TABLE sales (
	seller_id INT NOT NULL,
    tickets_sold INT NOT NULL,
    sales_date DATE NOT NULL,
    price INT NOT NULL,
	FOREIGN KEY (seller_id) REFERENCES dancers(id) 
);


INSERT INTO dancers (name, years_experience) VALUES ('Megan', 5), ('Jillian', 4), ('Candice', 7), ('Liz', 5), ('Miley', 2), ('Laura', 1), ('Becky', 14), ('Elizabeth', 12), ('Cassie', 12), ('Lauren', 4);
INSERT INTO competition_pool (dance_pool) VALUES ('A'), ('B'), ('B'), ('A'), ('C'), ('A'), ('B'), ('B'), ('C'), ('A');
INSERT INTO podium (id, placement) VALUES (1, '1st'), (3, '2nd'), (5, '2nd'), (6, '3rd'), (7, '3rd'), (8, '1st'), (9, '1st'), (10, '2nd'); 
INSERT INTO activity (id, event_date) VALUES (1, '2019-03-11'), (1, '2020-03-01'), (1, '2022-11-01'), (1, '2023-06-04'), (2, '2018-05-11'), (2, '2019-03-21'), (2, '2021-11-22'), (2, '2023-06-04'), (3, '2019-08-17'), (3, '2021-04-17'), (3, '2023-06-04'), (4, '2019-03-11'), (4, '2020-03-01'), (4, '2022-11-01'), (4, '2023-06-04'), (5, '2021-05-10'), (5, '2022-03-17'), (5, '2022-09-01'), (5, '2023-06-04'), (6, '2018-11-01'), (6, '2023-06-04'), (7, '2021-11-15'), (7, '2022-09-01'), (7, '2023-06-04'), (8, '2023-01-01'), (8, '2022-10-01'), (8, '2023-06-04'), (9, '2023-01-11'), (9, '2023-06-04'), (10, '2022-11-01'), (10, '2021-05-01'), (10, '2020-09-11'), (10, '2023-06-04') ; 
INSERT INTO sponsorship (id, sponsor_name, pay) VALUES (1, 'Apolla', 1400), (1, 'Mirella', 1100), (2, 'Apolla', 400), (3, 'Mirella', 700), (3, 'Bloch', 1000), (4, 'Capezio', 750), (7, 'FlexTek', 500), (8, 'Balera', 100), (9, 'IvySky', 500);
INSERT INTO sales (seller_id, tickets_sold, sales_date, price) VALUES (1, 10, '2023-04-01', 10), (1, 12, '2023-04-01', 15), (2, 18, '2023-04-02', 10), (2, 10, '2023-04-03', 10), (4, 9, '2023-04-05', 18), (5, 5, '2023-04-06', 20), (7, 10, '2023-04-11', 15), (8, 10, '2023-04-01', 10), (8, 5, '2023-04-17', 10), (8, 3, '2023-04-21', 10),  (10, 3, '2023-04-14', 20);   

-- ********************* Report the average experience years of all dancers for each competition pool to 2 decimals *********************
SELECT dance_pool, ROUND(AVG(dancers.years_experience), 2) AS 'average_years'
FROM dancers
LEFT JOIN competition_pool
ON dancers.id = competition_pool.id
GROUP BY dance_pool;

-- ********************* Which pool has the most dancers? *********************
SELECT dance_pool
FROM competition_pool
GROUP BY dance_pool
HAVING COUNT(dance_pool) = (
	SELECT COUNT(dance_pool) AS 'competitors'
    FROM competition_pool
    GROUP BY dance_pool
    ORDER BY competitors DESC
    LIMIT 1
);
-- In this case, there is a tie between Pools A and B, with each having 4 dancers

-- ********************* Which dancers did not place top 3 and get on the podium? *********************
SELECT name 
FROM dancers
LEFT JOIN podium
ON dancers.id = podium.id
WHERE placement IS NULL;

-- ********************* Write the 1st date that each competitor competed in *********************
SELECT name, min(event_date) AS first_competition
FROM dancers
INNER JOIN activity
ON dancers.id = activity.id
GROUP BY dancers.id;

-- ********************* Which three dancers had the earliest competition date? *********************
SELECT name, min(event_date) AS first_competition
FROM dancers
INNER JOIN activity
ON dancers.id = activity.id
GROUP BY dancers.id
ORDER BY first_competition
LIMIT 3;

-- ********************* Which dancers had a sponsorship amount of less than $500 or no sponsorship $ at all? *********************
SELECT name, pay
FROM dancers
LEFT JOIN sponsorship
ON dancers.id = sponsorship.id
WHERE pay IS NULL or pay < 500;
-- Use left join to have all names listed even if it has a null value

-- ********************* Which 3 dancers had the most sponsoship $? *********************
SELECT name, pay
FROM dancers
INNER JOIN sponsorship
ON dancers.id = sponsorship.id
ORDER BY pay DESC
LIMIT 3;

-- ********************* Which sponsors are paying the most in total to all of the dancers? *********************
SELECT sponsor_name, SUM(pay) AS total_payout
FROM sponsorship 
GROUP BY sponsor_name
ORDER BY total_payout DESC
LIMIT 3;

-- ********************* Which dancers had multiple sponsors? *********************
SELECT name, count(name) AS total_sponsors
FROM dancers
INNER JOIN sponsorship
ON dancers.id = sponsorship.id
GROUP BY name
HAVING total_sponsors > 1;
-- Use inner join to only show matches
-- For aggregated row data, we have to use the 'HAVING' clause.  For non aggregated data, we use the 'WHERE' clause.

-- ********************* Which dancers had the best sales?  If there is a tie, report them all *********************
SELECT name, SUM(tickets_sold * price) AS total
FROM dancers 
INNER JOIN sales
ON dancers.id = sales.seller_id
GROUP BY seller_id
HAVING SUM(tickets_sold * price) = (
	SELECT SUM(tickets_sold * price) AS total
	FROM sales
	GROUP BY seller_id
	ORDER BY total DESC
	LIMIT 1
    );

-- ********************* Which dancers had no sales? *********************
SELECT name, tickets_sold
FROM dancers
LEFT JOIN sales
ON dancers.id = sales.seller_id
WHERE tickets_sold IS NULL;

