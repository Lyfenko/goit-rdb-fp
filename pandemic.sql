CREATE SCHEMA pandemic;

USE pandemic;

SELECT * FROM infectious_cases;

CREATE TABLE entities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(255),
    code VARCHAR(10)
);

INSERT INTO entities (entity_name, code) SELECT DISTINCT entity, code FROM infectious_cases;

SELECT * FROM entities LIMIT 10;

CREATE TABLE disease_cases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT,
    year INT,
    disease VARCHAR(255),
    cases FLOAT,
    FOREIGN KEY (entity_id) REFERENCES entities(id)
);

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'yaws', ic.number_yaws
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_yaws IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'polio', ic.polio_cases
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.polio_cases IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'guinea_worm', ic.cases_guinea_worm
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.cases_guinea_worm IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'rabies', ic.number_rabies
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_rabies IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'malaria', ic.number_malaria
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_malaria IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'hiv', ic.number_hiv
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_hiv IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'tuberculosis', ic.number_tuberculosis
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_tuberculosis IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'smallpox', ic.number_smallpox
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_smallpox IS NOT NULL;

INSERT INTO disease_cases (entity_id, year, disease, cases)
SELECT e.id, ic.year, 'cholera', ic.number_cholera_cases
FROM infectious_cases ic JOIN entities e ON ic.entity = e.entity_name
WHERE ic.number_cholera_cases IS NOT NULL;

SELECT * FROM disease_cases LIMIT 10;

SELECT
    e.entity_name,
    e.code,
    AVG(dc.cases) AS avg_rabies,
    MIN(dc.cases) AS min_rabies,
    MAX(dc.cases) AS max_rabies,
    SUM(dc.cases) AS sum_rabies
FROM
    disease_cases dc
        JOIN
    entities e ON dc.entity_id = e.id
WHERE
    dc.disease = 'rabies'
  AND dc.cases IS NOT NULL
GROUP BY
    e.entity_name, e.code
ORDER BY
    avg_rabies DESC
LIMIT 10;

SELECT
    year,
    DATE(CONCAT(year, '-01-01')),
    CURRENT_DATE(),
    TIMESTAMPDIFF(YEAR, DATE(CONCAT(year, '-01-01')), CURRENT_DATE())
FROM
    disease_cases
LIMIT 10;

DELIMITER //

CREATE FUNCTION year_difference(input_year INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE first_january_date DATE;
    DECLARE year_diff INT;

    SET first_january_date = DATE(CONCAT(input_year, '-01-01'));

    SET year_diff = TIMESTAMPDIFF(YEAR, first_january_date, CURRENT_DATE());

    RETURN year_diff;
END //

DELIMITER ;

SELECT
    year AS original_year,
    year_difference(year) AS year_difference
FROM
    disease_cases
LIMIT 10;



















































