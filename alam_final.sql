create database alam;
use alam;
CREATE TABLE `user` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    name VARCHAR(101) AS (CONCAT(first_name, ' ', last_name)) STORED,
    HomeTown VARCHAR(50) NOT NULL,
    Password VARCHAR(80) NOT NULL
);


CREATE TABLE `Phone_number` (
    user_id INT NOT NULL,
    Phone_number VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `Specelized_field` (
    user_id INT NOT NULL,
    Specelized_field VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `BD_university` (
    university_info_id INT AUTO_INCREMENT PRIMARY KEY,
    university_name VARCHAR(50) NOT NULL,
    cgpa DECIMAL(4,2),
    Department VARCHAR(30),
    Admitted_year VARCHAR(4),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE,
    UNIQUE (user_id)
);


CREATE TABLE `foren` (
    university_info_id INT AUTO_INCREMENT PRIMARY KEY,
    university_name VARCHAR(50) NOT NULL,
    degree_type VARCHAR(30),
    country VARCHAR(30),
    Admitted_year VARCHAR(4),
    Passed_year VARCHAR(4),
    status ENUM('active', 'inactive') DEFAULT 'active',
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `LivingPlace` (
    user_id INT,
    address VARCHAR(100),
    start_time INTEGER,
    end_time INTEGER,
    Time VARCHAR(40) AS (CONCAT(start_time, '-', end_time)) STORED,
    PRIMARY KEY (user_id, address),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `Medical_info` (
    preferred_doctor VARCHAR(100) NOT NULL,
    preferred_medical VARCHAR(100) NOT NULL,
    UNIQUE (preferred_doctor, preferred_medical)
);


CREATE TABLE `User_Medical_Info` (
    user_id INT,
    preferred_doctor VARCHAR(100) NOT NULL,
    preferred_medical VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id, preferred_doctor, preferred_medical),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE,
    FOREIGN KEY (preferred_doctor, preferred_medical) REFERENCES `Medical_info`(preferred_doctor, preferred_medical) ON DELETE CASCADE
);
create table `Group` (
    group_id  INT primary key not null ,
    group_name varchar(100) not null
);

CREATE TABLE `Group_Admin` (
    group_id INT,
    user_id INT,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES `Group`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `Group_Member` (
    group_id INT,
    user_id INT,
    PRIMARY KEY (group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES `Group`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);
CREATE TABLE `Event` (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_time DATETIME NOT NULL,
    event_place VARCHAR(100) NOT NULL
);

CREATE TABLE `Event_User` (
    event_id INT,
    user_id INT,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES `Event`(event_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id) ON DELETE CASCADE
);


CREATE TABLE `Event_Group` (
    event_id INT,
    group_id INT,
    PRIMARY KEY (event_id, group_id),
    FOREIGN KEY (event_id) REFERENCES `Event`(event_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `Group`(group_id) ON DELETE CASCADE
);




DELIMITER //

CREATE TRIGGER ValidatePhoneNumberFormat
BEFORE INSERT ON Phone_number
FOR EACH ROW
BEGIN
    DECLARE phonePattern VARCHAR(20);
    SET phonePattern = '^[0-9]{10}$';

    IF NEW.Phone_number REGEXP phonePattern <> 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid phone number format. Please provide a 10-digit phone number.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetUserFullName(IN userId INT)
BEGIN
    DECLARE fullName VARCHAR(101);


    SELECT name INTO fullName
    FROM `user`
    WHERE user_id = userId;


    SELECT fullName;
END //

DELIMITER ;
CREATE PROCEDURE Getlivingplace(IN userId INT)
BEGIN
    DECLARE addr VARCHAR(100);


    SELECT address INTO addr
    FROM `livingplace`
    WHERE user_id = userId;


    SELECT addr;
END;



CREATE FUNCTION GetPhoneNumber(userId INT) RETURNS VARCHAR(255)
BEGIN
    DECLARE userPhoneNumbers VARCHAR(255);


    SELECT GROUP_CONCAT(Phone_number SEPARATOR ', ') INTO userPhoneNumbers
    FROM phone_number
    WHERE user_id = userId;

    RETURN userPhoneNumbers;
END;

DELIMITER ;
CREATE USER 'amjonota'@'%' IDENTIFIED BY '12345678';
CREATE USER 'sir'@'10.100.32.71' IDENTIFIED BY 'iamsir';
GRANT SELECT ON alam.* TO 'amjonota'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON alam.* TO 'sir'@'10.100.32.71';

INSERT INTO user (first_name, last_name, HomeTown, Password)
VALUES ('Mahmud', 'Turza', 'Jhenaidah', '0012345#'),
       ('Kaoser', 'Ahmed', 'Gazipur', '01234#'),
       ('Ahamed', 'Siyam', 'Dhaka', '11021#'),
       ('SS', 'Turza', 'Jhenaidah', '0012345q')
ON DUPLICATE KEY UPDATE
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    HomeTown = VALUES(HomeTown),
    Password = VALUES(Password);
alter table event
add column country varchar(30);
INSERT IGNORE INTO user (first_name, last_name, HomeTown, Password)
VALUES ('Mahmud', 'Turza', 'Jhenaidah', '0012345#'),
       ('Kaoser', 'Ahmed', 'Gazipur', '01234#'),
       ('Ahamed', 'Siyam', 'Dhaka', '11021#'),
       ('SS', 'Turza', 'Jhenaidah', '0012345q');


INSERT INTO bd_university (university_name, cgpa, Department, Admitted_year, user_id)
SELECT university_name, cgpa, Department, Admitted_year, user_id
FROM (
    SELECT 'SUST' AS university_name, 3.56 AS cgpa, 'CSE' AS Department, '2016' AS Admitted_year, 1 AS user_id
    UNION ALL
    SELECT 'DU' AS university_name, 3.45 AS cgpa, 'EEE' AS Department, '2015' AS Admitted_year, 2 AS user_id
    UNION ALL
    SELECT 'SUST' AS university_name, 3.46 AS cgpa, 'CSE' AS Department, '2017' AS Admitted_year, 3 AS user_id
    UNION ALL
    SELECT 'SUST' AS university_name, 3.46 AS cgpa, 'CSE' AS Department, '2017' AS Admitted_year, 4 AS user_id
) AS u
WHERE user_id NOT IN (SELECT user_id FROM bd_university);
INSERT INTO phone_number(user_id, Phone_number)
values (1,'0174208783'),
       (1,'9987674320'),
       (1,'0110180400'),
       (2,'9930303030'),
       (3,'2020220202'),
       (4,'0101010101');
INSERT INTO `Specelized_field` (user_id, Specelized_field)
VALUES (1, 'Software Engineering'),
       (2, 'Data Science'),
       (3, 'Marketing');
INSERT INTO `foren` (university_name, degree_type, country, Admitted_year, Passed_year, status, user_id)
VALUES ('Foreign University 1', 'Bachelor', 'Canada', '2016', '2020', 'active', 1),
       ('International College', 'Master', 'UK', '2017', '2019', 'active', 2),
       ('Overseas School', 'Bachelor', 'Australia', '2015', '2019', 'inactive', 3);
INSERT INTO `LivingPlace` (user_id, address, start_time, end_time)
VALUES (1, '123 Main St, Springfield', 2015, 2020),
       (2, '456 Elm St, New York', 2017, 2022),
       (3, '789 Oak St, Los Angeles', 2016, 2021);
INSERT INTO `Medical_info` (preferred_doctor, preferred_medical)
VALUES ('Dr. Johnson', 'General Practitioner'),
       ('Dr. Smith', 'Dermatologist'),
       ('Dr. Patel', 'Oncologist');
INSERT INTO `User_Medical_Info` (user_id, preferred_doctor, preferred_medical)
VALUES (1, 'Dr. Johnson', 'General Practitioner'),
       (2, 'Dr. Smith', 'Dermatologist'),
       (3, 'Dr. Patel', 'Oncologist');
INSERT INTO `Group` (group_id, group_name)
VALUES (1, 'Engineering Club'),
       (2, 'Data Science Society'),
       (3, 'Marketing Association');

INSERT INTO `Group_Admin` (group_id, user_id)
VALUES (1, 1),
       (2, 2),
       (1, 3);
INSERT INTO `Group_Member` (group_id, user_id)
VALUES (1, 1),
       (1, 2),
       (2, 3);
INSERT INTO `Event` (event_id, event_time, event_place, country)
VALUES
    (1, '2024-05-15 09:00:00', 'Conference Room A', 'USA'),
    (2, '2024-06-10 18:30:00', 'Auditorium B', 'Canada'),
    (3, '2024-07-02 14:00:00', 'Outdoor Park', 'UK');
INSERT INTO `Event_User` (event_id, user_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);
INSERT INTO `Event_Group` (event_id, group_id)
VALUES (1, 1),
       (2, 2),
       (3, 1);

insert into alam.phone_number(user_id, Phone_number)
values (1,'0202020202');
#1.	Find out the  users who are from Dhaka.
SELECT name, HomeTown
FROM user
WHERE HomeTown = 'Dhaka';
#2.	Find the number of users from each hometown.

SELECT HomeTown, COUNT(*) AS number_of_users
FROM user
GROUP BY HomeTown
HAVING COUNT(*) >= 1;

#3.	Find users who have a CGPA greater than 3.50

SELECT  name
FROM user
WHERE user_id IN (
    SELECT user_id
    FROM bd_university
    WHERE cgpa > 3.50
);
#4.Find users along with their phone numbers.
SELECT distinct (name), GetPhoneNumber(u.user_id) AS phone_number
FROM user u
INNER JOIN phone_number p ON u.user_id = p.user_id;

#5.	Find  active students associated with foreign universities .

SELECT u.name, f.university_name, f.country
FROM user u
LEFT JOIN foren f ON u.user_id = f.user_id
WHERE f.status = 'active';



























