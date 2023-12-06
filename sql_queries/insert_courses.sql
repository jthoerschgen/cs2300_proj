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