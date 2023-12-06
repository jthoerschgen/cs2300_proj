import sqlite3
from datetime import date
import pandas as pd
from constants import DB_PATH, CURRENT_SEMESTER, CURRENT_YEAR


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
    if not conn:
        conn = sqlite3.connect(DB_PATH)
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
VALUES (
        ?,?,?,?,?,?,?,?
);
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
    return


def DeleteMember(
    studentid: int,
    conn: sqlite3.Connection | None = None,
):
    if not conn:
        conn = sqlite3.connect(DB_PATH)
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
    if not conn:
        conn = sqlite3.connect(DB_PATH)
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
        return df.to_html(index=False)


def GetAllMembers(
    conn: sqlite3.Connection | None = None,
) -> str:
    if not conn:
        conn = sqlite3.connect(DB_PATH)
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
        return df.to_html(index=False)


def LoginExec(
    studentid: int,
    password: str,
    conn: sqlite3.Connection | None = None,
) -> tuple[bool, dict]:
    if not conn:
        conn = sqlite3.connect(DB_PATH)

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
    if not conn:
        conn = sqlite3.connect(DB_PATH)

    login_success, login_info = LoginExec(studentid=exec_id, password=exec_password)
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


def GetDetails(
    start_date: date,
    end_date: date,
    conn: sqlite3.Connection | None = None,
) -> bool:
    if not conn:
        conn = sqlite3.connect(DB_PATH)

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
        return df.to_html(index=False)
