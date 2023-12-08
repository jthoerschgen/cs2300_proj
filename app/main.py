import sqlite3
import traceback
from contextlib import asynccontextmanager
from datetime import datetime

import uvicorn
from constants import CURRENT_SEMESTER, CURRENT_YEAR
from database_funcs import (
    AddAlumHonor,
    AddEmerContact,
    AddExec,
    AddMember,
    AddToDetail,
    AssignFine,
    CheckOffDetail,
    CreateConn,
    DeleteMember,
    GenWeeklySchedule,
    GetAllDepartments,
    GetAllMembers,
    GetAlumni,
    GetAvgGrade,
    GetDetails,
    GetExec,
    GetGrades,
    GoAlumni,
    InsertCourse,
    ModifyActive,
    ModifyEmerContact,
    ModifyStudyHours,
)
from fastapi import FastAPI, Form, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

conn: sqlite3.Connection = CreateConn()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Executes code during app start-up and shut-down
    00
        Args:
            app (FastAPI): FastAPI app
    """
    # On start-up
    print("Starting CS 2300 Project...")
    cur = conn.cursor()
    cur.execute("PRAGMA foreign_keys;")
    conn.commit()
    fks_on: int = cur.fetchone()[0]
    print(f"TESTING:       PRAGMA foreign_keys = {'ON' if fks_on == 1 else 'OFF'}")
    yield
    # On shut-down
    print("Goodbye!")


app = FastAPI(lifespan=lifespan)
# app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates/")


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


@app.get("/mod-member", response_class=HTMLResponse)
async def modify_member(request: Request):
    return templates.TemplateResponse("mod_member.html", {"request": request})


@app.post("/add-member")
async def AddMemberPost(
    request: Request,
    fname: str = Form(...),
    lname: str = Form(...),
    yearjoined: str = Form(...),
    birthday: str = Form(...),
    pnumber: str = Form(...),
    password: str = Form(...),
    bbrotherid: int = Form(...),
):
    try:
        AddMember(
            first_name=fname,
            last_name=lname,
            year_joined=yearjoined,
            birthday=birthday,
            phone_number=pnumber,
            password=password,
            big_brother_id=bbrotherid,
            conn=conn,
        )

        return templates.TemplateResponse(
            "add_member.html",
            {"request": request, "result": f"{fname} {lname}, has been submitted."},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/add-member")
async def AddMemberGet(request: Request):
    return templates.TemplateResponse(
        "add_member.html", {"request": request, "result": "Add Member"}
    )


@app.post("/rem-member")
async def RemMemberPost(
    request: Request,
    studentid: int = Form(...),
):
    try:
        DeleteMember(studentid=studentid, conn=conn)
        return templates.TemplateResponse(
            "rem_member.html",
            {
                "request": request,
                "result": f"Member {studentid} Deleted Successfuly",
                "members": GetAllMembers(),
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/rem-member")
async def RemMemberGet(request: Request):
    return templates.TemplateResponse(
        "rem_member.html",
        {
            "request": request,
            "result": "Choose a member to remove.",
            "members": GetAllMembers(),
        },
    )


@app.get("/get-departments")
async def GetDepartments():
    return GetAllDepartments()


@app.post("/add-course")
async def AddCoursePost(
    request: Request,
    studentid: int = Form(...),
    year: int = Form(...),
    semester: str = Form(...),
    coursecode: int = Form(...),
    department: str = Form(...),
    starttime: str = Form(...),
    endtime: str = Form(...),
    days: list[str] = Form(...),
):
    try:
        InsertCourse(
            student_id=studentid,
            year=year,
            semester=semester,
            course_code=coursecode,
            department=department,
            start_time=datetime.strptime(starttime, "%H:%M").time(),
            end_time=datetime.strptime(endtime, "%H:%M").time(),
            days=days,
        )

        schedulehtml: str = (
            f"<p>Weekly Schedule for Member #{studentid}:</p>"
            + f"<p>({'Fall' if semester == 'F' else 'Spring'} {year})</p>"
            + GenWeeklySchedule(
                studentid=studentid, semester=semester, year=year, conn=conn
            )
        )

        return templates.TemplateResponse(
            "weekly_schedule.html",
            {"request": request, "schedule": schedulehtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.post("/weekly-schedule")
async def WeeklySchedulePost(
    request: Request,
    studentid: int = Form(...),
    semester: str = Form(...),
    year: int = Form(...),
):
    try:
        schedulehtml: str = (
            f"<p>Weekly Schedule for Member #{studentid}:</p>"
            + f"<p>({'Fall' if semester == 'F' else 'Spring'} {year})</p>"
            + GenWeeklySchedule(
                studentid=studentid, semester=semester, year=year, conn=conn
            )
        )

        return templates.TemplateResponse(
            "weekly_schedule.html",
            {"request": request, "schedule": schedulehtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/weekly-schedule")
async def WeeklyScheduleGet(request: Request):
    return templates.TemplateResponse(
        "weekly_schedule.html",
        {"request": request},
    )


@app.post("/details-schedule")
async def DetailsSchedulePost(
    request: Request,
    start: str = Form(...),
    end: str = Form(...),
):
    try:
        schedulehtml: str = GetDetails(start_date=start, end_date=end, conn=conn)

        return templates.TemplateResponse(
            "details.html",
            {"request": request, "schedule": schedulehtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.post("/details-checkoff")
async def DetailsCheckoffPost(
    request: Request,
    exec_id: int = Form(...),
    exec_password: str = Form(...),
    detail_name: str = Form(...),
    detail_date: str = Form(...),
):
    try:
        CheckOffDetail(
            exec_id=exec_id,
            exec_password=exec_password,
            detail_name=detail_name,
            detail_date=detail_date,
            conn=conn,
        )

        return templates.TemplateResponse(
            "details.html",
            {"request": request, "schedule": ""},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.post("/add-to-details")
async def DetailsAddMemberPost(
    request: Request,
    studentid: int = Form(...),
    detail_name: str = Form(...),
    detail_date: str = Form(...),
):
    try:
        schedulehtml: str = GetDetails(
            start_date=detail_date, end_date=detail_date, conn=conn
        )
        AddToDetail(
            student_id=studentid, detail_name=detail_name, detail_date=detail_date
        )

        return templates.TemplateResponse(
            "details.html",
            {"request": request, "schedule": schedulehtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/details")
async def DetailsGet(request: Request):
    return templates.TemplateResponse(
        "details.html", {"request": request, "schedule": ""}
    )


@app.post("/get-exec")
async def ShowExecBoardPost(
    request: Request,
    semester: str = Form(...),
    year: str = Form(...),
):
    try:
        exechtml: str = (
            f"<p> Exec for {'Fall' if semester == 'F' else 'Spring'} {year}</p>"
            + GetExec(semester=semester, year=year, conn=conn)
        )

        return templates.TemplateResponse(
            "exec_board.html",
            {"request": request, "execinfo": exechtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.post("/add-exec")
async def AddExecBoardPost(
    request: Request,
    studentid: int = Form(...),
    position: str = Form(...),
    semester: str = Form(...),
    year: str = Form(...),
):
    try:
        AddExec(
            studentid=studentid,
            position=position,
            semester=semester,
            year=year,
            conn=conn,
        )
        exechtml: str = (
            f"<p> Exec for {'Fall' if semester == 'F' else 'Spring'} {year}</p>"
            + GetExec(semester=semester, year=year, conn=conn)
        )

        return templates.TemplateResponse(
            "exec_board.html",
            {"request": request, "execinfo": exechtml},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/exec")
async def ExecBoardGet(request: Request):
    return templates.TemplateResponse(
        "exec_board.html",
        {
            "request": request,
            "execinfo": (
                f"""
<p> Exec for {'Fall' if CURRENT_SEMESTER == 'F' else 'Spring'} {CURRENT_YEAR}</p>
                """
                + GetExec(semester=CURRENT_SEMESTER, year=CURRENT_YEAR)
            ),
        },
    )


@app.post("/add-alum")
async def AddAlumniPost(
    request: Request,
    studentid: int = Form(...),
    employer: str | None = Form(None),
):
    try:
        if employer and len(employer) == 0:
            employer = None
        GoAlumni(
            student_id=studentid,
            employer=employer,
            conn=conn,
        )

        return templates.TemplateResponse(
            "alumni.html",
            {
                "request": request,
                "aluminfo": (GetAlumni()),
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.post("/add-alum-honor")
async def AddAlumniPost(
    request: Request,
    studentid: int = Form(...),
    honor: str = Form(...),
):
    try:
        AddAlumHonor(
            student_id=studentid,
            honor=honor,
            conn=conn,
        )

        return templates.TemplateResponse(
            "alumni.html",
            {
                "request": request,
                "aluminfo": (GetAlumni()),
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/alumni")
async def AlumniGet(request: Request):
    return templates.TemplateResponse(
        "alumni.html",
        {
            "request": request,
            "aluminfo": (GetAlumni()),
        },
    )


@app.post("/add-emercontact")
async def AddEmerContactPost(
    request: Request,
    studentid: int = Form(...),
    fname: str = Form(...),
    lname: str = Form(...),
    zipcode: int = Form(...),
    street_address: str = Form(...),
    city: str = Form(...),
    state: str = Form(...),
    email: str = Form(...),
    pnumber: str = Form(...),
):
    try:
        AddEmerContact(
            student_id=studentid,
            f_name=fname,
            l_name=lname,
            zipcode=zipcode,
            street_address=street_address,
            city=city,
            state=state,
            email=email,
            pnumber=pnumber,
            conn=conn,
        )

        return templates.TemplateResponse(
            "add_emercontact.html",
            {"request": request, "result": f"{fname} {lname}, has been submitted."},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/add-emercontact")
async def AddEmerContactGet(request: Request):
    return templates.TemplateResponse(
        "add_emercontact.html", {"request": request, "result": "Add Emergency Contact"}
    )


@app.post("/mod-emercontact")
async def ModifyEmerContactPost(
    request: Request,
    studentid: int = Form(...),
    fname: str = Form(...),
    lname: str = Form(...),
    zipcode: int = Form(None),
    street_address: str = Form(None),
    city: str = Form(None),
    state: str = Form(None),
    email: str = Form(None),
    pnumber: str = Form(None),
):
    try:
        ModifyEmerContact(
            student_id=studentid,
            f_name=fname,
            l_name=lname,
            zipcode=zipcode,
            street_address=street_address,
            city=city,
            state=state,
            email=email,
            pnumber=pnumber,
            conn=conn,
        )

        return templates.TemplateResponse(
            "mod_emercontact.html",
            {"request": request, "result": f"{fname} {lname}, has been updated."},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/mod-emercontact")
async def ModifyEmerContactGet(request: Request):
    return templates.TemplateResponse(
        "mod_emercontact.html",
        {"request": request, "result": "Modify Emergency Contact"},
    )


@app.post("/mod-studyhours")
async def ModifyStudyHoursPost(
    request: Request,
    studentid: int = Form(...),
    num_hrs: int = Form(None),
    can_vg: bool = Form(None),
    sopro: bool = Form(None),
):
    try:
        ModifyStudyHours(
            student_id=studentid,
            number_hours=num_hrs,
            can_video_game=can_vg,
            social_probation=sopro,
            conn=conn,
        )

        return templates.TemplateResponse(
            "mod_studyhours.html",
            {
                "request": request,
                "result": f"Student {studentid} study hours have been updated.",
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/mod-studyhours")
async def ModifyStudyHoursGet(request: Request):
    return templates.TemplateResponse(
        "mod_studyhours.html",
        {"request": request, "result": "Modify Study Hours"},
    )


@app.post("/mod-active")
async def ModifyActivePost(
    request: Request,
    studentid: int = Form(...),
    service_hours: int = Form(None),
    in_house: bool = Form(None),
):
    try:
        ModifyActive(
            student_id=studentid,
            service_hours=service_hours,
            is_in_house=in_house,
            conn=conn,
        )

        return templates.TemplateResponse(
            "mod_active.html",
            {
                "request": request,
                "result": f"active {studentid} has been updated.",
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/mod-active")
async def ModifyActiveGet(request: Request):
    return templates.TemplateResponse(
        "mod_active.html",
        {"request": request, "result": "Modify Active"},
    )


@app.post("/assignfine")
async def AssignFinePost(
    request: Request,
    issuer: int = Form(...),
    recipient: int = Form(...),
    reason: str = Form(...),
    date_issued: str = Form(...),
    amount: float = Form(...),
):
    try:
        AssignFine(
            issuer=issuer,
            recipient=recipient,
            reason=reason,
            date_issued=date_issued,
            amount=amount,
            conn=conn,
        )

        return templates.TemplateResponse(
            "assignfine.html",
            {
                "request": request,
                "result": f"{recipient} has been fined {amount} by {issuer}.",
            },
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/assignfine")
async def AssignFineGet(request: Request):
    return templates.TemplateResponse(
        "assignfine.html", {"request": request, "result": "Assign Fine"}
    )


@app.post("/get-grades")
async def GetGradesPost(
    request: Request,
    studentid: int = Form(...),
    semester: str = Form(...),
    year: int = Form(...),
):
    try:
        grade_report_html: str = GetGrades(
            student_id=studentid, semester=semester, year=year
        )
        avg_grade: float = GetAvgGrade(
            student_id=studentid, semester=semester, year=year
        )

        return templates.TemplateResponse(
            "grades.html",
            {"request": request, "grades": grade_report_html, "avg": avg_grade},
        )
    except Exception as _e:
        print(traceback.format_exc())
        print(_e)
        return HTTPException(status_code=500, detail=str(_e))


@app.get("/grades")
async def GradesGet(request: Request):
    return templates.TemplateResponse(
        "grades.html", {"request": request, "grades": "", "avg": ""}
    )


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        port=8080,
        log_level="info",
        reload=True,
    )
