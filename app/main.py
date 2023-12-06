import uvicorn
from fastapi import FastAPI, Request, Form, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from contextlib import asynccontextmanager
from pathlib import Path
import traceback
from constants import DB_PATH
from database_funcs import (
    AddMember,
    GenWeeklySchedule,
    GetAllMembers,
    DeleteMember,
    GetDetails,
    CheckOffDetail,
)


import sqlite3

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
        DeleteMember(studentid=studentid)
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


@app.post("/weekly-schedule")
async def WeeklySchedulePost(
    request: Request,
    studentid: int = Form(...),
    semester: str = Form(...),
    year: int = Form(...),
):
    try:
        schedulehtml: str = GenWeeklySchedule(
            studentid=studentid, semester=semester, year=year
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
        "weekly_schedule.html", {"request": request, "schedule": ""}
    )


@app.post("/details-schedule")
async def DetailsSchedulePost(
    request: Request,
    start: str = Form(...),
    end: str = Form(...),
):
    try:
        schedulehtml: str = GetDetails(start_date=start, end_date=end)

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
        )

        return templates.TemplateResponse(
            "details.html",
            {"request": request, "schedule": ""},
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


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        port=8080,
        log_level="info",
        reload=True,
    )