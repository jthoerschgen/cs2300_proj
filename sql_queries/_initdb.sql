/*
 CS 2300 Project F23
 INIT Database
 */
PRAGMA foreign_keys = ON;
/*
 CREATE TABLES
 */
CREATE TABLE "members" (
    "studentid" INTEGER NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "year_joined" NUMERIC NOT NULL,
    "birthday" DATE,
    "pnumber" TEXT CHECK(
        "pnumber" GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    ),
    "password" TEXT NOT NULL DEFAULT 'changeme',
    "bbrother" INTEGER,
    FOREIGN KEY("bbrother") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARY KEY("studentid")
);
CREATE TABLE "member_majors" (
    "studentid" INTEGER NOT NULL,
    "major" TEXT NOT NULL,
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("studentid", "major")
);
CREATE TABLE "actives" (
    "studentid" INTEGER NOT NULL,
    "in_house" BOOL NOT NULL CHECK(
        "in_house" = TRUE
        OR "in_house" = FALSE
    ),
    "service_hours" INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("studentid"),
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE
);
CREATE TABLE "alumni" (
    "studentid" INTEGER NOT NULL,
    "grad_year" INTEGER NOT NULL,
    "employer" TEXT,
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("studentid")
);
CREATE TABLE "alumni_honors" (
    "alumni_studentid" INTEGER NOT NULL,
    "honor" TEXT NOT NULL,
    FOREIGN KEY("alumni_studentid") REFERENCES "alumni"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("alumni_studentid", "honor")
);
CREATE TABLE "courses" (
    "studentid" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "semester" CHAR(1) NOT NULL CHECK(
        "semester" = 'S'
        OR "semester" = 'F'
    ),
    "course_code" INTEGER NOT NULL,
    "department" TEXT NOT NULL,
    "start" TIME NOT NULL,
    "end" TIME NOT NULL,
    "grade" REAL NOT NULL DEFAULT 1 CHECK(
        "grade" <= 1
        AND "grade" >= 0
    ),
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY(
        "studentid",
        "year",
        "semester",
        "course_code",
        "department"
    )
);
CREATE TABLE "course_days" (
    "studentid" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "semester" CHAR(1) NOT NULL CHECK(
        "semester" = 'S'
        OR "semester" = 'F'
    ),
    "course_code" INTEGER NOT NULL,
    "department" TEXT NOT NULL,
    "day" TEXT NOT NULL CHECK(
        "day" = 'SUN'
        OR "day" = 'MON'
        OR "day" = 'TUE'
        OR "day" = 'WED'
        OR "day" = 'THU'
        OR "day" = 'FRI'
        OR "day" = 'SAT'
    ),
    FOREIGN KEY(
        "semester",
        "studentid",
        "course_code",
        "year",
        "department"
    ) REFERENCES "courses"(
        "semester",
        "studentid",
        "course_code",
        "year",
        "department"
    ) ON DELETE CASCADE,
    PRIMARY KEY(
        "studentid",
        "year",
        "semester",
        "course_code",
        "department",
        "day"
    )
);
CREATE TABLE "exec_board" (
    "studentid" INTEGER NOT NULL,
    "position" TEXT NOT NULL,
    "semester" CHAR(1) NOT NULL CHECK(
        "semester" = 'S'
        OR "semester" = 'F'
    ),
    "year" INTEGER NOT NULL,
    "can_vote" BOOL NOT NULL DEFAULT 'FALSE',
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("studentid", "position", "semester", "year")
);
CREATE TABLE "details" (
    "name" TEXT NOT NULL,
    "day" DATE NOT NULL,
    "studentid" INTEGER NOT NULL,
    "checked_off_by_id" TEXT,
    "checked_by_off_position" TEXT,
    "checked_by_off_semester" CHAR(1) CHECK(
        "semester" = 'S'
        OR "semester" = 'F'
        OR "semester" = NULL
    ),
    "checked_off_by_year" INTEGER,
    FOREIGN KEY(
        "checked_off_by_id",
        "checked_by_off_position",
        "checked_by_off_semester",
        "checked_off_by_year"
    ) REFERENCES "exec_board"("studentid", "position", "semester", "year") ON DELETE
    SET NULL,
        FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARY KEY("name", "day", "studentid")
);
CREATE TABLE "emergency_contacts" (
    "studentid" INTEGER NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "zipcode" INTEGER NOT NULL,
    "street_address" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "email" TEXT NOT NULL CHECK("email" LIKE '%_@_%._%'),
    "pnumber" TEXT NOT NULL CHECK(
        "pnumber" GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    ),
    PRIMARY KEY("studentid", "lname", "fname"),
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE
);
CREATE TABLE "fine" (
    "issuer" INTEGER NOT NULL,
    "recipient" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "date_issued" DATE NOT NULL,
    "amount" REAL NOT NULL,
    FOREIGN KEY("recipient") REFERENCES "members"("studentid") ON DELETE CASCADE,
    FOREIGN KEY("issuer") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("issuer", "recipient", "reason", "date_issued")
);
CREATE TABLE "studyhours" (
    "studentid" INTEGER NOT NULL,
    "num_hrs" INTEGER NOT NULL,
    "can_vg" BOOL NOT NULL,
    "sopro" BOOL NOT NULL,
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE CASCADE,
    PRIMARY KEY("studentid")
);
/*
 INSERT DATA
 */
-- SQL Query for filling in data to the members table
INSERT INTO members (
        studentid,
        fname,
        lname,
        year_joined,
        birthday,
        pnumber,
        password,
        bbrother
    )
VALUES (
        1,
        'John',
        'Doe',
        2019,
        '2001-03-15',
        '5735551234',
        'Password123',
        NULL
    ),
    (
        2,
        'Michael',
        'Smith',
        2019,
        '2001-07-22',
        '5735555678',
        'SecurePass789',
        NULL
    ),
    (
        3,
        'Christopher',
        'Johnson',
        2019,
        '2001-05-10',
        '5735559012',
        'Changeme!23',
        NULL
    ),
    (
        4,
        'Daniel',
        'Williams',
        2019,
        '2000-12-03',
        '5735553456',
        'StudentPwd456',
        NULL
    ),
    (
        5,
        'Matthew',
        'Brown',
        2020,
        '2001-09-18',
        '5735557890',
        'P@ssw0rd!',
        1
    ),
    (
        6,
        'Joseph',
        'Miller',
        2020,
        '2002-02-28',
        '5735552345',
        'SecretPass12',
        2
    ),
    (
        7,
        'William',
        'Davis',
        2020,
        '2001-11-14',
        '5735556789',
        'Welcome789',
        3
    ),
    (
        8,
        'David',
        'Garcia',
        2020,
        '2002-04-07',
        '5735550123',
        'MyPassword456',
        3
    ),
    (
        9,
        'Richard',
        'Rodriguez',
        2020,
        '2001-08-25',
        '5735554567',
        'Summer2022!',
        4
    ),
    (
        10,
        'Charles',
        'Martinez',
        2021,
        '2003-01-20',
        '5735558901',
        '1234abcd!',
        5
    ),
    (
        11,
        'Thomas',
        'Hernandez',
        2021,
        '2003-06-12',
        '5735552345',
        'DbUserPass',
        6
    ),
    (
        12,
        'Andrew',
        'Lopez',
        2021,
        '2002-10-30',
        '5735556789',
        'November#2023',
        7
    ),
    (
        13,
        'Robert',
        'Jackson',
        2021,
        '2002-09-03',
        '5735551234',
        'BlueSky789',
        8
    ),
    (
        14,
        'Johnathan',
        'Hill',
        2021,
        '2003-02-15',
        '5735555678',
        'Pa$$w0rd2022',
        9
    ),
    (
        15,
        'Ryan',
        'King',
        2022,
        '2004-07-01',
        '5735559012',
        'AccessGranted!',
        10
    ),
    (
        16,
        'Jeremy',
        'Wright',
        2022,
        '2004-04-24',
        '5735553456',
        'Tiger#2021',
        11
    ),
    (
        17,
        'Nicholas',
        'Lopez',
        2022,
        '2003-11-08',
        '5735557890',
        'WinterPwd123',
        11
    ),
    (
        18,
        'Kevin',
        'Young',
        2022,
        '2003-08-17',
        '5735552345',
        'CodingRocks!',
        12
    ),
    (
        19,
        'Brian',
        'Scott',
        2022,
        '2004-01-09',
        '5735556789',
        'Purple123!',
        14
    ),
    (
        20,
        'Jacob',
        'Green',
        2023,
        '2005-06-02',
        '5735550123',
        'Sunshine22',
        15
    ),
    (
        21,
        'Gary',
        'Adams',
        2023,
        '2005-03-19',
        '5735554567',
        'LetMeIn567',
        16
    ),
    (
        22,
        'Timothy',
        'Nelson',
        2023,
        '2004-10-11',
        '5735558901',
        'RedRose#2020',
        17
    ),
    (
        23,
        'Jose',
        'Baker',
        2023,
        '2005-05-05',
        '5735552345',
        'SecureLogin!',
        18
    ),
    (
        24,
        'Jeffrey',
        'Carter',
        2023,
        '2004-12-28',
        '5735556789',
        'StarWars456',
        19
    ),
    (
        25,
        'Scott',
        'Perez',
        2023,
        '2005-07-13',
        '5735551234',
        'RainbowPwd!',
        19
    );
-- SQL Query for filling in data to the actives table
INSERT INTO actives (
        studentid,
        in_house,
        service_hours
    )
VALUES (5, 1, 10),
    (6, 0, 15),
    (7, 1, 8),
    (8, 1, 20),
    (9, 0, 18),
    (10, 1, 22),
    (11, 1, 14),
    (12, 0, 25),
    (13, 1, 16),
    (14, 0, 12),
    (15, 1, 19),
    (16, 0, 23),
    (17, 1, 17),
    (18, 1, 21),
    (19, 0, 13),
    (20, 1, 11),
    (21, 0, 24),
    (22, 1, 18),
    (23, 0, 16),
    (24, 1, 20),
    (25, 1, 12);
-- SQL Query for filling in data to the member_majors table
INSERT INTO member_majors (studentid, major)
VALUES (1, 'Computer Science'),
    (2, 'Civil Engineering'),
    (3, 'Computer Engineering'),
    (3, 'Computer Science'),
    (4, 'Mechanical Engineering'),
    (5, 'Chemical Engineering'),
    (6, 'Aerospace Engineering'),
    (7, 'Mechanical Engineering'),
    (8, 'Computer Engineering'),
    (9, 'Computer Science'),
    (10, 'Civil Engineering'),
    (11, 'Computer Science'),
    (12, 'Mechanical Engineering'),
    (13, 'Mechanical Engineering'),
    (14, 'Computer Engineering'),
    (15, 'Computer Science'),
    (16, 'Chemical Engineering'),
    (16, 'Civil Engineering'),
    (17, 'Mechanical Engineering'),
    (18, 'Computer Science'),
    (19, 'Computer Engineering'),
    (20, 'Civil Engineering'),
    (21, 'Mechanical Engineering'),
    (21, 'Aerospace Engineering'),
    (22, 'Civil Engineering'),
    (23, 'Chemical Engineering'),
    (24, 'Computer Science'),
    (25, 'Civil Engineering');
-- SQL Query for filling in data to the alumni table
INSERT INTO alumni (studentid, grad_year, employer)
VALUES (1, 2023, 'Software Solutions'),
    (2, 2023, NULL),
    (3, 2023, 'Cars, Cars, and Trucks LLC'),
    (4, 2023, NULL);
-- SQL Query for filling in data to the alumni_honors table
INSERT INTO alumni_honors (alumni_studentid, honor)
VALUES (2, 'summa cum laude'),
    (2, 'coolest dude'),
    (4, 'most likely to succeed');
-- SQL Query for filling in data to the exec_board table
INSERT INTO exec_board (studentid, position, semester, year, can_vote)
VALUES (1, 'President', 'F', 2019, 'TRUE'),
    (2, 'Secretary', 'F', 2019, 'FALSE'),
    (3, 'Treasurer', 'F', 2019, 'TRUE'),
    (4, 'Recruitment', 'F', 2019, 'TRUE'),
    (4, 'President', 'S', 2020, 'TRUE'),
    (2, 'Secretary', 'S', 2020, 'FALSE'),
    (1, 'Treasurer', 'S', 2020, 'TRUE'),
    (3, 'Recruitment', 'S', 2020, 'TRUE'),
    (5, 'President', 'F', 2020, 'TRUE'),
    (7, 'Secretary', 'F', 2020, 'FALSE'),
    (4, 'Treasurer', 'F', 2020, 'TRUE'),
    (6, 'Recruitment', 'F', 2020, 'TRUE'),
    (6, 'President', 'S', 2021, 'TRUE'),
    (4, 'Secretary', 'S', 2021, 'FALSE'),
    (7, 'Treasurer', 'S', 2021, 'TRUE'),
    (5, 'Recruitment', 'S', 2021, 'TRUE'),
    (9, 'President', 'F', 2021, 'TRUE'),
    (10, 'Secretary', 'F', 2021, 'FALSE'),
    (11, 'Treasurer', 'F', 2021, 'TRUE'),
    (12, 'Recruitment', 'F', 2021, 'TRUE'),
    (11, 'President', 'S', 2022, 'TRUE'),
    (9, 'Secretary', 'S', 2022, 'FALSE'),
    (10, 'Treasurer', 'S', 2022, 'TRUE'),
    (12, 'Recruitment', 'S', 2022, 'TRUE'),
    (16, 'President', 'F', 2022, 'TRUE'),
    (15, 'Secretary', 'F', 2022, 'FALSE'),
    (14, 'Treasurer', 'F', 2022, 'TRUE'),
    (16, 'Recruitment', 'F', 2022, 'TRUE'),
    (13, 'President', 'S', 2023, 'TRUE'),
    (16, 'Secretary', 'S', 2023, 'FALSE'),
    (18, 'Treasurer', 'S', 2023, 'TRUE'),
    (12, 'Recruitment', 'S', 2023, 'TRUE'),
    (15, 'President', 'F', 2023, 'TRUE'),
    (16, 'Secretary', 'F', 2023, 'FALSE'),
    (20, 'Treasurer', 'F', 2023, 'TRUE'),
    (19, 'Recruitment', 'F', 2023, 'TRUE'),
    (21, 'President', 'S', 2024, 'TRUE'),
    (22, 'Secretary', 'S', 2024, 'FALSE'),
    (18, 'Treasurer', 'S', 2024, 'TRUE'),
    (25, 'Recruitment', 'S', 2024, 'TRUE');
-- SQL Query for filling in data to the fine table
INSERT INTO "fine" (
        "issuer",
        "recipient",
        "reason",
        "date_issued",
        "amount"
    )
VALUES (
        1,
        2,
        'Wearing mismatched socks',
        '2023-11-06',
        25.00
    ),
    (3, 4, 'Excessive pun usage', '2023-11-07', 30.00),
    (
        5,
        6,
        'Singing in the library',
        '2023-11-08',
        20.00
    ),
    (
        7,
        8,
        'Wearing sunglasses indoors',
        '2023-11-09',
        15.00
    ),
    (
        9,
        10,
        'Using too many emojis in emails',
        '2023-11-10',
        25.00
    ),
    (
        11,
        12,
        'Talking to plants in public',
        '2023-11-11',
        20.00
    ),
    (
        13,
        14,
        'Wearing a superhero cape to class',
        '2023-11-06',
        30.00
    ),
    (
        15,
        16,
        'Using a fake British accent',
        '2023-11-07',
        15.00
    ),
    (
        17,
        18,
        'Overloading the coffee machine',
        '2023-11-08',
        25.00
    ),
    (
        19,
        20,
        'Dancing in the elevator',
        '2023-11-09',
        20.00
    );
-- SQL Query for filling in data to the studyhours table
INSERT INTO "studyhours" ("studentid", "num_hrs", "can_vg", "sopro")
VALUES (10, 4, true, false),
    (14, 4, false, false),
    (15, 2, true, true),
    (17, 4, false, false),
    (20, 2, true, true),
    (21, 4, false, false),
    (22, 4, false, false),
    (23, 4, false, false),
    (24, 4, false, false),
    (25, 4, false, false);
-- SQL Query for filling in data to the emergency_contacts table
INSERT INTO emergency_contacts (
        studentid,
        fname,
        lname,
        zipcode,
        street_address,
        city,
        state,
        email,
        pnumber
    )
VALUES (
        1,
        'John',
        'Doe',
        12345,
        '123 Main St',
        'City1',
        'CA',
        'john.doe@email.com',
        '1234567890'
    ),
    (
        1,
        'Jane',
        'Doe',
        12345,
        '456 Oak St',
        'City1',
        'CA',
        'jane.doe@email.com',
        '9876543210'
    ),
    (
        2,
        'Michael',
        'Smith',
        23456,
        '456 Oak St',
        'City2',
        'NY',
        'michael.smith@email.com',
        '9876543210'
    ),
    (
        2,
        'Michelle',
        'Smith',
        23456,
        '789 Pine St',
        'City2',
        'NY',
        'michelle.smith@email.com',
        '1234567890'
    ),
    (
        3,
        'Christopher',
        'Johnson',
        34567,
        '789 Pine St',
        'City3',
        'TX',
        'chris.johnson@email.com',
        '4567890123'
    ),
    (
        3,
        'Christine',
        'Johnson',
        34567,
        '123 Main St',
        'City3',
        'TX',
        'christine.johnson@email.com',
        '7890123456'
    ),
    (
        4,
        'Daniel',
        'Williams',
        45678,
        '987 Cedar St',
        'City4',
        'FL',
        'daniel.williams@email.com',
        '6543210987'
    ),
    (
        5,
        'Matthew',
        'Brown',
        56789,
        '654 Maple St',
        'City5',
        'WA',
        'matthew.brown@email.com',
        '9876543210'
    ),
    (
        6,
        'Joseph',
        'Miller',
        67890,
        '321 Elm St',
        'City6',
        'OH',
        'joseph.miller@email.com',
        '1234567890'
    ),
    (
        7,
        'William',
        'Davis',
        78901,
        '876 Pine St',
        'City7',
        'IL',
        'william.davis@email.com',
        '4567890123'
    ),
    (
        8,
        'David',
        'Garcia',
        89012,
        '543 Birch St',
        'City8',
        'CA',
        'david.garcia@email.com',
        '6543210987'
    ),
    (
        9,
        'Richard',
        'Rodriguez',
        90123,
        '987 Oak St',
        'City9',
        'TX',
        'richard.rodriguez@email.com',
        '7890123456'
    ),
    (
        10,
        'Charles',
        'Martinez',
        12345,
        '321 Maple St',
        'City10',
        'NY',
        'charles.martinez@email.com',
        '1234567890'
    ),
    (
        11,
        'Thomas',
        'Hernandez',
        23456,
        '876 Cedar St',
        'City11',
        'FL',
        'thomas.hernandez@email.com',
        '9876543210'
    ),
    (
        12,
        'Andrew',
        'Lopez',
        34567,
        '543 Birch St',
        'City12',
        'WA',
        'andrew.lopez@email.com',
        '4567890123'
    ),
    (
        13,
        'Robert',
        'Jackson',
        45678,
        '987 Elm St',
        'City13',
        'OH',
        'robert.jackson@email.com',
        '6543210987'
    ),
    (
        14,
        'Johnathan',
        'Hill',
        56789,
        '321 Pine St',
        'City14',
        'IL',
        'johnathan.hill@email.com',
        '7890123456'
    ),
    (
        15,
        'Ryan',
        'King',
        67890,
        '876 Oak St',
        'City15',
        'CA',
        'ryan.king@email.com',
        '1234567890'
    ),
    (
        16,
        'Jeremy',
        'Wright',
        78901,
        '543 Maple St',
        'City16',
        'TX',
        'jeremy.wright@email.com',
        '9876543210'
    ),
    (
        17,
        'Nicholas',
        'Lopez',
        89012,
        '987 Cedar St',
        'City17',
        'NY',
        'nicholas.lopez@email.com',
        '4567890123'
    ),
    (
        18,
        'Kevin',
        'Young',
        90123,
        '876 Pine St',
        'City18',
        'FL',
        'kevin.young@email.com',
        '6543210987'
    ),
    (
        19,
        'Brian',
        'Scott',
        12345,
        '543 Birch St',
        'City19',
        'WA',
        'brian.scott@email.com',
        '7890123456'
    ),
    (
        20,
        'Jacob',
        'Green',
        23456,
        '876 Elm St',
        'City20',
        'OH',
        'jacob.green@email.com',
        '1234567890'
    ),
    (
        21,
        'Gary',
        'Adams',
        34567,
        '321 Maple St',
        'City21',
        'IL',
        'gary.adams@email.com',
        '9876543210'
    ),
    (
        22,
        'Timothy',
        'Nelson',
        45678,
        '987 Pine St',
        'City22',
        'CA',
        'timothy.nelson@email.com',
        '4567890123'
    ),
    (
        23,
        'Jose',
        'Baker',
        56789,
        '876 Cedar St',
        'City23',
        'TX',
        'jose.baker@email.com',
        '6543210987'
    ),
    (
        24,
        'Jeffrey',
        'Carter',
        67890,
        '543 Birch St',
        'City24',
        'NY',
        'jeffrey.carter@email.com',
        '7890123456'
    ),
    (
        25,
        'Scott',
        'Perez',
        78901,
        '876 Oak St',
        'City25',
        'GA',
        'scott.perez@email.com',
        '1234567890'
    );
-- SQL Query for filling in data to the details table
-- Inserting entries for Kitchen
INSERT INTO details ("name", "day", "studentid")
VALUES ('Kitchen', '2023-11-04', 16),
    ('Kitchen', '2023-11-05', 17),
    ('Kitchen', '2023-11-06', 18),
    ('Kitchen', '2023-11-07', 19),
    ('Kitchen', '2023-11-08', 20),
    ('Kitchen', '2023-11-09', 21),
    ('Kitchen', '2023-11-10', 22),
    ('Kitchen', '2023-11-11', 23);
-- Inserting entries for Bathroom
INSERT INTO details ("name", "day", "studentid")
VALUES ('Bathroom', '2023-11-04', 24),
    ('Bathroom', '2023-11-05', 25),
    ('Bathroom', '2023-11-06', 16),
    ('Bathroom', '2023-11-07', 17),
    ('Bathroom', '2023-11-08', 18),
    ('Bathroom', '2023-11-09', 19),
    ('Bathroom', '2023-11-10', 20),
    ('Bathroom', '2023-11-11', 21);
-- Inserting entries for Garbage
INSERT INTO details ("name", "day", "studentid")
VALUES ('Garbage', '2023-11-04', 22),
    ('Garbage', '2023-11-05', 23),
    ('Garbage', '2023-11-06', 24),
    ('Garbage', '2023-11-07', 25),
    ('Garbage', '2023-11-08', 16),
    ('Garbage', '2023-11-09', 17),
    ('Garbage', '2023-11-10', 18),
    ('Garbage', '2023-11-11', 19);
-- SQL Query for filling in data to the courses table
INSERT INTO courses (
        studentid,
        year,
        semester,
        course_code,
        department,
        start,
    end,
    grade
)
VALUES -- Student 5
    (
        '5',
        2023,
        'S',
        101,
        'AE',
        '08:00:00',
        '10:00:00',
        0.85
    ),
    (
        '5',
        2023,
        'S',
        201,
        'CE',
        '10:30:00',
        '12:30:00',
        0.75
    ),
    (
        '5',
        2023,
        'S',
        301,
        'CS',
        '13:00:00',
        '15:00:00',
        0.92
    ),
    (
        '5',
        2023,
        'S',
        401,
        'CH',
        '15:30:00',
        '17:30:00',
        0.88
    ),
    (
        '5',
        2023,
        'S',
        501,
        'ME',
        '18:00:00',
        '20:00:00',
        0.79
    ),
    -- Student 6
    (
        '6',
        2023,
        'S',
        102,
        'ME',
        '08:30:00',
        '10:30:00',
        0.78
    ),
    (
        '6',
        2023,
        'S',
        202,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '6',
        2023,
        'S',
        302,
        'EN',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '6',
        2023,
        'S',
        402,
        'CS',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '6',
        2023,
        'S',
        502,
        'CH',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 7
    (
        '7',
        2023,
        'S',
        103,
        'CS',
        '08:00:00',
        '10:00:00',
        0.87
    ),
    (
        '7',
        2023,
        'S',
        203,
        'EN',
        '10:30:00',
        '12:30:00',
        0.91
    ),
    (
        '7',
        2023,
        'S',
        303,
        'MA',
        '13:00:00',
        '15:00:00',
        0.89
    ),
    (
        '7',
        2023,
        'S',
        403,
        'ME',
        '15:30:00',
        '17:30:00',
        0.82
    ),
    -- Student 8
    (
        '8',
        2023,
        'S',
        104,
        'AE',
        '08:30:00',
        '10:30:00',
        0.88
    ),
    (
        '8',
        2023,
        'S',
        204,
        'CH',
        '11:00:00',
        '13:00:00',
        0.75
    ),
    (
        '8',
        2023,
        'S',
        304,
        'EN',
        '13:30:00',
        '15:30:00',
        0.94
    ),
    (
        '8',
        2023,
        'S',
        404,
        'CS',
        '16:00:00',
        '18:00:00',
        0.86
    ),
    (
        '8',
        2023,
        'S',
        504,
        'ME',
        '18:30:00',
        '20:30:00',
        0.79
    ),
    -- Student 9
    (
        '9',
        2023,
        'S',
        106,
        'EN',
        '08:00:00',
        '10:00:00',
        0.89
    ),
    (
        '9',
        2023,
        'S',
        206,
        'MA',
        '10:30:00',
        '12:30:00',
        0.93
    ),
    (
        '9',
        2023,
        'S',
        306,
        'CS',
        '13:00:00',
        '15:00:00',
        0.91
    ),
    (
        '9',
        2023,
        'S',
        406,
        'ME',
        '15:30:00',
        '17:30:00',
        0.85
    ),
    -- Student 10
    (
        '10',
        2023,
        'S',
        107,
        'CH',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '10',
        2023,
        'S',
        207,
        'EN',
        '11:00:00',
        '13:00:00',
        0.88
    ),
    (
        '10',
        2023,
        'S',
        307,
        'MA',
        '13:30:00',
        '15:30:00',
        0.90
    ),
    (
        '10',
        2023,
        'S',
        407,
        'CS',
        '16:00:00',
        '18:00:00',
        0.94
    ),
    (
        '10',
        2023,
        'S',
        507,
        'ME',
        '18:30:00',
        '20:30:00',
        0.86
    ),
    -- Student 11
    (
        '11',
        2023,
        'S',
        113,
        'CS',
        '08:00:00',
        '10:00:00',
        0.92
    ),
    (
        '11',
        2023,
        'S',
        213,
        'EN',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '11',
        2023,
        'S',
        313,
        'MA',
        '13:00:00',
        '15:00:00',
        0.89
    ),
    (
        '11',
        2023,
        'S',
        413,
        'ME',
        '15:30:00',
        '17:30:00',
        0.86
    ),
    (
        '11',
        2023,
        'S',
        513,
        'CH',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 12
    (
        '12',
        2023,
        'S',
        114,
        'EN',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '12',
        2023,
        'S',
        214,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '12',
        2023,
        'S',
        314,
        'CS',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '12',
        2023,
        'S',
        414,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '12',
        2023,
        'S',
        514,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 13
    (
        '13',
        2023,
        'S',
        115,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '13',
        2023,
        'S',
        215,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '13',
        2023,
        'S',
        315,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '13',
        2023,
        'S',
        415,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '13',
        2023,
        'S',
        515,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 14
    (
        '14',
        2023,
        'S',
        116,
        'MA',
        '08:00:00',
        '10:00:00',
        0.89
    ),
    (
        '14',
        2023,
        'S',
        216,
        'EN',
        '10:30:00',
        '12:30:00',
        0.91
    ),
    (
        '14',
        2023,
        'S',
        316,
        'CS',
        '13:00:00',
        '15:00:00',
        0.92
    ),
    (
        '14',
        2023,
        'S',
        416,
        'CH',
        '15:30:00',
        '17:30:00',
        0.88
    ),
    (
        '14',
        2023,
        'S',
        516,
        'ME',
        '18:00:00',
        '20:00:00',
        0.79
    ),
    -- Student 15
    (
        '15',
        2023,
        'S',
        117,
        'CH',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '15',
        2023,
        'S',
        217,
        'EN',
        '11:00:00',
        '13:00:00',
        0.88
    ),
    (
        '15',
        2023,
        'S',
        317,
        'MA',
        '13:30:00',
        '15:30:00',
        0.90
    ),
    (
        '15',
        2023,
        'S',
        417,
        'CS',
        '16:00:00',
        '18:00:00',
        0.94
    ),
    (
        '15',
        2023,
        'S',
        517,
        'ME',
        '18:30:00',
        '20:30:00',
        0.86
    ),
    -- Student 16
    (
        '16',
        2023,
        'S',
        118,
        'EN',
        '08:00:00',
        '10:00:00',
        0.92
    ),
    (
        '16',
        2023,
        'S',
        218,
        'MA',
        '10:30:00',
        '12:30:00',
        0.94
    ),
    (
        '16',
        2023,
        'S',
        318,
        'CS',
        '13:00:00',
        '15:00:00',
        0.91
    ),
    (
        '16',
        2023,
        'S',
        418,
        'ME',
        '15:30:00',
        '17:30:00',
        0.85
    ),
    (
        '16',
        2023,
        'S',
        518,
        'CH',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 17
    (
        '17',
        2023,
        'S',
        119,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '17',
        2023,
        'S',
        219,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '17',
        2023,
        'S',
        319,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '17',
        2023,
        'S',
        419,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '17',
        2023,
        'S',
        519,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 18
    (
        '18',
        2023,
        'S',
        120,
        'CS',
        '08:00:00',
        '10:00:00',
        0.94
    ),
    (
        '18',
        2023,
        'S',
        220,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '18',
        2023,
        'S',
        320,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '18',
        2023,
        'S',
        420,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '18',
        2023,
        'S',
        520,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 19
    (
        '19',
        2023,
        'S',
        121,
        'EN',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '19',
        2023,
        'S',
        221,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '19',
        2023,
        'S',
        321,
        'CS',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '19',
        2023,
        'S',
        421,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '19',
        2023,
        'S',
        521,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 20
    (
        '20',
        2023,
        'S',
        122,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '20',
        2023,
        'S',
        222,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '20',
        2023,
        'S',
        322,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '20',
        2023,
        'S',
        422,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '20',
        2023,
        'S',
        522,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 21
    (
        '21',
        2023,
        'S',
        123,
        'EN',
        '08:00:00',
        '10:00:00',
        0.92
    ),
    (
        '21',
        2023,
        'S',
        223,
        'MA',
        '10:30:00',
        '12:30:00',
        0.94
    ),
    (
        '21',
        2023,
        'S',
        323,
        'CS',
        '13:00:00',
        '15:00:00',
        0.91
    ),
    (
        '21',
        2023,
        'S',
        423,
        'ME',
        '15:30:00',
        '17:30:00',
        0.85
    ),
    (
        '21',
        2023,
        'S',
        523,
        'CH',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 22
    (
        '22',
        2023,
        'S',
        124,
        'CS',
        '08:30:00',
        '10:30:00',
        0.88
    ),
    (
        '22',
        2023,
        'S',
        224,
        'EN',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '22',
        2023,
        'S',
        324,
        'MA',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '22',
        2023,
        'S',
        424,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '22',
        2023,
        'S',
        524,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 23
    (
        '23',
        2023,
        'S',
        112,
        'MA',
        '08:00:00',
        '10:00:00',
        0.91
    ),
    (
        '23',
        2023,
        'S',
        212,
        'EN',
        '10:30:00',
        '12:30:00',
        0.87
    ),
    (
        '23',
        2023,
        'S',
        312,
        'CS',
        '13:00:00',
        '15:00:00',
        0.95
    ),
    (
        '23',
        2023,
        'S',
        412,
        'CH',
        '15:30:00',
        '17:30:00',
        0.89
    ),
    (
        '23',
        2023,
        'S',
        512,
        'ME',
        '18:00:00',
        '20:00:00',
        0.92
    ),
    -- Student 24
    (
        '24',
        2023,
        'S',
        108,
        'CH',
        '08:00:00',
        '10:00:00',
        0.90
    ),
    (
        '24',
        2023,
        'S',
        208,
        'EN',
        '10:30:00',
        '12:30:00',
        0.85
    ),
    (
        '24',
        2023,
        'S',
        308,
        'MA',
        '13:00:00',
        '15:00:00',
        0.92
    ),
    (
        '24',
        2023,
        'S',
        408,
        'CS',
        '15:30:00',
        '17:30:00',
        0.87
    ),
    (
        '24',
        2023,
        'S',
        508,
        'ME',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 25
    (
        '25',
        2023,
        'S',
        105,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '25',
        2023,
        'S',
        205,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '25',
        2023,
        'S',
        305,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '25',
        2023,
        'S',
        405,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '25',
        2023,
        'S',
        505,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    (
        '25',
        2023,
        'S',
        605,
        'AE',
        '20:30:00',
        '22:30:00',
        0.79
    );
INSERT INTO courses (
        studentid,
        year,
        semester,
        course_code,
        department,
        start,
    end,
    grade
)
VALUES -- Student 5
    (
        '5',
        2023,
        'F',
        111,
        'CS',
        '08:00:00',
        '10:00:00',
        0.85
    ),
    (
        '5',
        2023,
        'F',
        211,
        'ME',
        '10:30:00',
        '12:30:00',
        0.75
    ),
    (
        '5',
        2023,
        'F',
        311,
        'EN',
        '13:00:00',
        '15:00:00',
        0.92
    ),
    (
        '5',
        2023,
        'F',
        411,
        'CH',
        '15:30:00',
        '17:30:00',
        0.88
    ),
    (
        '5',
        2023,
        'F',
        511,
        'MA',
        '18:00:00',
        '20:00:00',
        0.79
    ),
    -- Student 6
    (
        '6',
        2023,
        'F',
        112,
        'ME',
        '08:30:00',
        '10:30:00',
        0.78
    ),
    (
        '6',
        2023,
        'F',
        212,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '6',
        2023,
        'F',
        312,
        'EN',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '6',
        2023,
        'F',
        412,
        'CS',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '6',
        2023,
        'F',
        512,
        'CH',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 7
    (
        '7',
        2023,
        'F',
        113,
        'CS',
        '08:00:00',
        '10:00:00',
        0.87
    ),
    (
        '7',
        2023,
        'F',
        213,
        'EN',
        '10:30:00',
        '12:30:00',
        0.91
    ),
    (
        '7',
        2023,
        'F',
        313,
        'MA',
        '13:00:00',
        '15:00:00',
        0.89
    ),
    (
        '7',
        2023,
        'F',
        413,
        'ME',
        '15:30:00',
        '17:30:00',
        0.82
    ),
    -- Student 8
    (
        '8',
        2023,
        'F',
        114,
        'AE',
        '08:30:00',
        '10:30:00',
        0.88
    ),
    (
        '8',
        2023,
        'F',
        214,
        'CH',
        '11:00:00',
        '13:00:00',
        0.75
    ),
    (
        '8',
        2023,
        'F',
        314,
        'EN',
        '13:30:00',
        '15:30:00',
        0.94
    ),
    (
        '8',
        2023,
        'F',
        414,
        'CS',
        '16:00:00',
        '18:00:00',
        0.86
    ),
    (
        '8',
        2023,
        'F',
        514,
        'ME',
        '18:30:00',
        '20:30:00',
        0.79
    ),
    -- Student 9
    (
        '9',
        2023,
        'F',
        116,
        'EN',
        '08:00:00',
        '10:00:00',
        0.89
    ),
    (
        '9',
        2023,
        'F',
        216,
        'MA',
        '10:30:00',
        '12:30:00',
        0.93
    ),
    (
        '9',
        2023,
        'F',
        316,
        'CS',
        '13:00:00',
        '15:00:00',
        0.91
    ),
    (
        '9',
        2023,
        'F',
        416,
        'ME',
        '15:30:00',
        '17:30:00',
        0.85
    ),
    -- Student 10
    (
        '10',
        2023,
        'F',
        117,
        'CH',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '10',
        2023,
        'F',
        217,
        'EN',
        '11:00:00',
        '13:00:00',
        0.88
    ),
    (
        '10',
        2023,
        'F',
        317,
        'MA',
        '13:30:00',
        '15:30:00',
        0.90
    ),
    (
        '10',
        2023,
        'F',
        417,
        'CS',
        '16:00:00',
        '18:00:00',
        0.94
    ),
    (
        '10',
        2023,
        'F',
        517,
        'ME',
        '18:30:00',
        '20:30:00',
        0.86
    ),
    -- Student 11
    (
        '11',
        2023,
        'F',
        118,
        'CS',
        '08:00:00',
        '10:00:00',
        0.92
    ),
    (
        '11',
        2023,
        'F',
        218,
        'EN',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '11',
        2023,
        'F',
        318,
        'MA',
        '13:00:00',
        '15:00:00',
        0.89
    ),
    (
        '11',
        2023,
        'F',
        418,
        'ME',
        '15:30:00',
        '17:30:00',
        0.86
    ),
    (
        '11',
        2023,
        'F',
        518,
        'CH',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 12
    (
        '12',
        2023,
        'F',
        119,
        'EN',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '12',
        2023,
        'F',
        219,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '12',
        2023,
        'F',
        319,
        'CS',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '12',
        2023,
        'F',
        419,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '12',
        2023,
        'F',
        519,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 13
    (
        '13',
        2023,
        'F',
        120,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '13',
        2023,
        'F',
        220,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '13',
        2023,
        'F',
        320,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '13',
        2023,
        'F',
        420,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '13',
        2023,
        'F',
        520,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 14
    (
        '14',
        2023,
        'F',
        121,
        'MA',
        '08:00:00',
        '10:00:00',
        0.89
    ),
    (
        '14',
        2023,
        'F',
        221,
        'EN',
        '10:30:00',
        '12:30:00',
        0.91
    ),
    (
        '14',
        2023,
        'F',
        321,
        'CS',
        '13:00:00',
        '15:00:00',
        0.92
    ),
    (
        '14',
        2023,
        'F',
        421,
        'CH',
        '15:30:00',
        '17:30:00',
        0.88
    ),
    (
        '14',
        2023,
        'F',
        521,
        'ME',
        '18:00:00',
        '20:00:00',
        0.79
    ),
    -- Student 15
    (
        '15',
        2023,
        'F',
        122,
        'CH',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '15',
        2023,
        'F',
        222,
        'EN',
        '11:00:00',
        '13:00:00',
        0.88
    ),
    (
        '15',
        2023,
        'F',
        322,
        'MA',
        '13:30:00',
        '15:30:00',
        0.90
    ),
    (
        '15',
        2023,
        'F',
        422,
        'CS',
        '16:00:00',
        '18:00:00',
        0.94
    ),
    (
        '15',
        2023,
        'F',
        522,
        'ME',
        '18:30:00',
        '20:30:00',
        0.86
    ),
    -- Student 16
    (
        '16',
        2023,
        'F',
        123,
        'EN',
        '08:00:00',
        '10:00:00',
        0.92
    ),
    (
        '16',
        2023,
        'F',
        223,
        'MA',
        '10:30:00',
        '12:30:00',
        0.94
    ),
    (
        '16',
        2023,
        'F',
        323,
        'CS',
        '13:00:00',
        '15:00:00',
        0.91
    ),
    (
        '16',
        2023,
        'F',
        423,
        'ME',
        '15:30:00',
        '17:30:00',
        0.85
    ),
    (
        '16',
        2023,
        'F',
        523,
        'CH',
        '18:00:00',
        '20:00:00',
        0.91
    ),
    -- Student 17
    (
        '17',
        2023,
        'F',
        124,
        'CS',
        '08:30:00',
        '10:30:00',
        0.88
    ),
    (
        '17',
        2023,
        'F',
        224,
        'EN',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '17',
        2023,
        'F',
        324,
        'MA',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '17',
        2023,
        'F',
        424,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '17',
        2023,
        'F',
        524,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 18
    (
        '18',
        2023,
        'F',
        125,
        'CS',
        '08:00:00',
        '10:00:00',
        0.94
    ),
    (
        '18',
        2023,
        'F',
        225,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '18',
        2023,
        'F',
        325,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '18',
        2023,
        'F',
        425,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '18',
        2023,
        'F',
        525,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 19
    (
        '19',
        2023,
        'F',
        126,
        'EN',
        '08:30:00',
        '10:30:00',
        0.87
    ),
    (
        '19',
        2023,
        'F',
        226,
        'MA',
        '11:00:00',
        '13:00:00',
        0.95
    ),
    (
        '19',
        2023,
        'F',
        326,
        'CS',
        '13:30:00',
        '15:30:00',
        0.85
    ),
    (
        '19',
        2023,
        'F',
        426,
        'CH',
        '16:00:00',
        '18:00:00',
        0.91
    ),
    (
        '19',
        2023,
        'F',
        526,
        'ME',
        '18:30:00',
        '20:30:00',
        0.87
    ),
    -- Student 20
    (
        '20',
        2023,
        'F',
        127,
        'CS',
        '08:00:00',
        '10:00:00',
        0.93
    ),
    (
        '20',
        2023,
        'F',
        227,
        'ME',
        '10:30:00',
        '12:30:00',
        0.88
    ),
    (
        '20',
        2023,
        'F',
        327,
        'EN',
        '13:00:00',
        '15:00:00',
        0.94
    ),
    (
        '20',
        2023,
        'F',
        427,
        'CH',
        '15:30:00',
        '17:30:00',
        0.91
    ),
    (
        '20',
        2023,
        'F',
        527,
        'MA',
        '18:00:00',
        '20:00:00',
        0.85
    ),
    -- Student 21
    (
        '21',
        2023,
        'F',
        121,
        'EN',
        '09:00:00',
        '11:00:00',
        0.92
    ),
    (
        '21',
        2023,
        'F',
        221,
        'MA',
        '11:30:00',
        '13:30:00',
        0.94
    ),
    (
        '21',
        2023,
        'F',
        321,
        'CS',
        '14:00:00',
        '16:00:00',
        0.91
    ),
    (
        '21',
        2023,
        'F',
        421,
        'ME',
        '16:30:00',
        '18:30:00',
        0.85
    ),
    (
        '21',
        2023,
        'F',
        521,
        'CH',
        '19:00:00',
        '21:00:00',
        0.91
    ),
    -- Student 22
    (
        '22',
        2023,
        'F',
        122,
        'CS',
        '09:30:00',
        '11:30:00',
        0.93
    ),
    (
        '22',
        2023,
        'F',
        222,
        'ME',
        '12:00:00',
        '14:00:00',
        0.88
    ),
    (
        '22',
        2023,
        'F',
        322,
        'EN',
        '14:30:00',
        '16:30:00',
        0.94
    ),
    (
        '22',
        2023,
        'F',
        422,
        'CH',
        '17:00:00',
        '19:00:00',
        0.91
    ),
    (
        '22',
        2023,
        'F',
        522,
        'MA',
        '19:30:00',
        '21:30:00',
        0.85
    ),
    -- Student 23
    (
        '23',
        2023,
        'F',
        123,
        'EN',
        '09:00:00',
        '11:00:00',
        0.92
    ),
    (
        '23',
        2023,
        'F',
        223,
        'MA',
        '11:30:00',
        '13:30:00',
        0.94
    ),
    (
        '23',
        2023,
        'F',
        323,
        'CS',
        '14:00:00',
        '16:00:00',
        0.91
    ),
    (
        '23',
        2023,
        'F',
        423,
        'ME',
        '16:30:00',
        '18:30:00',
        0.85
    ),
    (
        '23',
        2023,
        'F',
        523,
        'CH',
        '19:00:00',
        '21:00:00',
        0.91
    ),
    -- Student 24
    (
        '24',
        2023,
        'F',
        124,
        'CS',
        '09:30:00',
        '11:30:00',
        0.88
    ),
    (
        '24',
        2023,
        'F',
        224,
        'EN',
        '12:00:00',
        '14:00:00',
        0.95
    ),
    (
        '24',
        2023,
        'F',
        324,
        'MA',
        '14:30:00',
        '16:30:00',
        0.85
    ),
    (
        '24',
        2023,
        'F',
        424,
        'CH',
        '17:00:00',
        '19:00:00',
        0.91
    ),
    (
        '24',
        2023,
        'F',
        524,
        'ME',
        '19:30:00',
        '21:30:00',
        0.87
    ),
    -- Student 25
    (
        '25',
        2023,
        'F',
        105,
        'CS',
        '09:00:00',
        '11:00:00',
        0.93
    ),
    (
        '25',
        2023,
        'F',
        205,
        'ME',
        '11:30:00',
        '13:30:00',
        0.88
    ),
    (
        '25',
        2023,
        'F',
        305,
        'EN',
        '14:00:00',
        '16:00:00',
        0.94
    ),
    (
        '25',
        2023,
        'F',
        405,
        'CH',
        '16:30:00',
        '18:30:00',
        0.91
    ),
    (
        '25',
        2023,
        'F',
        505,
        'MA',
        '19:00:00',
        '21:00:00',
        0.85
    ),
    (
        '25',
        2023,
        'F',
        605,
        'AE',
        '21:30:00',
        '23:30:00',
        0.79
    );
-- SQL Query for filling in data to the course_days table
INSERT INTO course_days (
        studentid,
        year,
        semester,
        course_code,
        department,
        day
    )
VALUES -- Student 5
    ('5', 2023, 'S', 101, 'AE', 'MON'),
    ('5', 2023, 'S', 101, 'AE', 'WED'),
    ('5', 2023, 'S', 101, 'AE', 'FRI'),
    ('5', 2023, 'S', 201, 'CE', 'TUE'),
    ('5', 2023, 'S', 201, 'CE', 'THU'),
    ('5', 2023, 'S', 301, 'CS', 'MON'),
    ('5', 2023, 'S', 301, 'CS', 'WED'),
    ('5', 2023, 'S', 301, 'CS', 'FRI'),
    ('5', 2023, 'S', 401, 'CH', 'TUE'),
    ('5', 2023, 'S', 401, 'CH', 'THU'),
    ('5', 2023, 'S', 501, 'ME', 'MON'),
    ('5', 2023, 'S', 501, 'ME', 'WED'),
    ('5', 2023, 'S', 501, 'ME', 'FRI'),
    -- Student 6
    ('6', 2023, 'S', 102, 'ME', 'MON'),
    ('6', 2023, 'S', 102, 'ME', 'WED'),
    ('6', 2023, 'S', 102, 'ME', 'FRI'),
    ('6', 2023, 'S', 202, 'MA', 'TUE'),
    ('6', 2023, 'S', 202, 'MA', 'THU'),
    ('6', 2023, 'S', 302, 'EN', 'MON'),
    ('6', 2023, 'S', 302, 'EN', 'WED'),
    ('6', 2023, 'S', 302, 'EN', 'FRI'),
    ('6', 2023, 'S', 402, 'CS', 'TUE'),
    ('6', 2023, 'S', 402, 'CS', 'THU'),
    ('6', 2023, 'S', 502, 'CH', 'MON'),
    ('6', 2023, 'S', 502, 'CH', 'WED'),
    ('6', 2023, 'S', 502, 'CH', 'FRI'),
    -- Student 7
    ('7', 2023, 'S', 103, 'CS', 'MON'),
    ('7', 2023, 'S', 103, 'CS', 'WED'),
    ('7', 2023, 'S', 103, 'CS', 'FRI'),
    ('7', 2023, 'S', 203, 'EN', 'TUE'),
    ('7', 2023, 'S', 203, 'EN', 'THU'),
    ('7', 2023, 'S', 303, 'MA', 'MON'),
    ('7', 2023, 'S', 303, 'MA', 'WED'),
    ('7', 2023, 'S', 303, 'MA', 'FRI'),
    ('7', 2023, 'S', 403, 'ME', 'TUE'),
    ('7', 2023, 'S', 403, 'ME', 'THU'),
    -- Student 8
    ('8', 2023, 'S', 104, 'AE', 'MON'),
    ('8', 2023, 'S', 104, 'AE', 'WED'),
    ('8', 2023, 'S', 104, 'AE', 'FRI'),
    ('8', 2023, 'S', 204, 'CH', 'TUE'),
    ('8', 2023, 'S', 204, 'CH', 'THU'),
    ('8', 2023, 'S', 304, 'EN', 'MON'),
    ('8', 2023, 'S', 304, 'EN', 'WED'),
    ('8', 2023, 'S', 304, 'EN', 'FRI'),
    ('8', 2023, 'S', 404, 'CS', 'TUE'),
    ('8', 2023, 'S', 404, 'CS', 'THU'),
    ('8', 2023, 'S', 504, 'ME', 'MON'),
    ('8', 2023, 'S', 504, 'ME', 'WED'),
    ('8', 2023, 'S', 504, 'ME', 'FRI'),
    -- Student 9
    ('9', 2023, 'S', 106, 'EN', 'MON'),
    ('9', 2023, 'S', 106, 'EN', 'WED'),
    ('9', 2023, 'S', 106, 'EN', 'FRI'),
    ('9', 2023, 'S', 206, 'MA', 'TUE'),
    ('9', 2023, 'S', 206, 'MA', 'THU'),
    ('9', 2023, 'S', 306, 'CS', 'MON'),
    ('9', 2023, 'S', 306, 'CS', 'WED'),
    ('9', 2023, 'S', 306, 'CS', 'FRI'),
    ('9', 2023, 'S', 406, 'ME', 'TUE'),
    ('9', 2023, 'S', 406, 'ME', 'THU'),
    -- Student 10
    ('10', 2023, 'S', 107, 'CH', 'MON'),
    ('10', 2023, 'S', 107, 'CH', 'WED'),
    ('10', 2023, 'S', 107, 'CH', 'FRI'),
    ('10', 2023, 'S', 207, 'EN', 'TUE'),
    ('10', 2023, 'S', 207, 'EN', 'THU'),
    ('10', 2023, 'S', 307, 'MA', 'MON'),
    ('10', 2023, 'S', 307, 'MA', 'WED'),
    ('10', 2023, 'S', 307, 'MA', 'FRI'),
    ('10', 2023, 'S', 407, 'CS', 'TUE'),
    ('10', 2023, 'S', 407, 'CS', 'THU'),
    ('10', 2023, 'S', 507, 'ME', 'MON'),
    ('10', 2023, 'S', 507, 'ME', 'WED'),
    ('10', 2023, 'S', 507, 'ME', 'FRI'),
    -- Student 11
    ('11', 2023, 'S', 113, 'CS', 'MON'),
    ('11', 2023, 'S', 113, 'CS', 'WED'),
    ('11', 2023, 'S', 113, 'CS', 'FRI'),
    ('11', 2023, 'S', 213, 'EN', 'TUE'),
    ('11', 2023, 'S', 213, 'EN', 'THU'),
    ('11', 2023, 'S', 313, 'MA', 'MON'),
    ('11', 2023, 'S', 313, 'MA', 'WED'),
    ('11', 2023, 'S', 313, 'MA', 'FRI'),
    ('11', 2023, 'S', 413, 'ME', 'TUE'),
    ('11', 2023, 'S', 413, 'ME', 'THU'),
    ('11', 2023, 'S', 513, 'CH', 'MON'),
    ('11', 2023, 'S', 513, 'CH', 'WED'),
    ('11', 2023, 'S', 513, 'CH', 'FRI'),
    -- Student 12
    ('12', 2023, 'S', 114, 'EN', 'MON'),
    ('12', 2023, 'S', 114, 'EN', 'WED'),
    ('12', 2023, 'S', 114, 'EN', 'FRI'),
    ('12', 2023, 'S', 214, 'MA', 'TUE'),
    ('12', 2023, 'S', 214, 'MA', 'THU'),
    ('12', 2023, 'S', 314, 'CS', 'MON'),
    ('12', 2023, 'S', 314, 'CS', 'WED'),
    ('12', 2023, 'S', 314, 'CS', 'FRI'),
    ('12', 2023, 'S', 414, 'CH', 'TUE'),
    ('12', 2023, 'S', 414, 'CH', 'THU'),
    ('12', 2023, 'S', 514, 'ME', 'MON'),
    ('12', 2023, 'S', 514, 'ME', 'WED'),
    ('12', 2023, 'S', 514, 'ME', 'FRI'),
    -- Student 13
    ('13', 2023, 'S', 115, 'CS', 'MON'),
    ('13', 2023, 'S', 115, 'CS', 'WED'),
    ('13', 2023, 'S', 115, 'CS', 'FRI'),
    ('13', 2023, 'S', 215, 'ME', 'TUE'),
    ('13', 2023, 'S', 215, 'ME', 'THU'),
    ('13', 2023, 'S', 315, 'EN', 'MON'),
    ('13', 2023, 'S', 315, 'EN', 'WED'),
    ('13', 2023, 'S', 315, 'EN', 'FRI'),
    ('13', 2023, 'S', 415, 'CH', 'TUE'),
    ('13', 2023, 'S', 415, 'CH', 'THU'),
    ('13', 2023, 'S', 515, 'MA', 'MON'),
    ('13', 2023, 'S', 515, 'MA', 'WED'),
    ('13', 2023, 'S', 515, 'MA', 'FRI'),
    -- Student 14
    ('14', 2023, 'S', 116, 'MA', 'MON'),
    ('14', 2023, 'S', 116, 'MA', 'WED'),
    ('14', 2023, 'S', 116, 'MA', 'FRI'),
    ('14', 2023, 'S', 216, 'EN', 'TUE'),
    ('14', 2023, 'S', 216, 'EN', 'THU'),
    ('14', 2023, 'S', 316, 'CS', 'MON'),
    ('14', 2023, 'S', 316, 'CS', 'WED'),
    ('14', 2023, 'S', 316, 'CS', 'FRI'),
    ('14', 2023, 'S', 416, 'CH', 'TUE'),
    ('14', 2023, 'S', 416, 'CH', 'THU'),
    ('14', 2023, 'S', 516, 'ME', 'MON'),
    ('14', 2023, 'S', 516, 'ME', 'WED'),
    ('14', 2023, 'S', 516, 'ME', 'FRI'),
    -- Student 15
    ('15', 2023, 'S', 117, 'CH', 'MON'),
    ('15', 2023, 'S', 117, 'CH', 'WED'),
    ('15', 2023, 'S', 117, 'CH', 'FRI'),
    ('15', 2023, 'S', 217, 'EN', 'TUE'),
    ('15', 2023, 'S', 217, 'EN', 'THU'),
    ('15', 2023, 'S', 317, 'MA', 'MON'),
    ('15', 2023, 'S', 317, 'MA', 'WED'),
    ('15', 2023, 'S', 317, 'MA', 'FRI'),
    ('15', 2023, 'S', 417, 'CS', 'TUE'),
    ('15', 2023, 'S', 417, 'CS', 'THU'),
    ('15', 2023, 'S', 517, 'ME', 'MON'),
    ('15', 2023, 'S', 517, 'ME', 'WED'),
    ('15', 2023, 'S', 517, 'ME', 'FRI'),
    -- Student 16
    ('16', 2023, 'S', 118, 'EN', 'MON'),
    ('16', 2023, 'S', 118, 'EN', 'WED'),
    ('16', 2023, 'S', 118, 'EN', 'FRI'),
    ('16', 2023, 'S', 218, 'MA', 'TUE'),
    ('16', 2023, 'S', 218, 'MA', 'THU'),
    ('16', 2023, 'S', 318, 'CS', 'MON'),
    ('16', 2023, 'S', 318, 'CS', 'WED'),
    ('16', 2023, 'S', 318, 'CS', 'FRI'),
    ('16', 2023, 'S', 418, 'ME', 'TUE'),
    ('16', 2023, 'S', 418, 'ME', 'THU'),
    ('16', 2023, 'S', 518, 'CH', 'MON'),
    ('16', 2023, 'S', 518, 'CH', 'WED'),
    ('16', 2023, 'S', 518, 'CH', 'FRI'),
    -- Student 17
    ('17', 2023, 'S', 119, 'CS', 'MON'),
    ('17', 2023, 'S', 119, 'CS', 'WED'),
    ('17', 2023, 'S', 119, 'CS', 'FRI'),
    ('17', 2023, 'S', 219, 'ME', 'TUE'),
    ('17', 2023, 'S', 219, 'ME', 'THU'),
    ('17', 2023, 'S', 319, 'EN', 'MON'),
    ('17', 2023, 'S', 319, 'EN', 'WED'),
    ('17', 2023, 'S', 319, 'EN', 'FRI'),
    ('17', 2023, 'S', 419, 'CH', 'TUE'),
    ('17', 2023, 'S', 419, 'CH', 'THU'),
    ('17', 2023, 'S', 519, 'MA', 'MON'),
    ('17', 2023, 'S', 519, 'MA', 'WED'),
    ('17', 2023, 'S', 519, 'MA', 'FRI'),
    -- Student 18
    ('18', 2023, 'S', 120, 'CS', 'MON'),
    ('18', 2023, 'S', 120, 'CS', 'WED'),
    ('18', 2023, 'S', 120, 'CS', 'FRI'),
    ('18', 2023, 'S', 220, 'ME', 'MON'),
    ('18', 2023, 'S', 220, 'ME', 'WED'),
    ('18', 2023, 'S', 220, 'ME', 'FRI'),
    ('18', 2023, 'S', 320, 'EN', 'MON'),
    ('18', 2023, 'S', 320, 'EN', 'WED'),
    ('18', 2023, 'S', 320, 'EN', 'FRI'),
    ('18', 2023, 'S', 420, 'CH', 'MON'),
    ('18', 2023, 'S', 420, 'CH', 'WED'),
    ('18', 2023, 'S', 420, 'CH', 'FRI'),
    ('18', 2023, 'S', 520, 'MA', 'MON'),
    ('18', 2023, 'S', 520, 'MA', 'WED'),
    ('18', 2023, 'S', 520, 'MA', 'FRI'),
    -- Student 19
    ('19', 2023, 'S', 121, 'EN', 'TUE'),
    ('19', 2023, 'S', 121, 'EN', 'THU'),
    ('19', 2023, 'S', 221, 'MA', 'MON'),
    ('19', 2023, 'S', 221, 'MA', 'WED'),
    ('19', 2023, 'S', 321, 'CS', 'TUE'),
    ('19', 2023, 'S', 321, 'CS', 'THU'),
    ('19', 2023, 'S', 421, 'CH', 'MON'),
    ('19', 2023, 'S', 421, 'CH', 'WED'),
    ('19', 2023, 'S', 521, 'ME', 'TUE'),
    ('19', 2023, 'S', 521, 'ME', 'THU'),
    -- Student 20
    ('20', 2023, 'S', 122, 'CS', 'MON'),
    ('20', 2023, 'S', 122, 'CS', 'WED'),
    ('20', 2023, 'S', 122, 'CS', 'FRI'),
    ('20', 2023, 'S', 222, 'ME', 'MON'),
    ('20', 2023, 'S', 222, 'ME', 'WED'),
    ('20', 2023, 'S', 222, 'ME', 'FRI'),
    ('20', 2023, 'S', 322, 'EN', 'MON'),
    ('20', 2023, 'S', 322, 'EN', 'WED'),
    ('20', 2023, 'S', 322, 'EN', 'FRI'),
    ('20', 2023, 'S', 422, 'CH', 'MON'),
    ('20', 2023, 'S', 422, 'CH', 'WED'),
    ('20', 2023, 'S', 422, 'CH', 'FRI'),
    ('20', 2023, 'S', 522, 'MA', 'MON'),
    ('20', 2023, 'S', 522, 'MA', 'WED'),
    ('20', 2023, 'S', 522, 'MA', 'FRI'),
    -- Student 21
    ('21', 2023, 'S', 123, 'EN', 'MON'),
    ('21', 2023, 'S', 123, 'EN', 'WED'),
    ('21', 2023, 'S', 123, 'EN', 'FRI'),
    ('21', 2023, 'S', 223, 'MA', 'TUE'),
    ('21', 2023, 'S', 223, 'MA', 'THU'),
    ('21', 2023, 'S', 323, 'CS', 'MON'),
    ('21', 2023, 'S', 323, 'CS', 'WED'),
    ('21', 2023, 'S', 423, 'ME', 'TUE'),
    ('21', 2023, 'S', 423, 'ME', 'THU'),
    ('21', 2023, 'S', 523, 'CH', 'MON'),
    ('21', 2023, 'S', 523, 'CH', 'WED'),
    -- Student 22
    ('22', 2023, 'S', 124, 'CS', 'MON'),
    ('22', 2023, 'S', 124, 'CS', 'WED'),
    ('22', 2023, 'S', 124, 'CS', 'FRI'),
    ('22', 2023, 'S', 224, 'EN', 'TUE'),
    ('22', 2023, 'S', 224, 'EN', 'THU'),
    ('22', 2023, 'S', 324, 'MA', 'MON'),
    ('22', 2023, 'S', 324, 'MA', 'WED'),
    ('22', 2023, 'S', 424, 'CH', 'TUE'),
    ('22', 2023, 'S', 424, 'CH', 'THU'),
    ('22', 2023, 'S', 524, 'ME', 'MON'),
    ('22', 2023, 'S', 524, 'ME', 'WED'),
    ('22', 2023, 'S', 524, 'ME', 'FRI'),
    -- Student 23
    ('23', 2023, 'S', 112, 'MA', 'MON'),
    ('23', 2023, 'S', 112, 'MA', 'WED'),
    ('23', 2023, 'S', 112, 'MA', 'FRI'),
    ('23', 2023, 'S', 212, 'EN', 'TUE'),
    ('23', 2023, 'S', 212, 'EN', 'THU'),
    ('23', 2023, 'S', 312, 'CS', 'MON'),
    ('23', 2023, 'S', 312, 'CS', 'WED'),
    ('23', 2023, 'S', 312, 'CS', 'FRI'),
    ('23', 2023, 'S', 412, 'CH', 'TUE'),
    ('23', 2023, 'S', 412, 'CH', 'THU'),
    ('23', 2023, 'S', 512, 'ME', 'MON'),
    ('23', 2023, 'S', 512, 'ME', 'WED'),
    -- Student 24
    ('24', 2023, 'S', 108, 'CH', 'MON'),
    ('24', 2023, 'S', 108, 'CH', 'WED'),
    ('24', 2023, 'S', 108, 'CH', 'FRI'),
    ('24', 2023, 'S', 208, 'EN', 'TUE'),
    ('24', 2023, 'S', 208, 'EN', 'THU'),
    ('24', 2023, 'S', 308, 'MA', 'MON'),
    ('24', 2023, 'S', 308, 'MA', 'WED'),
    ('24', 2023, 'S', 408, 'CS', 'TUE'),
    ('24', 2023, 'S', 408, 'CS', 'THU'),
    ('24', 2023, 'S', 508, 'ME', 'MON'),
    ('24', 2023, 'S', 508, 'ME', 'WED'),
    ('24', 2023, 'S', 508, 'ME', 'FRI'),
    -- Student 25
    ('25', 2023, 'S', 105, 'CS', 'MON'),
    ('25', 2023, 'S', 105, 'CS', 'WED'),
    ('25', 2023, 'S', 105, 'CS', 'FRI'),
    ('25', 2023, 'S', 205, 'ME', 'TUE'),
    ('25', 2023, 'S', 205, 'ME', 'THU'),
    ('25', 2023, 'S', 305, 'EN', 'MON'),
    ('25', 2023, 'S', 305, 'EN', 'WED'),
    ('25', 2023, 'S', 405, 'CH', 'TUE'),
    ('25', 2023, 'S', 405, 'CH', 'THU'),
    ('25', 2023, 'S', 505, 'MA', 'MON'),
    ('25', 2023, 'S', 505, 'MA', 'WED'),
    ('25', 2023, 'S', 505, 'MA', 'FRI'),
    ('25', 2023, 'S', 605, 'AE', 'MON'),
    ('25', 2023, 'S', 605, 'AE', 'WED'),
    ('25', 2023, 'S', 605, 'AE', 'FRI');
INSERT INTO "course_days" (
        "studentid",
        "year",
        "semester",
        "course_code",
        "department",
        "day"
    )
VALUES -- Student 5
    ('5', 2023, 'F', 111, 'CS', 'MON'),
    ('5', 2023, 'F', 111, 'CS', 'WED'),
    ('5', 2023, 'F', 111, 'CS', 'FRI'),
    ('5', 2023, 'F', 211, 'ME', 'TUE'),
    ('5', 2023, 'F', 211, 'ME', 'THU'),
    ('5', 2023, 'F', 311, 'EN', 'MON'),
    ('5', 2023, 'F', 311, 'EN', 'WED'),
    ('5', 2023, 'F', 311, 'EN', 'FRI'),
    ('5', 2023, 'F', 411, 'CH', 'TUE'),
    ('5', 2023, 'F', 411, 'CH', 'THU'),
    ('5', 2023, 'F', 511, 'MA', 'MON'),
    ('5', 2023, 'F', 511, 'MA', 'WED'),
    ('5', 2023, 'F', 511, 'MA', 'FRI'),
    -- Student 6
    ('6', 2023, 'F', 112, 'ME', 'MON'),
    ('6', 2023, 'F', 112, 'ME', 'WED'),
    ('6', 2023, 'F', 112, 'ME', 'FRI'),
    ('6', 2023, 'F', 212, 'MA', 'TUE'),
    ('6', 2023, 'F', 212, 'MA', 'THU'),
    ('6', 2023, 'F', 312, 'EN', 'MON'),
    ('6', 2023, 'F', 312, 'EN', 'WED'),
    ('6', 2023, 'F', 312, 'EN', 'FRI'),
    ('6', 2023, 'F', 412, 'CS', 'TUE'),
    ('6', 2023, 'F', 412, 'CS', 'THU'),
    ('6', 2023, 'F', 512, 'CH', 'MON'),
    ('6', 2023, 'F', 512, 'CH', 'WED'),
    ('6', 2023, 'F', 512, 'CH', 'FRI'),
    -- Student 7
    ('7', 2023, 'F', 113, 'CS', 'MON'),
    ('7', 2023, 'F', 113, 'CS', 'WED'),
    ('7', 2023, 'F', 113, 'CS', 'FRI'),
    ('7', 2023, 'F', 213, 'EN', 'TUE'),
    ('7', 2023, 'F', 213, 'EN', 'THU'),
    ('7', 2023, 'F', 313, 'MA', 'MON'),
    ('7', 2023, 'F', 313, 'MA', 'WED'),
    ('7', 2023, 'F', 313, 'MA', 'FRI'),
    ('7', 2023, 'F', 413, 'ME', 'TUE'),
    ('7', 2023, 'F', 413, 'ME', 'THU'),
    -- Student 8
    ('8', 2023, 'F', 114, 'AE', 'MON'),
    ('8', 2023, 'F', 114, 'AE', 'WED'),
    ('8', 2023, 'F', 114, 'AE', 'FRI'),
    ('8', 2023, 'F', 214, 'CH', 'TUE'),
    ('8', 2023, 'F', 214, 'CH', 'THU'),
    ('8', 2023, 'F', 314, 'EN', 'MON'),
    ('8', 2023, 'F', 314, 'EN', 'WED'),
    ('8', 2023, 'F', 314, 'EN', 'FRI'),
    ('8', 2023, 'F', 414, 'CS', 'TUE'),
    ('8', 2023, 'F', 414, 'CS', 'THU'),
    ('8', 2023, 'F', 514, 'ME', 'MON'),
    ('8', 2023, 'F', 514, 'ME', 'WED'),
    ('8', 2023, 'F', 514, 'ME', 'FRI'),
    -- Student 9
    ('9', 2023, 'F', 116, 'EN', 'MON'),
    ('9', 2023, 'F', 116, 'EN', 'WED'),
    ('9', 2023, 'F', 116, 'EN', 'FRI'),
    ('9', 2023, 'F', 216, 'MA', 'MON'),
    ('9', 2023, 'F', 216, 'MA', 'WED'),
    ('9', 2023, 'F', 216, 'MA', 'FRI'),
    ('9', 2023, 'F', 316, 'CS', 'MON'),
    ('9', 2023, 'F', 316, 'CS', 'WED'),
    ('9', 2023, 'F', 316, 'CS', 'FRI'),
    ('9', 2023, 'F', 416, 'ME', 'MON'),
    ('9', 2023, 'F', 416, 'ME', 'WED'),
    ('9', 2023, 'F', 416, 'ME', 'FRI'),
    -- Student 10
    ('10', 2023, 'F', 117, 'CH', 'TUE'),
    ('10', 2023, 'F', 117, 'CH', 'THU'),
    ('10', 2023, 'F', 217, 'EN', 'MON'),
    ('10', 2023, 'F', 217, 'EN', 'WED'),
    ('10', 2023, 'F', 217, 'EN', 'FRI'),
    ('10', 2023, 'F', 317, 'MA', 'TUE'),
    ('10', 2023, 'F', 317, 'MA', 'THU'),
    ('10', 2023, 'F', 417, 'CS', 'MON'),
    ('10', 2023, 'F', 417, 'CS', 'WED'),
    ('10', 2023, 'F', 417, 'CS', 'FRI'),
    ('10', 2023, 'F', 517, 'ME', 'TUE'),
    ('10', 2023, 'F', 517, 'ME', 'THU'),
    -- Student 11
    ('11', 2023, 'F', 118, 'CS', 'MON'),
    ('11', 2023, 'F', 118, 'CS', 'WED'),
    ('11', 2023, 'F', 118, 'CS', 'FRI'),
    ('11', 2023, 'F', 218, 'EN', 'TUE'),
    ('11', 2023, 'F', 218, 'EN', 'THU'),
    ('11', 2023, 'F', 318, 'MA', 'MON'),
    ('11', 2023, 'F', 318, 'MA', 'WED'),
    ('11', 2023, 'F', 318, 'MA', 'FRI'),
    ('11', 2023, 'F', 418, 'ME', 'TUE'),
    ('11', 2023, 'F', 418, 'ME', 'THU'),
    ('11', 2023, 'F', 518, 'CH', 'MON'),
    ('11', 2023, 'F', 518, 'CH', 'WED'),
    ('11', 2023, 'F', 518, 'CH', 'FRI'),
    -- Student 12
    ('12', 2023, 'F', 119, 'EN', 'MON'),
    ('12', 2023, 'F', 119, 'EN', 'WED'),
    ('12', 2023, 'F', 119, 'EN', 'FRI'),
    ('12', 2023, 'F', 219, 'MA', 'TUE'),
    ('12', 2023, 'F', 219, 'MA', 'THU'),
    ('12', 2023, 'F', 319, 'CS', 'MON'),
    ('12', 2023, 'F', 319, 'CS', 'WED'),
    ('12', 2023, 'F', 319, 'CS', 'FRI'),
    ('12', 2023, 'F', 419, 'CH', 'TUE'),
    ('12', 2023, 'F', 419, 'CH', 'THU'),
    ('12', 2023, 'F', 519, 'ME', 'MON'),
    ('12', 2023, 'F', 519, 'ME', 'WED'),
    ('12', 2023, 'F', 519, 'ME', 'FRI'),
    -- Student 13
    ('13', 2023, 'F', 120, 'CS', 'MON'),
    ('13', 2023, 'F', 120, 'CS', 'WED'),
    ('13', 2023, 'F', 120, 'CS', 'FRI'),
    ('13', 2023, 'F', 220, 'ME', 'TUE'),
    ('13', 2023, 'F', 220, 'ME', 'THU'),
    ('13', 2023, 'F', 320, 'EN', 'MON'),
    ('13', 2023, 'F', 320, 'EN', 'WED'),
    ('13', 2023, 'F', 320, 'EN', 'FRI'),
    ('13', 2023, 'F', 420, 'CH', 'TUE'),
    ('13', 2023, 'F', 420, 'CH', 'THU'),
    ('13', 2023, 'F', 520, 'MA', 'MON'),
    ('13', 2023, 'F', 520, 'MA', 'WED'),
    ('13', 2023, 'F', 520, 'MA', 'FRI'),
    -- Student 14
    ('14', 2023, 'F', 121, 'MA', 'MON'),
    ('14', 2023, 'F', 121, 'MA', 'WED'),
    ('14', 2023, 'F', 121, 'MA', 'FRI'),
    ('14', 2023, 'F', 221, 'EN', 'TUE'),
    ('14', 2023, 'F', 221, 'EN', 'THU'),
    ('14', 2023, 'F', 321, 'CS', 'MON'),
    ('14', 2023, 'F', 321, 'CS', 'WED'),
    ('14', 2023, 'F', 321, 'CS', 'FRI'),
    ('14', 2023, 'F', 421, 'CH', 'TUE'),
    ('14', 2023, 'F', 421, 'CH', 'THU'),
    ('14', 2023, 'F', 521, 'ME', 'MON'),
    ('14', 2023, 'F', 521, 'ME', 'WED'),
    ('14', 2023, 'F', 521, 'ME', 'FRI'),
    -- Student 15
    ('15', 2023, 'F', 122, 'CH', 'MON'),
    ('15', 2023, 'F', 122, 'CH', 'WED'),
    ('15', 2023, 'F', 122, 'CH', 'FRI'),
    ('15', 2023, 'F', 222, 'EN', 'TUE'),
    ('15', 2023, 'F', 222, 'EN', 'THU'),
    ('15', 2023, 'F', 322, 'MA', 'MON'),
    ('15', 2023, 'F', 322, 'MA', 'WED'),
    ('15', 2023, 'F', 322, 'MA', 'FRI'),
    ('15', 2023, 'F', 422, 'CS', 'TUE'),
    ('15', 2023, 'F', 422, 'CS', 'THU'),
    ('15', 2023, 'F', 522, 'ME', 'MON'),
    ('15', 2023, 'F', 522, 'ME', 'WED'),
    ('15', 2023, 'F', 522, 'ME', 'FRI'),
    -- Student 16
    ('16', 2023, 'F', 123, 'EN', 'MON'),
    ('16', 2023, 'F', 123, 'EN', 'WED'),
    ('16', 2023, 'F', 123, 'EN', 'FRI'),
    ('16', 2023, 'F', 223, 'MA', 'TUE'),
    ('16', 2023, 'F', 223, 'MA', 'THU'),
    ('16', 2023, 'F', 323, 'CS', 'MON'),
    ('16', 2023, 'F', 323, 'CS', 'WED'),
    ('16', 2023, 'F', 323, 'CS', 'FRI'),
    ('16', 2023, 'F', 423, 'ME', 'TUE'),
    ('16', 2023, 'F', 423, 'ME', 'THU'),
    ('16', 2023, 'F', 523, 'CH', 'MON'),
    ('16', 2023, 'F', 523, 'CH', 'WED'),
    ('16', 2023, 'F', 523, 'CH', 'FRI'),
    -- Student 17
    ('17', 2023, 'F', 124, 'CS', 'MON'),
    ('17', 2023, 'F', 124, 'CS', 'WED'),
    ('17', 2023, 'F', 124, 'CS', 'FRI'),
    ('17', 2023, 'F', 224, 'EN', 'TUE'),
    ('17', 2023, 'F', 224, 'EN', 'THU'),
    ('17', 2023, 'F', 324, 'MA', 'MON'),
    ('17', 2023, 'F', 324, 'MA', 'WED'),
    ('17', 2023, 'F', 324, 'MA', 'FRI'),
    ('17', 2023, 'F', 424, 'CH', 'TUE'),
    ('17', 2023, 'F', 424, 'CH', 'THU'),
    ('17', 2023, 'F', 524, 'ME', 'MON'),
    ('17', 2023, 'F', 524, 'ME', 'WED'),
    ('17', 2023, 'F', 524, 'ME', 'FRI'),
    -- Student 18
    ('18', 2023, 'F', 125, 'CS', 'MON'),
    ('18', 2023, 'F', 125, 'CS', 'WED'),
    ('18', 2023, 'F', 125, 'CS', 'FRI'),
    ('18', 2023, 'F', 225, 'ME', 'TUE'),
    ('18', 2023, 'F', 225, 'ME', 'THU'),
    ('18', 2023, 'F', 325, 'EN', 'MON'),
    ('18', 2023, 'F', 325, 'EN', 'WED'),
    ('18', 2023, 'F', 325, 'EN', 'FRI'),
    ('18', 2023, 'F', 425, 'CH', 'TUE'),
    ('18', 2023, 'F', 425, 'CH', 'THU'),
    ('18', 2023, 'F', 525, 'MA', 'MON'),
    ('18', 2023, 'F', 525, 'MA', 'WED'),
    ('18', 2023, 'F', 525, 'MA', 'FRI'),
    -- Student 19
    ('19', 2023, 'F', 126, 'EN', 'MON'),
    ('19', 2023, 'F', 126, 'EN', 'WED'),
    ('19', 2023, 'F', 126, 'EN', 'FRI'),
    ('19', 2023, 'F', 226, 'MA', 'TUE'),
    ('19', 2023, 'F', 226, 'MA', 'THU'),
    ('19', 2023, 'F', 326, 'CS', 'MON'),
    ('19', 2023, 'F', 326, 'CS', 'WED'),
    ('19', 2023, 'F', 326, 'CS', 'FRI'),
    ('19', 2023, 'F', 426, 'CH', 'TUE'),
    ('19', 2023, 'F', 426, 'CH', 'THU'),
    ('19', 2023, 'F', 526, 'ME', 'MON'),
    ('19', 2023, 'F', 526, 'ME', 'WED'),
    ('19', 2023, 'F', 526, 'ME', 'FRI'),
    -- Student 20
    ('20', 2023, 'F', 127, 'CS', 'MON'),
    ('20', 2023, 'F', 127, 'CS', 'WED'),
    ('20', 2023, 'F', 127, 'CS', 'FRI'),
    ('20', 2023, 'F', 227, 'ME', 'TUE'),
    ('20', 2023, 'F', 227, 'ME', 'THU'),
    ('20', 2023, 'F', 327, 'EN', 'MON'),
    ('20', 2023, 'F', 327, 'EN', 'WED'),
    ('20', 2023, 'F', 327, 'EN', 'FRI'),
    ('20', 2023, 'F', 427, 'CH', 'TUE'),
    ('20', 2023, 'F', 427, 'CH', 'THU'),
    ('20', 2023, 'F', 527, 'MA', 'MON'),
    ('20', 2023, 'F', 527, 'MA', 'WED'),
    ('20', 2023, 'F', 527, 'MA', 'FRI'),
    -- Student 21
    ('21', 2023, 'F', 121, 'EN', 'MON'),
    ('21', 2023, 'F', 121, 'EN', 'WED'),
    ('21', 2023, 'F', 121, 'EN', 'FRI'),
    ('21', 2023, 'F', 221, 'MA', 'MON'),
    ('21', 2023, 'F', 221, 'MA', 'WED'),
    ('21', 2023, 'F', 221, 'MA', 'FRI'),
    ('21', 2023, 'F', 321, 'CS', 'MON'),
    ('21', 2023, 'F', 321, 'CS', 'WED'),
    ('21', 2023, 'F', 321, 'CS', 'FRI'),
    ('21', 2023, 'F', 421, 'ME', 'MON'),
    ('21', 2023, 'F', 421, 'ME', 'WED'),
    ('21', 2023, 'F', 421, 'ME', 'FRI'),
    ('21', 2023, 'F', 521, 'CH', 'MON'),
    ('21', 2023, 'F', 521, 'CH', 'WED'),
    ('21', 2023, 'F', 521, 'CH', 'FRI'),
    -- Student 22
    ('22', 2023, 'F', 122, 'CS', 'MON'),
    ('22', 2023, 'F', 122, 'CS', 'WED'),
    ('22', 2023, 'F', 122, 'CS', 'FRI'),
    ('22', 2023, 'F', 222, 'ME', 'TUE'),
    ('22', 2023, 'F', 222, 'ME', 'THU'),
    ('22', 2023, 'F', 322, 'EN', 'MON'),
    ('22', 2023, 'F', 322, 'EN', 'WED'),
    ('22', 2023, 'F', 322, 'EN', 'FRI'),
    ('22', 2023, 'F', 422, 'CH', 'TUE'),
    ('22', 2023, 'F', 422, 'CH', 'THU'),
    ('22', 2023, 'F', 522, 'MA', 'MON'),
    ('22', 2023, 'F', 522, 'MA', 'WED'),
    ('22', 2023, 'F', 522, 'MA', 'FRI'),
    -- Student 23
    ('23', 2023, 'F', 123, 'EN', 'MON'),
    ('23', 2023, 'F', 123, 'EN', 'WED'),
    ('23', 2023, 'F', 123, 'EN', 'FRI'),
    ('23', 2023, 'F', 223, 'MA', 'TUE'),
    ('23', 2023, 'F', 223, 'MA', 'THU'),
    ('23', 2023, 'F', 323, 'CS', 'MON'),
    ('23', 2023, 'F', 323, 'CS', 'WED'),
    ('23', 2023, 'F', 323, 'CS', 'FRI'),
    ('23', 2023, 'F', 423, 'ME', 'TUE'),
    ('23', 2023, 'F', 423, 'ME', 'THU'),
    ('23', 2023, 'F', 523, 'CH', 'MON'),
    ('23', 2023, 'F', 523, 'CH', 'WED'),
    ('23', 2023, 'F', 523, 'CH', 'FRI'),
    -- Student 24
    ('24', 2023, 'F', 124, 'CS', 'MON'),
    ('24', 2023, 'F', 124, 'CS', 'WED'),
    ('24', 2023, 'F', 124, 'CS', 'FRI'),
    ('24', 2023, 'F', 224, 'EN', 'TUE'),
    ('24', 2023, 'F', 224, 'EN', 'THU'),
    ('24', 2023, 'F', 324, 'MA', 'MON'),
    ('24', 2023, 'F', 324, 'MA', 'WED'),
    ('24', 2023, 'F', 324, 'MA', 'FRI'),
    ('24', 2023, 'F', 424, 'CH', 'TUE'),
    ('24', 2023, 'F', 424, 'CH', 'THU'),
    ('24', 2023, 'F', 524, 'ME', 'MON'),
    ('24', 2023, 'F', 524, 'ME', 'WED'),
    ('24', 2023, 'F', 524, 'ME', 'FRI'),
    -- Student 25
    ('25', 2023, 'F', 105, 'CS', 'MON'),
    ('25', 2023, 'F', 105, 'CS', 'WED'),
    ('25', 2023, 'F', 105, 'CS', 'FRI'),
    ('25', 2023, 'F', 205, 'ME', 'TUE'),
    ('25', 2023, 'F', 205, 'ME', 'THU'),
    ('25', 2023, 'F', 305, 'EN', 'MON'),
    ('25', 2023, 'F', 305, 'EN', 'WED'),
    ('25', 2023, 'F', 305, 'EN', 'FRI'),
    ('25', 2023, 'F', 405, 'CH', 'TUE'),
    ('25', 2023, 'F', 405, 'CH', 'THU'),
    ('25', 2023, 'F', 505, 'MA', 'MON'),
    ('25', 2023, 'F', 505, 'MA', 'WED'),
    ('25', 2023, 'F', 505, 'MA', 'FRI'),
    ('25', 2023, 'F', 605, 'AE', 'TUE'),
    ('25', 2023, 'F', 605, 'AE', 'THU');