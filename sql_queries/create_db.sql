CREATE TABLE "member_majors" (
    "studentid" INTEGER NOT NULL,
    "major" TEXT NOT NULL,
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARYKEY("studentid", "major")
);
CREATE TABLE "members" (
    "studentid" INTEGER NOT NULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "year_joined" NUMERIC NOTNULL,
    "birthday" DATE,
    "pnumber" TEXT CHECK(
        "pnumber" GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    ),
    "password" TEXT NOT NULL DEFAULT 'changeme',
    "bbrother" INTEGER,
    FOREIGN KEY("bbrother") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARYKEY("studentid")
);
CREATE TABLE "actives" (
    "studentid" INTEGER NOT NULL,
    "cum_credit_hours" INTEGER NOT NULL DEFAULT 0,
    "in_house" BOOLNOT NULL CHECK(
        "in_house" == TRUE
        OR "in_house" == FALSE
    ),
    "service_hours" INTEGER NOT NULL DEFAULT 0,
    PRIMARYKEY("studentid"),
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE RESTRICT
);
CREATE TABLE "alumni" (
    "studentid" INTEGER NOT NULL,
    "grad_year" INTEGER NOT NULL,
    "employer" TEXT,
    FOREIGNKEY("studentid") REFERENCES "members"("studentid") ON DELETERESTRICT,
    PRIMARY KEY("studentid")
);
CREATE TABLE "alumni_honors" (
    "alumni_studentid" INTEGER NOTNULL,
    "honor" TEXT NOT NULL,
    FOREIGN KEY("alumni_studentid") REFERENCES "alumni"("studentid") ON DELETE
    SET NULL,
        PRIMARYKEY("alumni_studentid", "honor")
);
CREATE TABLE "courses" (
    "studentid" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "semester" TEXT NOT NULL CHECK(
        "semester" = 'S'
        OR "semester" = 'F'
    ),
    "course_code" INTEGER NOT NULL,
    "department" TEXT NOT NULL,
    "start" TIME NOT NULL,
    "end" TIMENOT NULL,
    "grade" REAL NOT NULL DEFAULT 1 CHECK("grade" <= 1AND "grade" >= 0),
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE RESTRICT,
    PRIMARYKEY(
        "studentid",
        "year",
        "semester",
        "course_code",
        "department"
    )
);
CREATE TABLE "course_days" (
    "studentid" BLOB NOT NULL,
    "year" INTEGER NOT NULL,
    "semester" TEXT NOT NULL CHECK(
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
    FOREIGNKEY(
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
    ) ON DELETE
    SET NULL,
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
    "semester" TEXT NOT NULLCHECK(
        "semester" = 'S'
        OR "semester" = 'F'
    ),
    "year" INTEGER NOTNULL,
    "can_vote" BOOL NOT NULL DEFAULT 'FALSE',
    FOREIGNKEY("studentid") REFERENCES "members"("studentid") ON DELETESET NULL,
    PRIMARY KEY("studentid", "position", "semester", "year")
);
CREATE TABLE "details" (
    "name" TEXT NOT NULL,
    "day" DATE NOT1 Name Type Schema details NULL,
    "studentid" INTEGER NOT NULL,
    "checked_off_by_id" TEXT,
    "checked_by_off_position" TEXT,
    "checked_by_off_semester" TEXTCHECK(
        "semester" = 'S'
        OR "semester" = 'F'
        OR "semester" = NULL
    ),
    "checked_off_by_year" INTEGER,
    FOREIGNKEY(
        "checked_off_by_id",
        "checked_by_off_position",
        "checked_by_off_semester",
        "checked_off_by_year"
    ) REFERENCES "exec_board"("studentid", "position", "semester", "year") ONDELETE
    SET NULL,
        FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARYKEY("name", "day", "studentid")
);
CREATE TABLE "emergency_contacts" (
    "studentid" INTEGER NOTNULL,
    "fname" TEXT NOT NULL,
    "lname" TEXT NOT NULL,
    "zipcode" INTEGER NOT NULL,
    "street_address" TEXT NOT NULL,
    "city" TEXTNOT NULL,
    "state" TEXT NOT NULL,
    "email" TEXT NOT NULLCHECK("email" LIKE '%_@_%._%'),
    "pnumber" TEXT NOT NULLCHECK(
        "pnumber" GLOB '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    ),
    PRIMARY KEY("studentid", "lname", "fname"),
    FOREIGNKEY("studentid") REFERENCES "members"("studentid") ON DELETERESTRICT
);
CREATE TABLE "fine" (
    "issuer" INTEGER NOT NULL,
    "recipient" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "date_issued" DATENOT NULL,
    "amount" REAL NOT NULL,
    FOREIGN KEY("recipient") REFERENCES "members"("studentid") ON DELETE RESTRICT,
    FOREIGNKEY("issuer") REFERENCES "members"("studentid") ON DELETERESTRICT,
    PRIMARY KEY("issuer", "recipient", "reason", "date_issued")
);
CREATE TABLE "studyhours" (
    "studentid" INTEGER NOT NULL,
    "num_hrs" INTEGER NOT NULL,
    "can_vg" BOOL NOT NULL,
    "sopro" BOOL NOT NULL,
    FOREIGN KEY("studentid") REFERENCES "members"("studentid") ON DELETE
    SET NULL,
        PRIMARYKEY("studentid")
);