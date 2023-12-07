import sqlite3
from datetime import date, time

import pandas as pd
from constants import CURRENT_SEMESTER, CURRENT_YEAR, DB_PATH


class DBFuncError(Exception):
    def __init__(
        self,
        message: str | None = None,
    ):
        self.message = message
        super().__init__(message)


def CreateConn() -> sqlite3.Connection:
    """Standarize Connection cration

    Returns:
        sqlite3.Connection: SQL database connection
    """
    conn: sqlite3.Connection = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("PRAGMA foreign_keys = ON")
    conn.commit()
    return conn


def AddMember(
    first_name: str,
    last_name: str,
    year_joined: int,
    birthday: date,
    phone_number: int,
    password: str,
    big_brother_id: int,
    studentid: int | None = None,
    conn: sqlite3.Connection | None = None,
):
    """
    Adds a new user to the database. It is implemented through both server-side Python
    and SQL code and an HTML form for user input.

    Args:
        first_name (str): The first name of the member to add.
        last_name (str): The last name of the member to add.
        year_joined (int): The year that the member to add joined.
        birthday (date): The birthday of the member to add.
        phone_number (int): The phone number of the member to add.
        password (str): Password for the new members account.
        big_brother_id (int): The ID of the new members "big brother".
        studentid (int | None, optional):
            The student ID of the new member. Defaults to None.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()
        if studentid is None:
            studentid = (
                cur.execute(
                    """
SELECT MAX(studentid) FROM members
                            """
                ).fetchone()[0]
                + 1
            )

        cur.execute(
            """
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
VALUES (?,?,?,?,?,?,?,?);
            """,
            (
                studentid,
                first_name,
                last_name,
                year_joined,
                birthday,
                phone_number,
                password,
                big_brother_id,
            ),
        )
        conn.commit()
        # add member to actives
        cur.execute(
            """
INSERT INTO actives (
    studentid,
    in_house,
    service_hours
)
VALUES (?,?,?);
            """,
            (studentid, 1, 0),
        )
        conn.commit()
    return


def DeleteMember(
    studentid: int,
    conn: sqlite3.Connection | None = None,
):
    """Deletes a member based on the StudentID given

    Args:
        studentid (int): The StudentID of the member to be deleted
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()
        cur.execute(
            """
DELETE FROM members
WHERE members.studentid=?
            """,
            (studentid,),
        )
        conn.commit()
    return


def GenWeeklySchedule(
    studentid: int,
    semester: str,
    year: int,
    conn: sqlite3.Connection | None = None,
) -> str:
    """
    Generate a weekly schedule for a student based on the classes associated with that
    studentID

    Args:
        studentid (int): The StudentID of the student for whom the schedule is generated.
        semester (str): The semester for which the schedule is generated.
        year (int): The year for which the schedule is generated.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        str: An HTML representation of the weekly schedule.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT
    courses.department,
    courses.course_code,
    courses.start,
    courses.end,
    course_days.day
FROM courses
JOIN course_days
    ON
        courses.studentid = course_days.studentid AND
        courses.year = course_days.year AND
        courses.semester = course_days.semester AND
        courses.department = course_days.department AND
        courses.course_code = course_days.course_code
WHERE
    courses.studentid = ? AND
    courses.year = ? AND
    courses.semester = ?
ORDER BY
    CASE
        WHEN course_days.day = 'SUN' THEN 1
        WHEN course_days.day = 'MON' THEN 2
        WHEN course_days.day = 'TUE' THEN 3
        WHEN course_days.day = 'WED' THEN 4
        WHEN course_days.day = 'THU' THEN 5
        WHEN course_days.day = 'FRI' THEN 6
        WHEN course_days.day = 'SAT' THEN 7
    ELSE 8
    END,
    courses.start;
            """,
            (
                studentid,
                year,
                semester,
            ),
        )
        conn.commit()
        df = pd.DataFrame.from_records(
            data=res.fetchall(), columns=[column[0] for column in res.description]
        )
        pd.set_option("display.max_columns", None)
        print(df)
        return df.to_html(index=False)


def GetAllMembers(
    conn: sqlite3.Connection | None = None,
) -> str:
    """
    Retrieve information for all members.

    Args:
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        str: An HTML representation of member information, including StudentID,
        first name, last name, year joined, and active status.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT
    members.studentid,
    members.fname,
    members.lname,
    members.year_joined,
    (actives.studentid IS NOT NULL) AS is_active
FROM members
LEFT JOIN actives
    ON members.studentid = actives.studentid;
            """,
            (),
        )
        conn.commit()
        df = pd.DataFrame.from_records(
            data=res.fetchall(), columns=[column[0] for column in res.description]
        )
        pd.set_option("display.max_columns", None)
        print(df)
        return df.to_html(index=False)


def LoginExec(
    studentid: int,
    password: str,
    conn: sqlite3.Connection | None = None,
) -> tuple[bool, dict]:
    """
    Authenticate an executive board member's login credentials.
    This function checks if the provided StudentID, password, semester, and year match
    an executive board member's entry in the database. If the credentials are valid, the
    function returns a tuple with a boolean indicating successful login and a dictionary
    containing executive board information such as StudentID, position, semester, and
    year.

    Args:
        studentid (int): The StudentID of the executive board member.
        password (str):
            The password associated with the executive board member's account.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        tuple[bool, dict]: A tuple containing a boolean indicating the login success and
        a dictionary with executive board information if successful.
    """

    if not conn:
        conn = CreateConn()

    with conn:
        cur = conn.cursor()
        cur.execute(
            """
SELECT
    exec_board.studentid,
    exec_board.position,
    exec_board.semester,
    exec_board.year,
    members.password
FROM exec_board
JOIN members
    ON exec_board.studentid = members.studentid
WHERE
    exec_board.studentid = ? AND
    semester = ? AND
    year = ? AND
    members.password = ?;
            """,
            (studentid, CURRENT_SEMESTER, CURRENT_YEAR, password),
        )
        conn.commit()
        login_info = cur.fetchone()
        exec_dict: dict = {
            "studentid": login_info[0],
            "position": login_info[1],
            "semester": login_info[2],
            "year": login_info[3],
        }
        return (True if login_info else False, exec_dict)


def CheckOffDetail(
    exec_id: int,
    exec_password: str,
    detail_name: str,
    detail_date: date,
    conn: sqlite3.Connection | None = None,
):
    """
    Update details to mark a task as checked off by an executive.

    This function verifies the login credentials of an executive board member using the
    provided `exec_id` and `exec_password`. If the login is successful, it updates the
    details of a task named `detail_name` on the specified `detail_date`, marking it as
    checked off by the executive.

    Args:
        exec_id (int): The StudentID of the executive board member.
        exec_password (str):
            The password associated with the executive board member's account.
        detail_name (str): The name of the task to be marked as checked off.
        detail_date (date): The date of the task to be marked as checked off.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        login_success, login_info = LoginExec(
            studentid=exec_id, password=exec_password, conn=conn
        )
        if login_success:
            cur = conn.cursor()
            cur.execute(
                """
    UPDATE details
    SET
        checked_off_by_id = ?,
        checked_by_off_position = ?,
        checked_by_off_semester = ?,
        checked_off_by_year = ?
    WHERE
        name = ? AND
        day = ?;
                """,
                (
                    login_info["studentid"],
                    login_info["position"],
                    login_info["semester"],
                    login_info["year"],
                    detail_name,
                    detail_date,
                ),
            )
            conn.commit()
    return


def AddToDetail(
    student_id: int,
    detail_name: str,
    detail_date: date,
    conn: sqlite3.Connection | None = None,
):
    """_summary_

    Args:
        student_id (int): _description_
        detail_name (str): _description_
        detail_date (date): _description_
        conn (sqlite3.Connection | None, optional): _description_. Defaults to None.
    """
    if not conn:
        conn = CreateConn()

    with conn:
        cur = conn.cursor()
        cur.execute(
            """
INSERT INTO details ('name', 'day', 'studentid')
VALUES (?, ?, ?);
            """,
            (
                detail_name,
                detail_date,
                student_id,
            ),
        )
        conn.commit()
    return


def GetDetails(
    start_date: date,
    end_date: date,
    conn: sqlite3.Connection | None = None,
) -> bool:
    """
    Retrieve house chore details within a specified date range.

    This function queries the database for details of house chores (referred to as
    "details") that fall within the date range defined by `start_date` and
    `end_date`. It returns a boolean indicating whether there are house chores within
    the specified date range.

    Args:
        start_date (date): The start date of the desired date range.
        end_date (date): The end date of the desired date range.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        bool: An HTML representation of house chore details if chores are found within
        the specified date range, otherwise an empty string.
    """
    if not conn:
        conn = CreateConn()

    with conn:
        cur = conn.cursor()
        print((start_date, end_date))
        res = cur.execute(
            """
SELECT
    details.name,
    details.day,
    members.fname,
    members.lname,
    details.studentid,
    CASE
        WHEN details.checked_off_by_id IS NOT NULL AND
            details.checked_by_off_position IS NOT NULL AND
            details.checked_by_off_semester IS NOT NULL AND
            details.checked_off_by_year IS NOT NULL
        THEN 'TRUE'
        ELSE 'FALSE'
    END AS checked_off
FROM details
JOIN members
    ON details.studentid = members.studentid
WHERE
    details.day >= ? AND
    details.day <= ?;
            """,
            (start_date, end_date),
        )
        conn.commit()
        df = pd.DataFrame.from_records(
            data=res.fetchall(), columns=[column[0] for column in res.description]
        )
        pd.set_option("display.max_columns", None)
        print(df)
        return df.to_html(index=False)


def GetAllDepartments(
    conn: sqlite3.Connection | None = None,
) -> list[str]:
    """
    Retrieve a list of all unique departments from the database.

    This function queries the database for distinct department names from the 'courses'
    table and returns a list containing these department names.

    Args:
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Returns:
        list[str]: A list of unique department names.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT DISTINCT courses.department
FROM courses;
            """,
            (),
        )
        conn.commit()
        return [row[0] for row in res.fetchall()]


def InsertCourse(
    student_id: int,
    year: int,
    semester: str,
    course_code: int,
    department: str,
    start_time: time,
    end_time: time,
    days: list[str],
    conn: sqlite3.Connection | None = None,
):
    """
    Insert a new course record into the database.

    This function inserts a new course record into the 'courses' table and corresponding
    entries in the 'course_days' table. The course details include student ID, academic
    year, semester, course code, department, start time, and end time. The course days
    specify the days of the week the course meets.

    Args:
        student_id (int): The StudentID associated with the course.
        year (int): The academic year of the course.
        semester (str): The semester of the course (e.g., 'Fall', 'Spring').
        course_code (int): The unique code identifying the course.
        department (str): The department offering the course.
        start_time (time): The start time of the course.
        end_time (time): The end time of the course.
        days (list[str]):
            A list of days on which the course meets (e.g., ['MON', 'WED', 'FRI']).
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.

    Return:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        cur.execute(
            """
INSERT INTO courses (
    studentid,
    year,
    semester,
    course_code,
    department,
    start,
    end
)
VALUES (?, ?, ?, ?, ?, ?, ?);
            """,
            (
                student_id,
                year,
                semester,
                course_code,
                department,
                start_time.strftime("%H:%M:%S"),
                end_time.strftime("%H:%M:%S"),
            ),
        )
        conn.commit()

        for day in days:
            cur.execute(
                """
INSERT INTO course_days (
    studentid,
    year,
    semester,
    course_code,
    department,
    day
)
VALUES (?, ?, ?, ?, ?, ?);
                """,
                (student_id, year, semester, course_code, department, day),
            )
        conn.commit()
    return


def GetExec(
    semester: str,
    year: int,
    conn: sqlite3.Connection | None = None,
):
    """Gets the exec board for a semester and year combination

    Args:
        semester (str): The selected semester
        year (int): The selected year
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT
    exec_board.studentid AS 'Student ID',
    members.fname AS 'First Name',
    members.lname AS 'Last Name',
    exec_board.position AS 'Position',
    exec_board.can_vote AS 'Voting'
FROM exec_board
JOIN members
    ON exec_board.studentid = members.studentid
WHERE
    exec_board.semester = ? AND
    exec_board.year = ?
            """,
            (semester, year),
        )
        conn.commit()
        df = pd.DataFrame.from_records(
            data=res.fetchall(), columns=[column[0] for column in res.description]
        )
        pd.set_option("display.max_columns", None)
        print(df)
        return df.to_html(index=False)


def CheckIsInExec(
    studentid: int,
    position: str,
    semester: str,
    year: str,
    conn: sqlite3.Connection | None = None,
):
    """
    Checks if a student with a specific position, in a given semester and year,
    is a part of the executive board.

    Args:
        studentid (int): The unique identifier of the student.
        position (str): The position held by the student on the executive board.
        semester (str): The semester during which the position is held (e.g., 'Fall', 'Spring').
        year (str): The academic year in which the position is held (e.g., '2022-2023').
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        bool: True if the student is in the executive board for the specified parameters, False otherwise.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT EXISTS (
    SELECT 1
    FROM exec_board
    WHERE
        exec_board.studentid = ? AND
        exec_board.position = ? AND
        exec_board.semester = ? AND
        exec_board.year = ?
) AS result;
                """,
            (studentid, position, semester, year),
        )
        conn.commit()
        result: int = res.fetchone()[0]
    return True if result == 1 else False


def AddExec(
    studentid: int,
    position: str,
    semester: str,
    year: str,
    conn: sqlite3.Connection | None = None,
):
    """Adds a member to the exutive board if the user is not already serving for that
    term.

    Args:
        studentid (int): The StudentID of the member being added to the table
        position (str): The position the member served
        semester (str): The semester the member served (F/S)
        year (str): The year the member served
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        if (
            CheckIsInExec(
                studentid=studentid, position=position, semester=semester, year=year
            )
            == 1
        ):
            raise (
                DBFuncError(
                    f"""
User is already serving in the executive board for the chosen term:
    StudentID: {studentid}
    Position:  {position}
    Semester:  {semester}
    Year:      {year}
                    """
                )
            )
        else:
            can_vote: str = (
                "TRUE"
                if position in ("President", "Treasurer", "Recruitment")
                else "FALSE"
            )
            cur.execute(
                """
INSERT INTO exec_board (studentid, position, semester, year, can_vote)
VALUES (?, ?, ?, ?, ?)
                """,
                (studentid, position, semester, year, can_vote),
            )
            conn.commit()
    return


def ModifyStudyHours(
    student_id: int,
    number_hours: int | None = None,
    can_video_game: bool | None = None,
    social_probation: bool | None = None,
    conn: sqlite3.Connection | None = None,
):
    """Modify study hours that are attached to a StudentID

    Args:
        student_id (int): Id of the member whos study hours are being modified
        number_hours (int | None, optional):
            The amount of hours each day a member is to study for. Defaults to None.
        can_video_game (bool | None, optional):
            Determines if a member can play video games (1) or not(0). Defaults to None.
        social_probation (bool | None, optional):
            Determines if a member is on social probation(1) or not(0). Defaults to None.
        conn (sqlite3.Connection | None, optional):
            The SQLite database connection. Defaults to None.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        # Build the SET clause dynamically based on provided parameters
        set_clause = ", ".join(
            f"{field} = ?"
            for field in ["number_hours", "can_video_game", "social_probation"]
            if locals()[field] is not None
        )

        set_values = [
            locals()[field]
            for field in ["number_hours", "can_video_game", "social_probation"]
            if locals()[field] is not None
        ]

        cur.execute(
            f"""
UPDATE studyhours
SET {set_clause}
WHERE
    studentid = ?;
            """,
            (
                *set_values,
                student_id,
            ),
        )
        conn.commit()
    return


def ModifyActive(
    student_id: int,
    service_hours: int,
    is_in_house: bool | None = None,
    conn: sqlite3.Connection | None = None,
):
    """
    Modifies active status and service hours for a student in the database.

    Args:
        student_id (int): The unique identifier of the student.
        service_hours (int): The number of service hours to be added or modified.
        is_in_house (bool | None, optional): Whether the student is in the house or not.
            True if in the house, False if not in the house, None if no change. Defaults to None.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        # Build the SET clause dynamically based on provided parameters
        set_clause = ", ".join(
            "{} = {} + ?".format(field, field)
            for field in ["service_hours"]
            if locals()[field] is not None
        )

        if is_in_house is not None:
            set_clause += ", in_house = ?"

        set_values = [
            locals()[field]
            for field in ["service_hours", "in_house"]
            if locals()[field] is not None
        ]

        cur.execute(
            f"""
            UPDATE actives
            SET {set_clause}
            WHERE studentid = ?;
            """,
            (
                *set_values,
                student_id,
            ),
        )
        conn.commit()
    return


def AddEmerContact(
    student_id: int,
    f_name: str,
    l_name: str,
    zipcode: int,
    street_address: str,
    city: str,
    state: str,
    email: str,
    pnumber: str,
    conn: sqlite3.Connection | None = None,
):
    """
    Adds a new emergency contact to the database.

    Args:
        student_id (int): The unique identifier of the student.
        f_name (str): First name of the emergency contact.
        l_name (str): Last name of the emergency contact.
        zipcode (int): Zipcode of the emergency contact's address.
        street_address (str): Street address of the emergency contact.
        city (str): City of the emergency contact's address.
        state (str): State of the emergency contact's address.
        email (str): Email address of the emergency contact.
        pnumber (str): Phone number of the emergency contact.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        cur.execute(
            """
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
        VALUES (?,?,?,?,?,?,?,?,?);
        """,
            (
                student_id,
                f_name,
                l_name,
                zipcode,
                street_address,
                city,
                state,
                email,
                pnumber,
            ),
        )
        conn.commit()
    return


def ModifyEmerContact(
    student_id: int,
    f_name: str,
    l_name: str,
    zipcode: int | None = None,
    street_address: str | None = None,
    city: str | None = None,
    state: str | None = None,
    email: str | None = None,
    pnumber: str | None = None,
    conn: sqlite3.Connection | None = None,
):
    """
    Modify information for an existing emergency contact in the database.

    Args:
        student_id (int): The unique identifier of the student.
        f_name (str): First name of the emergency contact.
        l_name (str): Last name of the emergency contact.
        zipcode (int | None, optional): New zipcode. Defaults to None.
        street_address (str | None, optional): New street address. Defaults to None.
        city (str | None, optional): New city. Defaults to None.
        state (str | None, optional): New state. Defaults to None.
        email (str | None, optional): New email address. Defaults to None.
        pnumber (str | None, optional): New phone number. Defaults to None.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        # Build the SET clause dynamically based on provided parameters
        set_values = [
            locals()[field]
            for field in [
                "zipcode",
                "street_address",
                "city",
                "state",
                "email",
                "pnumber",
            ]
            if locals()[field] is not None
        ]

        # Build the SET clause dynamically based on provided parameters
        set_clause = ", ".join(
            f"{field} = ?"
            for field in [
                "zipcode",
                "street_address",
                "city",
                "state",
                "email",
                "pnumber",
            ]
        )

        cur.execute(
            f"""
        UPDATE emergency_contacts 
        SET {set_clause}
        WHERE studentid = ? AND fname = ? AND lname = ?;
        """,
            (student_id, f_name, l_name, *set_values),
        )
        conn.commit()
    return


def AssignFine(
    issuer: int,
    recipient: int,
    reason: str,
    date_issued: date,
    amount: float,
    conn: sqlite3.Connection | None = None,
):
    """
    Assign a fine to a member in the database.

    Args:
        issuer (int): The ID of the member issuing the fine.
        recipient (int): The ID of the member receiving the fine.
        reason (str): The reason for issuing the fine.
        date_issued (date): The date when the fine was issued.
        amount (float): The amount of the fine.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        cur.execute(
            """
            INSERT INTO fines (
            issuer, 
            recipient, 
            reason, 
            date_issued, 
            amount
            )
            VALUES(?,?,?,?,?);
            """,
            (
                issuer,
                recipient,
                reason,
                date_issued,
                amount,
            ),
        )
        conn.commit()
    return


def GetAlumni(
    conn: sqlite3.Connection | None = None,
):
    """
    Retrieve alumni information from the database.

    Args:
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        str: HTML representation of the alumni information.
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()

        res = cur.execute(
            """
SELECT
    alumni.studentid AS 'Student ID',
    members.fname AS 'First Name',
    members.lname AS 'Last Name',
    alumni.grad_year AS 'Grad Year',
    alumni.employer AS 'Employer',
    alumni_honors.honor AS 'Honor'
FROM alumni
JOIN members
    ON alumni.studentid = members.studentid
LEFT JOIN alumni_honors
    ON alumni.studentid = alumni_honors.alumni_studentid
            """
        )
        conn.commit()
        df = pd.DataFrame.from_records(
            data=res.fetchall(), columns=[column[0] for column in res.description]
        )
        pd.set_option("display.max_columns", None)
        print(df)
        return df.to_html(index=False)


def GoAlumni(
    student_id: int,
    employer: str | None,
    conn: sqlite3.Connection | None = None,
):
    """
    Transition a member to alumni status in the database.

    Args:
        student_id (int): The student ID of the member transitioning to alumni status.
        employer (str | None): The employer information for the alumni. Defaults to None.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()
        cur.execute("DELETE FROM actives WHERE studentid = ?;", (student_id,))
        conn.commit()
        cur.execute(
            """
INSERT INTO alumni (studentid, grad_year, employer)
VALUES (?, ?, ?);
                    """,
            (student_id, CURRENT_YEAR, employer),
        )
        conn.commit()
    return


def AddAlumHonor(
    student_id: int,
    honor: str | None,
    conn: sqlite3.Connection | None = None,
):
    """
    Add an honor to an alumni in the database.

    Args:
        student_id (int): The student ID of the alumni receiving the honor.
        honor (str | None): The honor to be added. Defaults to None.
        conn (sqlite3.Connection | None, optional): SQLite database connection. Defaults to None.

    Returns:
        None
    """
    if not conn:
        conn = CreateConn()
    with conn:
        cur = conn.cursor()
        cur.execute(
            """
INSERT INTO alumni_honors (alumni_studentid, honor)
VALUES (?, ?);
                    """,
            (student_id, honor),
        )
        conn.commit()
    return
