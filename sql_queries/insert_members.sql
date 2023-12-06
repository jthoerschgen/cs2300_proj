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
        cum_credit_hours,
        in_house,
        service_hours
    )
VALUES (5, 30, 1, 10),
    (6, 25, 0, 15),
    (7, 35, 1, 8),
    (8, 28, 1, 20),
    (9, 32, 0, 18),
    (10, 27, 1, 22),
    (11, 40, 1, 14),
    (12, 22, 0, 25),
    (13, 38, 1, 16),
    (14, 29, 0, 12),
    (15, 33, 1, 19),
    (16, 26, 0, 23),
    (17, 36, 1, 17),
    (18, 31, 1, 21),
    (19, 24, 0, 13),
    (20, 37, 1, 11),
    (21, 30, 0, 24),
    (22, 34, 1, 18),
    (23, 28, 0, 16),
    (24, 39, 1, 20),
    (25, 40, 1, 12);
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