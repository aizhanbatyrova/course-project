# Car Manufacturing ERP

Flask web application for managing a car manufacturing workflow with Microsoft SQL Server.

## Project Contents

- `app.py` - Flask application.
- `templates/` - HTML templates.
- `static/` - CSS and static assets.
- `database/schema.sql` - SQL Server database structure, views, procedures, and triggers.
- `database/seed.sql` - sample data exported from the local `CarManufacturing` database.
- `course work_Batyrova Aizhan.docx` - course work document.

## Requirements

- Python 3.10+
- Microsoft SQL Server
- ODBC Driver / SQL Server driver for `pyodbc`

## Setup

1. Create and activate a virtual environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

2. Install dependencies:

```powershell
pip install -r requirements.txt
```

3. Create the database in SQL Server:

```powershell
sqlcmd -S localhost -E -i database\schema.sql
sqlcmd -S localhost -E -i database\seed.sql
```

If your SQL Server instance has another name, replace `localhost` with your server name, for example `DESKTOP-7H7TALB`.

4. Create a local `.env` file from the example:

```powershell
Copy-Item .env.example .env
```

Edit `.env` if your SQL Server name or database name is different:

```env
DB_SERVER=localhost
DB_NAME=CarManufacturing
DB_TRUSTED_CONNECTION=yes
```

5. Run the Flask application:

```powershell
python app.py
```

Open the address shown in the terminal, usually `http://127.0.0.1:5000`.

## Notes

The real `.env` file is ignored by Git so database passwords and local machine settings are not published.
