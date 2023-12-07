import sqlite3
import traceback
from contextlib import asynccontextmanager
from datetime import datetime

import uvicorn
from constants import CURRENT_SEMESTER, CURRENT_YEAR, DB_PATH
from database_funcs import (
    AddExec,
    AddMember,
    AddToDetail,
    CheckOffDetail,
    DeleteMember,
    GenWeeklySchedule,
    GetAllDepartments,
    GetAllMembers,
    GetDetails,
    GetExec,
    InsertCourse,
)
from fastapi import FastAPI, Form, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

conn: sqlite3.Connection = sqlite3.connect(DB_PATH)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Executes code during app start-up and shut-down

    Args:
        app (FastAPI): FastAPI app
    """
    # On start-up
    print("CS 2300 Project")
    yield
    # On shut-down
    print("Goodbye!")


app = FastAPI(lifespan=lifespan)
# app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates/")


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


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


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        port=8080,
        log_level="info",
        reload=True,
    )
