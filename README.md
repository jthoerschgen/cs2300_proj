# CS2300 Project

#### by Jimmy Hoerschgen & Dakota Smith

## Installation Instructions

Required Software:

- Windows
- [Anaconda](https://www.anaconda.com/)
- [DB Browser for SQLite](https://sqlitebrowser.org/) (Optional)

In the root of this repository is a YAML file with the correct config to instantiate an Anaconda environment with all of the necesary  packages. Create an Anaconda environment  with it using the following command in an Anaconda powershell window:

```
    conda env create --file \cs2300_proj\CS2300.yml
```

A copy of the _.db_ file used for this project is included in the repository. If you wish to create a fresh copy of the database run the _SQL_ queries found in: **\cs2300_proj\sql_queries\\\_initdb.sql**

If you create a new copy of the database you will need to modify the value for **DB_PATH** in **\cs2300_proj\app\constants.py**

## Execution Instructions

To run the front-end application for this project run the following commands in the Anaconda powershell window:

```
    conda activate CS2300
```

```
    python app\main.py
```

Once you run these commands you should see something like this:
```
(CS2300) PS C:\...\cs2300_proj> python .\app\main.py
INFO:     Will watch for changes in these directories: ['C:\\...\\cs2300_proj']
INFO:     Uvicorn running on http://127.0.0.1:8080 (Press CTRL+C to quit)
INFO:     Started reloader process [37976] using StatReload
INFO:     Started server process [19048]
INFO:     Waiting for application startup.
CS 2300 Project
INFO:     Application startup complete.
```

Enter the URL: **http://127.0.0.1:8080** into a web browser to access the application.

When you wish to terminate the application enter *CTRL + C* or exit the Anaconda powershell terminal.