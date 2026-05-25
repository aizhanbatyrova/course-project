from collections import OrderedDict
from datetime import date, datetime
from decimal import Decimal
import os

from flask import Flask, flash, redirect, render_template, request, url_for
import pyodbc

try:
    from dotenv import load_dotenv
except ImportError:
    load_dotenv = None

if load_dotenv:
    load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "full_erp_secret")


@app.template_filter("money")
def money_filter(value):
    return f"{_to_number(value):,.0f}".replace(",", " ")


def get_db_connection():
    driver = os.getenv("DB_DRIVER", "SQL Server")
    server = os.getenv("DB_SERVER", "DESKTOP-7H7TALB")
    database = os.getenv("DB_NAME", "CarManufacturing")
    trusted_connection = os.getenv("DB_TRUSTED_CONNECTION", "yes")

    username = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")

    connection_parts = [
        f"DRIVER={{{driver}}}",
        f"SERVER={server}",
        f"DATABASE={database}",
    ]

    if username and password:
        connection_parts.extend([f"UID={username}", f"PWD={password}"])
    else:
        connection_parts.append(f"Trusted_Connection={trusted_connection}")

    return pyodbc.connect(
        ";".join(connection_parts) + ";"
    )


def parse_positive_int(value, field_name):
    try:
        number = int(value)
    except (TypeError, ValueError):
        raise ValueError(f"Invalid value for {field_name}.")

    if number <= 0:
        raise ValueError(f"{field_name} must be greater than 0.")

    return number


def _find_column(columns, candidates):
    column_map = {c.lower(): c for c in columns}
    for candidate in candidates:
        match = column_map.get(candidate.lower())
        if match:
            return match
    return None


def _to_number(value):
    if value is None:
        return 0.0
    if isinstance(value, Decimal):
        return float(value)
    if isinstance(value, (int, float)):
        return float(value)
    try:
        return float(value)
    except (TypeError, ValueError):
        return 0.0


def _date_label(value):
    if isinstance(value, datetime):
        return value.strftime("%Y-%m-%d")
    if isinstance(value, date):
        return value.isoformat()
    return str(value)


def fetch_first_successful(cursor, queries):
    for query in queries:
        try:
            cursor.execute(query)
            rows = cursor.fetchall()
            columns = [c[0] for c in cursor.description]
            return rows, columns
        except pyodbc.Error:
            continue
    return [], []


def rows_to_dicts(rows, columns):
    records = []
    for row in rows:
        record = {}
        for index, column in enumerate(columns):
            value = row[index]
            if isinstance(value, Decimal):
                value = float(value)
            record[column] = value
        records.append(record)
    return records


def execute_with_result(cursor, sql, params=()):
    cursor.execute(sql, params)
    result = {}

    while True:
        if cursor.description is not None:
            columns = [column[0] for column in cursor.description]
            row = cursor.fetchone()
            if row:
                result = {columns[index]: row[index] for index in range(len(columns))}
        if not cursor.nextset():
            break

    return result


def aggregate_series(records, label_key, value_key):
    series = OrderedDict()
    for record in records:
        label = _date_label(record.get(label_key))
        series[label] = round(series.get(label, 0.0) + _to_number(record.get(value_key)), 2)
    return list(series.keys()), list(series.values())


def aggregate_categories(records, label_key, value_key, limit=8):
    totals = {}
    for record in records:
        label = str(record.get(label_key) or "Unknown")
        totals[label] = round(totals.get(label, 0.0) + _to_number(record.get(value_key)), 2)

    sorted_items = sorted(totals.items(), key=lambda item: item[1], reverse=True)[:limit]
    labels = [item[0] for item in sorted_items]
    data = [item[1] for item in sorted_items]
    return labels, data


def make_chart(chart_id, chart_type, title, caption, labels, data, dataset_label, background, border=None):
    return {
        "id": chart_id,
        "type": chart_type,
        "title": title,
        "caption": caption,
        "labels": labels,
        "data": data,
        "dataset_label": dataset_label,
        "backgroundColor": background,
        "borderColor": border or background,
    }


def get_budget_value(cursor):
    cursor.execute("SELECT Budget_Amount FROM Budget WHERE ID = 1")
    row = cursor.fetchone()
    return row[0] if row else 0


REQUEST_STATUSES = {
    "created": "Created",
    "checking": "Under raw material availability check",
    "procurement": "In the process of raw material procurement",
    "production": "In the production process",
    "sales": "In the sales process",
    "completed": "Completed",
    "error": "Error",
}


def ensure_production_requests_table(cursor):
    cursor.execute(
        """
        IF OBJECT_ID(N'[Production Requests]', N'U') IS NULL
        BEGIN
            CREATE TABLE [Production Requests] (
                Request_ID INT IDENTITY(1,1) PRIMARY KEY,
                Creation_Date DATETIME NOT NULL DEFAULT GETDATE(),
                Last_Update_Date DATETIME NOT NULL DEFAULT GETDATE(),
                Status NVARCHAR(100) NOT NULL,
                Applicant_Full_Name NVARCHAR(200) NOT NULL,
                Finished_Product_ID INT NOT NULL,
                Quantity INT NOT NULL DEFAULT 1,
                Rejection_Reason NVARCHAR(500) NULL,
                Error_Stage NVARCHAR(100) NULL
            );
        END

        IF COL_LENGTH('[Production Requests]', 'Quantity') IS NULL
            ALTER TABLE [Production Requests] ADD Quantity INT NOT NULL DEFAULT 1;

        IF COL_LENGTH('[Production Requests]', 'Error_Stage') IS NULL
            ALTER TABLE [Production Requests] ADD Error_Stage NVARCHAR(100) NULL;
        """
    )


def update_production_request(cursor, request_id, status, reason=None, stage=None):
    cursor.execute(
        """
        UPDATE [Production Requests]
        SET Last_Update_Date = GETDATE(),
            Status = ?,
            Rejection_Reason = ?,
            Error_Stage = ?
        WHERE Request_ID = ?
        """,
        (status, reason, stage, request_id),
    )


def load_production_requests(cursor, limit=20):
    ensure_production_requests_table(cursor)
    cursor.execute(
        f"""
        SELECT TOP {int(limit)}
            pr.Request_ID,
            pr.Creation_Date,
            pr.Last_Update_Date,
            pr.Status,
            pr.Applicant_Full_Name,
            fp.Name AS Product_Name,
            pr.Quantity,
            pr.Rejection_Reason,
            pr.Error_Stage
        FROM [Production Requests] pr
        LEFT JOIN Finished_Products fp ON fp.ID = pr.Finished_Product_ID
        ORDER BY pr.Request_ID DESC
        """
    )
    rows = cursor.fetchall()
    columns = [c[0] for c in cursor.description]
    return rows_to_dicts(rows, columns)


def get_product_recipe(cursor, product_id, quantity):
    cursor.execute(
        """
        SELECT
            i.Raw_Material_ID,
            rm.Name,
            CAST(i.Quantity AS DECIMAL(18,4)) * ? AS Required_Qty,
            CAST(rm.Quantity AS DECIMAL(18,4)) AS Available_Qty,
            CASE
                WHEN rm.Quantity > 0 THEN CAST(rm.Amount AS DECIMAL(18,4)) / CAST(rm.Quantity AS DECIMAL(18,4))
                WHEN rm.Amount > 0 THEN CAST(rm.Amount AS DECIMAL(18,4))
                ELSE 0
            END AS Unit_Cost
        FROM Ingredients i
        JOIN Raw_Materials rm ON rm.ID = i.Raw_Material_ID
        WHERE i.Product_ID = ?
        """,
        (quantity, product_id),
    )
    return cursor.fetchall()


def call_insert_purchase(cursor, material_id, quantity, amount, employee_id=2):
    result = execute_with_result(
        cursor,
        """
        DECLARE @result INT;
        EXEC dbo.sp_InsertPurchase
            @MaterialID=?,
            @Qty=?,
            @Amount=?,
            @EmpID=?,
            @Result=@result OUTPUT;
        SELECT @result AS Result;
        """,
        (material_id, quantity, amount, employee_id),
    )
    return int(result.get("Result", 1))


def load_production_report(cursor):
    rows, columns = fetch_first_successful(
        cursor,
        (
            "SELECT * FROM View_Production_Log",
            """
            SELECT pp.Prod_Date AS [Date], fp.Name AS [Model], pp.Quantity AS [Qty], e.Full_Name AS [Responsible]
            FROM Product_Production pp
            JOIN Finished_Products fp ON fp.ID = pp.Product_ID
            JOIN Employees e ON e.ID = pp.Employee_ID
            ORDER BY pp.Prod_Date DESC
            """,
        ),
    )
    return rows_to_dicts(rows, columns)


def load_salary_report(cursor):
    rows, columns = fetch_first_successful(
        cursor,
        (
            """
            SELECT sp.Payment_Date AS [Date], e.Full_Name AS [Employee], p.Job_Title AS [Position], sp.Amount AS [Amount]
            FROM Salary_Payments sp
            JOIN Employees e ON e.ID = sp.Employee_ID
            JOIN Positions p ON p.ID = e.Position_ID
            ORDER BY sp.Payment_Date DESC
            """,
        ),
    )
    return rows_to_dicts(rows, columns)


def load_sales_report(cursor):
    rows, columns = fetch_first_successful(
        cursor,
        (
            "SELECT * FROM View_Sales_Summary",
            """
            SELECT ps.Sale_Date AS [Date of Sale], fp.Name AS [Car Model], ps.Quantity AS [Sold Qty], ps.Amount AS [Revenue], e.Full_Name AS [Sales Manager]
            FROM Product_Sales ps
            JOIN Finished_Products fp ON fp.ID = ps.Product_ID
            JOIN Employees e ON e.ID = ps.Employee_ID
            ORDER BY ps.Sale_Date DESC
            """,
        ),
    )
    return rows_to_dicts(rows, columns)


def load_loans_report(cursor):
    rows, columns = fetch_first_successful(
        cursor,
        (
            """
            SELECT ID, Bank_Name, Loan_Amount, Interest_Rate, Loan_Date, Status
            FROM Business_Loans
            ORDER BY Loan_Date DESC
            """,
        ),
    )
    loans = rows_to_dicts(rows, columns)
    for loan in loans:
        principal = _to_number(loan.get("Loan_Amount"))
        rate = _to_number(loan.get("Interest_Rate"))
        loan["Total_Due"] = round(principal * (1 + rate / 100), 2)
    return loans


def build_report_hub_charts(prod_records, sales_records, loan_records):
    prod_labels, prod_values = aggregate_series(prod_records, "Date", "Qty")
    revenue_labels, revenue_values = aggregate_series(sales_records, "Date of Sale", "Revenue")
    loan_status_labels, loan_status_values = aggregate_categories(loan_records, "Status", "Loan_Amount")

    charts = []
    if prod_labels:
        charts.append(
            make_chart(
                "hubProductionChart",
                "line",
                "Production Dynamics",
                "Shows how many cars were assembled by date.",
                prod_labels,
                prod_values,
                "Produced cars",
                "rgba(22, 105, 122, 0.18)",
                "#16697a",
            )
        )
    if revenue_labels:
        charts.append(
            make_chart(
                "hubRevenueChart",
                "bar",
                "Revenue Dynamics",
                "Shows how revenue changes over time.",
                revenue_labels,
                revenue_values,
                "Revenue, KGS",
                "rgba(224, 122, 95, 0.75)",
                "#e07a5f",
            )
        )
    if loan_status_labels:
        charts.append(
            make_chart(
                "hubLoanStatusChart",
                "doughnut",
                "Loan Portfolio",
                "Distribution of loans by status.",
                loan_status_labels,
                loan_status_values,
                "Loan amount, KGS",
                ["#16697a", "#e07a5f", "#7a9e7e", "#335c67"],
                ["#16697a", "#e07a5f", "#7a9e7e", "#335c67"],
            )
        )
    return charts


def build_production_charts(records):
    labels_by_date, values_by_date = aggregate_series(records, "Date", "Qty")
    labels_by_model, values_by_model = aggregate_categories(records, "Model", "Qty")
    return [
        make_chart(
            "productionTimelineChart",
            "line",
            "Production by Date",
            "Shows how many cars were assembled on each date.",
            labels_by_date,
            values_by_date,
            "Cars assembled",
            "rgba(22, 105, 122, 0.18)",
            "#16697a",
        ),
        make_chart(
            "productionModelsChart",
            "bar",
            "Production by Model",
            "Shows which models are assembled most often.",
            labels_by_model,
            values_by_model,
            "Cars assembled",
            "rgba(122, 158, 126, 0.75)",
            "#7a9e7e",
        ),
    ]


def build_salary_charts(records):
    labels_by_date, values_by_date = aggregate_series(records, "Date", "Amount")
    labels_by_employee, values_by_employee = aggregate_categories(records, "Employee", "Amount", limit=6)
    return [
        make_chart(
            "salaryTimelineChart",
            "line",
            "Payroll by Date",
            "Shows how much money was paid on each payroll date.",
            labels_by_date,
            values_by_date,
            "Payroll, KGS",
            "rgba(224, 122, 95, 0.18)",
            "#e07a5f",
        ),
        make_chart(
            "salaryEmployeesChart",
            "bar",
            "Payroll by Employee",
            "Shows the largest salary totals by employee.",
            labels_by_employee,
            values_by_employee,
            "Salary paid, KGS",
            "rgba(51, 92, 103, 0.78)",
            "#335c67",
        ),
    ]


def build_sales_charts(records):
    labels_by_date, values_by_date = aggregate_series(records, "Date of Sale", "Revenue")
    labels_by_model, values_by_model = aggregate_categories(records, "Car Model", "Sold Qty")
    return [
        make_chart(
            "salesRevenueChart",
            "line",
            "Revenue by Date",
            "Shows how sales revenue changes over time.",
            labels_by_date,
            values_by_date,
            "Revenue, KGS",
            "rgba(224, 122, 95, 0.18)",
            "#e07a5f",
        ),
        make_chart(
            "salesModelsChart",
            "bar",
            "Sales by Model",
            "Shows which car models are sold most often.",
            labels_by_model,
            values_by_model,
            "Cars sold",
            "rgba(22, 105, 122, 0.78)",
            "#16697a",
        ),
    ]


def build_loan_charts(records):
    labels_by_bank, values_by_bank = aggregate_categories(records, "Bank_Name", "Loan_Amount")
    labels_by_status, values_by_status = aggregate_categories(records, "Status", "Loan_Amount")
    return [
        make_chart(
            "loansBankChart",
            "bar",
            "Loan Amount by Bank",
            "Shows which banks provided the largest loans.",
            labels_by_bank,
            values_by_bank,
            "Loan amount, KGS",
            "rgba(22, 105, 122, 0.78)",
            "#16697a",
        ),
        make_chart(
            "loansStatusChart",
            "doughnut",
            "Loan Status",
            "Shows active and repaid loans by amount.",
            labels_by_status,
            values_by_status,
            "Loan amount, KGS",
            ["#16697a", "#e07a5f", "#7a9e7e", "#335c67"],
            ["#16697a", "#e07a5f", "#7a9e7e", "#335c67"],
        ),
    ]


def load_sales_log(cursor):
    sales_log = []
    for query in (
        """
        SELECT TOP 10 ps.ID, fp.Name, ps.Quantity, ps.Amount, ps.Sale_Date, ps.Is_Cancelled, ps.Status
        FROM Product_Sales ps
        LEFT JOIN Finished_Products fp ON fp.ID = ps.Product_ID
        ORDER BY ps.Sale_Date DESC
        """,
        """
        SELECT TOP 10 ps.ID, fp.Name, ps.Quantity, ps.Amount, ps.Sale_Date
        FROM Product_Sales ps
        LEFT JOIN Finished_Products fp ON fp.ID = ps.Product_ID
        ORDER BY ps.Sale_Date DESC
        """,
    ):
        try:
            cursor.execute(query)
            rows = cursor.fetchall()
            columns = [c[0] for c in cursor.description]

            id_col = _find_column(columns, ["ID", "Sale_ID", "SaleID"])
            product_col = _find_column(columns, ["Name"])
            qty_col = _find_column(columns, ["Quantity", "Qty"])
            amount_col = _find_column(columns, ["Amount", "Total_Amount", "Sale_Amount"])
            date_col = _find_column(columns, ["Sale_Date", "Date", "Created_At"])
            canceled_col = _find_column(columns, ["Is_Cancelled", "Is_Canceled", "Canceled"])
            status_col = _find_column(columns, ["Status", "Sale_Status"])

            sales_log = []
            for row in rows:
                data = {columns[i]: row[i] for i in range(len(columns))}
                is_canceled = False
                if canceled_col and data.get(canceled_col) in (1, True):
                    is_canceled = True
                if status_col and str(data.get(status_col) or "").strip().lower() in ("canceled", "cancelled", "rolled_back"):
                    is_canceled = True

                sales_log.append(
                    {
                        "id": data.get(id_col),
                        "product": data.get(product_col),
                        "qty": data.get(qty_col),
                        "amount": data.get(amount_col),
                        "date": data.get(date_col),
                        "is_canceled": is_canceled,
                    }
                )
            break
        except pyodbc.Error:
            continue
    return sales_log


@app.route('/')
def dashboard():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        budget = get_budget_value(cursor)

        cursor.execute("SELECT COUNT(*) FROM Employees")
        emp_count = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM Raw_Materials")
        mat_count = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM Product_Sales")
        sales_count = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM Finished_Products")
        product_count = cursor.fetchone()[0]

        return render_template(
            "dashboard.html",
            budget=budget,
            emp_count=emp_count,
            mat_count=mat_count,
            sales_count=sales_count,
            product_count=product_count,
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return render_template("dashboard.html", budget=0, emp_count=0, mat_count=0, sales_count=0, product_count=0)
    finally:
        if conn:
            conn.close()


@app.route('/operations')
def index():
    return redirect(url_for("buying"))


def load_operations_context():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        budget = get_budget_value(cursor)

        cursor.execute("SELECT * FROM View_Current_Warehouse")
        inventory = cursor.fetchall()

        cursor.execute("SELECT ID, Name FROM Raw_Materials")
        raw_materials = cursor.fetchall()

        cursor.execute("SELECT ID, Name FROM Finished_Products")
        products = cursor.fetchall()

        cursor.execute("SELECT ID, Name, Quantity, Amount FROM Finished_Products ORDER BY ID")
        finished_products = cursor.fetchall()

        cursor.execute("SELECT COUNT(*), COALESCE(SUM(Salary), 0) FROM Employees")
        employee_stats = cursor.fetchone()

        sales_log = load_sales_log(cursor)
        loans = [loan for loan in load_loans_report(cursor) if str(loan.get("Status") or "").lower() == "active"]
        production_requests = load_production_requests(cursor, limit=10)

        return {
            "budget": budget,
            "inventory": inventory,
            "raw_materials": raw_materials,
            "products": products,
            "finished_products": finished_products,
            "sales_log": sales_log,
            "loans": loans,
            "production_requests": production_requests,
            "employee_count": employee_stats[0] if employee_stats else 0,
            "total_salary": employee_stats[1] if employee_stats else 0,
            "selected_product_id": request.args.get("product_id", ""),
        }
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return {
            "budget": 0,
            "inventory": [],
            "raw_materials": [],
            "products": [],
            "finished_products": [],
            "sales_log": [],
            "loans": [],
            "production_requests": [],
            "employee_count": 0,
            "total_salary": 0,
            "selected_product_id": request.args.get("product_id", ""),
        }
    finally:
        if conn:
            conn.close()


@app.route('/buying')
def buying():
    return render_template("operation_page.html", page_kind="buying", **load_operations_context())


@app.route('/production')
def production_page():
    return render_template("operation_page.html", page_kind="production", **load_operations_context())


@app.route('/sales')
def sales_page():
    return render_template("operation_page.html", page_kind="sales", **load_operations_context())


@app.route('/finance')
def finance_page():
    return render_template("operation_page.html", page_kind="finance", **load_operations_context())


@app.route('/module2')
def module2_page():
    return render_template("operation_page.html", page_kind="module2", **load_operations_context())


@app.route('/table/materials')
def table_materials():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM View_Current_Warehouse")
        data = cursor.fetchall()
        return render_template(
            "table_view.html",
            title="Raw Materials Stock",
            page_kind="materials",
            rows=data,
            headers=["Material", "Quantity", "Unit", "Total Value (KGS)", "Status"],
            chart_labels=[str(row[0]).split()[0] for row in data],
            chart_data=[round(_to_number(row[3]) / 1000000, 2) for row in data],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("dashboard"))
    finally:
        if conn:
            conn.close()


@app.route('/table/employees')
def table_employees():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT e.Full_Name, p.Job_Title, e.Salary "
            "FROM Employees e JOIN Positions p ON e.Position_ID = p.ID"
        )
        data = cursor.fetchall()
        return render_template(
            "table_view.html",
            title="Employees",
            page_kind="employees",
            rows=data,
            headers=["Full Name", "Position", "Salary (KGS)"],
            chart_labels=[str(row[0]).split()[0] for row in data],
            chart_data=[_to_number(row[2]) for row in data],
            total_salary=sum(_to_number(row[2]) for row in data),
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("dashboard"))
    finally:
        if conn:
            conn.close()


@app.route('/table/products')
def table_products():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT ID, Name, Quantity, Amount FROM Finished_Products ORDER BY ID")
        data = cursor.fetchall()
        return render_template(
            "table_view.html",
            title="Showroom",
            page_kind="products",
            rows=data,
            headers=["ID", "Model", "In Stock", "Value (KGS)", "Actions"],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("dashboard"))
    finally:
        if conn:
            conn.close()


@app.route('/requests')
def table_requests():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        data = load_production_requests(cursor, limit=100)
        conn.commit()
        return render_template(
            "table_view.html",
            title="Production Requests",
            rows=[
                [
                    item.get("Request_ID"),
                    item.get("Creation_Date"),
                    item.get("Last_Update_Date"),
                    item.get("Status"),
                    item.get("Applicant_Full_Name"),
                    item.get("Product_Name"),
                    item.get("Quantity"),
                    item.get("Rejection_Reason"),
                    item.get("Error_Stage"),
                ]
                for item in data
            ],
            headers=[
                "ID",
                "Created",
                "Updated",
                "Status",
                "Applicant",
                "Product",
                "Qty",
                "Rejection Reason",
                "Error Stage",
            ],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("dashboard"))
    finally:
        if conn:
            conn.close()


@app.route('/production-request', methods=['POST'])
def production_request():
    conn = None
    request_id = None
    current_stage = REQUEST_STATUSES["created"]
    try:
        applicant = (request.form.get("applicant") or "").strip()
        prod_id = parse_positive_int(request.form.get("prod_id"), "product ID")
        qty = parse_positive_int(request.form.get("qty"), "quantity")

        if not applicant:
            raise ValueError("Applicant full name is required.")

        conn = get_db_connection()
        cursor = conn.cursor()
        ensure_production_requests_table(cursor)

        cursor.execute(
            """
            INSERT INTO [Production Requests]
                (Status, Applicant_Full_Name, Finished_Product_ID, Quantity)
            OUTPUT INSERTED.Request_ID
            VALUES (?, ?, ?, ?)
            """,
            (REQUEST_STATUSES["created"], applicant, prod_id, qty),
        )
        request_id = cursor.fetchone()[0]
        conn.commit()

        current_stage = REQUEST_STATUSES["checking"]
        update_production_request(cursor, request_id, REQUEST_STATUSES["checking"])
        recipe = get_product_recipe(cursor, prod_id, qty)
        if not recipe:
            raise ValueError("Recipe is missing for this product.")

        missing_materials = []
        production_cost = 0
        for material_id, name, required_qty, available_qty, unit_cost in recipe:
            required_qty = _to_number(required_qty)
            available_qty = _to_number(available_qty)
            unit_cost = _to_number(unit_cost)
            production_cost += required_qty * unit_cost
            if available_qty < required_qty:
                missing_qty = required_qty - available_qty
                missing_materials.append((material_id, name, missing_qty, unit_cost, missing_qty * unit_cost))

        if missing_materials:
            current_stage = REQUEST_STATUSES["procurement"]
            update_production_request(cursor, request_id, REQUEST_STATUSES["procurement"])
            procurement_cost = round(sum(item[4] for item in missing_materials), 2)
            budget = _to_number(get_budget_value(cursor))
            if budget < procurement_cost:
                raise ValueError(
                    f"Insufficient budget for raw material procurement. Required: {procurement_cost:,.0f} KGS."
                )

            for material_id, _name, missing_qty, _unit_cost, missing_cost in missing_materials:
                purchase_result = call_insert_purchase(cursor, material_id, missing_qty, missing_cost, employee_id=2)
                if purchase_result != 0:
                    raise ValueError(
                        f"Raw material procurement failed for material ID {material_id}. Code: {purchase_result}."
                    )

        current_stage = REQUEST_STATUSES["production"]
        update_production_request(cursor, request_id, REQUEST_STATUSES["production"])
        production_result = execute_with_result(
            cursor,
            """
            DECLARE @result INT, @cost MONEY;
            EXEC dbo.sp_ProduceProduct
                @ProductID=?,
                @Quantity=?,
                @EmployeeID=?,
                @ProductionCost=@cost OUTPUT,
                @Result=@result OUTPUT;
            SELECT @result AS Result, @cost AS ProductionCost;
            """,
            (prod_id, qty, 4),
        )
        production_code = int(production_result.get("Result", 1))
        production_cost = _to_number(production_result.get("ProductionCost"))
        if production_code == 1:
            raise ValueError("Raw materials are still insufficient after procurement.")
        if production_code == 2:
            raise ValueError(f"Insufficient budget for production. Required: {production_cost:,.0f} KGS.")
        if production_code == 3:
            raise ValueError("Recipe is missing for this product.")
        if production_code != 0:
            raise ValueError(f"Production failed. Code: {production_code}.")

        current_stage = REQUEST_STATUSES["sales"]
        update_production_request(cursor, request_id, REQUEST_STATUSES["sales"])
        sale_amount = round(production_cost * 1.3, 2)
        if sale_amount <= 0:
            raise ValueError("Sale failed: production cost could not be calculated.")

        cursor.execute(
            "INSERT INTO Product_Sales (Product_ID, Quantity, Amount, Sale_Date, Employee_ID) "
            "VALUES (?, ?, ?, GETDATE(), 6)",
            (prod_id, qty, sale_amount),
        )

        update_production_request(cursor, request_id, REQUEST_STATUSES["completed"])
        conn.commit()
        flash(f"Production request #{request_id} completed. Sale amount: {sale_amount:,.0f} KGS.", "success")
    except ValueError as e:
        if conn:
            conn.rollback()
            if request_id:
                try:
                    update_production_request(cursor, request_id, REQUEST_STATUSES["error"], str(e), current_stage)
                    conn.commit()
                except pyodbc.Error:
                    conn.rollback()
        flash(str(e), "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
            if request_id:
                try:
                    update_production_request(cursor, request_id, REQUEST_STATUSES["error"], str(e), "Database operation")
                    conn.commit()
                except pyodbc.Error:
                    conn.rollback()
        flash(f"Production request failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("module2_page"))


@app.route('/buy', methods=['POST'])
def buy():
    conn = None
    try:
        mat_id = parse_positive_int(request.form.get("mat_id"), "material ID")
        qty = parse_positive_int(request.form.get("qty"), "quantity")
        amount = parse_positive_int(request.form.get("price"), "amount")

        conn = get_db_connection()
        cursor = conn.cursor()
        result = call_insert_purchase(cursor, mat_id, qty, amount, employee_id=2)
        if result == 1:
            raise ValueError("Purchase failed: not enough budget.")
        if result != 0:
            raise ValueError(f"Purchase failed. Code: {result}.")
        conn.commit()
        flash("Purchase completed!", "success")
    except ValueError as e:
        flash(str(e), "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Purchase failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("buying"))


@app.route('/produce', methods=['POST'])
def produce():
    conn = None
    try:
        prod_id = parse_positive_int(request.form.get("prod_id"), "product ID")
        qty = parse_positive_int(request.form.get("qty"), "quantity")

        conn = get_db_connection()
        cursor = conn.cursor()
        procedure_result = execute_with_result(
            cursor,
            """
            DECLARE @result INT, @cost MONEY;
            EXEC dbo.sp_ProduceProduct
                @ProductID=?,
                @Quantity=?,
                @EmployeeID=?,
                @ProductionCost=@cost OUTPUT,
                @Result=@result OUTPUT;
            SELECT @result AS Result, @cost AS ProductionCost;
            """,
            (prod_id, qty, 4),
        )
        result = int(procedure_result.get("Result", 1))
        production_cost = _to_number(procedure_result.get("ProductionCost"))

        if result == 0:
            conn.commit()
            flash(f"Success: {qty} car(s) assembled. Budget reduced by {production_cost:,.0f} KGS.", "success")
        elif result == 1:
            conn.rollback()
            flash("Production failed: not enough raw materials.", "danger")
        elif result == 2:
            conn.rollback()
            flash(f"Production failed: not enough budget. Required: {production_cost:,.0f} KGS.", "danger")
        elif result == 3:
            conn.rollback()
            flash("Production failed: recipe is missing for this product.", "danger")
        else:
            conn.rollback()
            flash(f"Production failed. Code: {result}.", "danger")
    except ValueError as e:
        flash(str(e), "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Database error during production: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("production_page"))


@app.route('/sell', methods=['POST'])
def sell():
    conn = None
    try:
        prod_id = parse_positive_int(request.form.get("prod_id"), "product ID")
        qty = parse_positive_int(request.form.get("qty"), "quantity")
        unit_price = parse_positive_int(request.form.get("price"), "unit sale price")
        amount = unit_price * qty

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO Product_Sales (Product_ID, Quantity, Amount, Sale_Date, Employee_ID) "
            "VALUES (?, ?, ?, GETDATE(), 6)",
            (prod_id, qty, amount),
        )
        conn.commit()
        flash(f"Sale recorded! Total revenue: {amount:,.0f} KGS.", "info")
    except ValueError as e:
        if conn:
            conn.rollback()
        flash(str(e), "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Sale failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("sales_page"))


@app.route('/sell/rollback/<int:sale_id>', methods=['POST'])
def rollback_sale(sale_id):
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            """
            SELECT COLUMN_NAME
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'Product_Sales'
            """
        )
        sale_columns = [row[0] for row in cursor.fetchall()]
        if not sale_columns:
            raise ValueError("Product_Sales table not found.")

        sale_key = _find_column(sale_columns, ["ID", "Sale_ID", "SaleID"])
        if not sale_key:
            raise ValueError("Sale primary key column not found.")

        cursor.execute(f"SELECT * FROM Product_Sales WHERE {sale_key} = ?", (sale_id,))
        sale_row = cursor.fetchone()
        if not sale_row:
            raise ValueError("Sale not found.")

        row_columns = [c[0] for c in cursor.description]
        sale_data = {row_columns[i]: sale_row[i] for i in range(len(row_columns))}

        status_col = _find_column(row_columns, ["Status", "Sale_Status"])
        canceled_flag_col = _find_column(row_columns, ["Is_Cancelled", "Is_Canceled", "Canceled"])
        if canceled_flag_col and sale_data.get(canceled_flag_col) in (1, True):
            raise ValueError("Sale is already canceled.")
        if status_col and str(sale_data.get(status_col) or "").strip().lower() in ("canceled", "cancelled", "rolled_back"):
            raise ValueError("Sale is already canceled.")

        product_col = _find_column(row_columns, ["Product_ID", "ProductID"])
        qty_col = _find_column(row_columns, ["Quantity", "Qty"])
        amount_col = _find_column(row_columns, ["Amount", "Total_Amount", "Sale_Amount"])

        product_id = sale_data.get(product_col) if product_col else None
        quantity = sale_data.get(qty_col) if qty_col else None
        amount = sale_data.get(amount_col) if amount_col else None

        if product_id is not None and quantity is not None:
            cursor.execute(
                "UPDATE Finished_Products SET Quantity = Quantity + ? WHERE ID = ?",
                (quantity, product_id),
            )

        if amount is not None:
            cursor.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Budget' AND COLUMN_NAME='Budget_Amount'")
            has_budget_amount = cursor.fetchone()[0] > 0
            if has_budget_amount:
                cursor.execute(
                    "UPDATE Budget SET Budget_Amount = Budget_Amount - ? WHERE ID = 1",
                    (amount,),
                )

        reason = (request.form.get("reason") or "").strip()
        employee_id = 6

        updates = []
        params = []
        if canceled_flag_col:
            updates.append(f"{canceled_flag_col} = 1")
        if status_col:
            updates.append(f"{status_col} = ?")
            params.append("Canceled")

        reason_col = _find_column(row_columns, ["Cancel_Reason", "Cancellation_Reason", "Rollback_Reason"])
        if reason and reason_col:
            updates.append(f"{reason_col} = ?")
            params.append(reason)

        canceled_by_col = _find_column(row_columns, ["Canceled_By", "Cancelled_By", "Rollback_By"])
        if canceled_by_col:
            updates.append(f"{canceled_by_col} = ?")
            params.append(employee_id)

        canceled_at_col = _find_column(row_columns, ["Canceled_At", "Cancelled_At", "Rollback_At"])
        if canceled_at_col:
            updates.append(f"{canceled_at_col} = GETDATE()")

        if updates:
            params.append(sale_id)
            cursor.execute(f"UPDATE Product_Sales SET {', '.join(updates)} WHERE {sale_key} = ?", params)
        else:
            cursor.execute(f"DELETE FROM Product_Sales WHERE {sale_key} = ?", (sale_id,))

        conn.commit()
        flash(f"Sale #{sale_id} rollback completed.", "success")
    except ValueError as e:
        if conn:
            conn.rollback()
        flash(str(e), "warning")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Rollback failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("sales_page"))


@app.route('/pay_salaries')
def pay_salaries():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        procedure_result = execute_with_result(
            cursor,
            """
            DECLARE @result INT;
            EXEC dbo.sp_PaySalaries @Result=@result OUTPUT;
            SELECT @result AS Result;
            """
        )
        result = int(procedure_result.get("Result", 1))
        if result == 0:
            conn.commit()
            flash("Salaries paid!", "success")
        else:
            conn.rollback()
            flash("Payroll failed: not enough funds.", "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Payroll error: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("finance_page"))


@app.route('/loan', methods=['POST'])
def loan():
    conn = None
    try:
        bank = (request.form.get("bank") or "").strip()
        amount = parse_positive_int(request.form.get("amount"), "loan amount")

        if not bank:
            raise ValueError("Bank name is required.")

        conn = get_db_connection()
        cursor = conn.cursor()
        procedure_result = execute_with_result(
            cursor,
            """
            DECLARE @result INT;
            EXEC dbo.sp_GetLoan @BankName=?, @Amount=?, @Rate=?, @Result=@result OUTPUT;
            SELECT @result AS Result;
            """,
            (bank, amount, 10.5),
        )
        result = int(procedure_result.get("Result", 1))
        if result == 0:
            conn.commit()
            flash("Loan received!", "warning")
        else:
            conn.rollback()
            flash("Loan request failed: invalid bank or amount.", "danger")
    except ValueError as e:
        flash(str(e), "danger")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Loan request failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("finance_page"))


@app.route('/loan/repay/<int:loan_id>', methods=['POST'])
def repay_loan(loan_id):
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT ID, Bank_Name, Loan_Amount, Interest_Rate, Loan_Date, Status FROM Business_Loans WHERE ID = ?",
            (loan_id,),
        )
        row = cursor.fetchone()
        if not row:
            raise ValueError("Loan not found.")

        status = str(row[5] or "").strip().lower()
        if status and status != "active":
            raise ValueError("Loan is already closed.")

        principal = _to_number(row[2])
        rate = _to_number(row[3])
        total_due = round(principal * (1 + rate / 100), 2)
        budget = _to_number(get_budget_value(cursor))

        if budget < total_due:
            raise ValueError(f"Not enough budget to repay this loan. Required: {total_due:,.0f} KGS.")

        cursor.execute("UPDATE Budget SET Budget_Amount = Budget_Amount - ? WHERE ID = 1", (total_due,))
        cursor.execute("UPDATE Business_Loans SET Status = ? WHERE ID = ?", ("Repaid", loan_id))
        conn.commit()
        flash(f"Loan #{loan_id} repaid successfully. Total paid: {total_due:,.0f} KGS.", "success")
    except ValueError as e:
        if conn:
            conn.rollback()
        flash(str(e), "warning")
    except pyodbc.Error as e:
        if conn:
            conn.rollback()
        flash(f"Loan repayment failed: {str(e)}", "danger")
    finally:
        if conn:
            conn.close()

    return redirect(url_for("finance_page"))


@app.route('/reports')
def reports():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        prod_records = load_production_report(cursor)
        sales_records = load_sales_report(cursor)
        salary_records = load_salary_report(cursor)
        loan_records = load_loans_report(cursor)

        charts = build_report_hub_charts(prod_records, sales_records, loan_records)
        summary_cards = [
            {
                "label": "Total cars produced",
                "value": f"{sum(_to_number(item.get('Qty')) for item in prod_records):,.0f}",
                "note": "From production history",
            },
            {
                "label": "Total revenue",
                "value": f"{sum(_to_number(item.get('Revenue')) for item in sales_records):,.0f} KGS",
                "note": "From sales summary",
            },
            {
                "label": "Salary payouts",
                "value": f"{sum(_to_number(item.get('Amount')) for item in salary_records):,.0f} KGS",
                "note": "Paid to employees",
            },
            {
                "label": "Active loans",
                "value": str(sum(1 for item in loan_records if str(item.get('Status') or '').lower() == 'active')),
                "note": "Loans requiring repayment",
            },
        ]
        report_links = [
            {
                "title": "Production Report",
                "description": "Assembly history, quantities by date, and the most active car models.",
                "href": url_for("reports_production"),
                "count": len(prod_records),
                "accent": "production",
            },
            {
                "title": "Sales Report",
                "description": "Revenue dynamics, sold quantities, and the strongest product lines.",
                "href": url_for("reports_sales"),
                "count": len(sales_records),
                "accent": "sales",
            },
            {
                "title": "Salary Report",
                "description": "Payroll timeline and distribution across employees and positions.",
                "href": url_for("reports_salaries"),
                "count": len(salary_records),
                "accent": "salary",
            },
            {
                "title": "Loan Report",
                "description": "Active and repaid loans, repayment amounts, and bank exposure.",
                "href": url_for("reports_loans"),
                "count": len(loan_records),
                "accent": "loans",
            },
        ]
        return render_template(
            "reports.html",
            charts=charts,
            summary_cards=summary_cards,
            report_links=report_links,
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return render_template("reports.html", charts=[], summary_cards=[], report_links=[])
    finally:
        if conn:
            conn.close()


@app.route('/reports/production')
def reports_production():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        records = load_production_report(cursor)
        charts = build_production_charts(records)
        summary_cards = [
            {"label": "Total production records", "value": str(len(records)), "note": "Rows in the production log"},
            {"label": "Cars assembled", "value": f"{sum(_to_number(r.get('Qty')) for r in records):,.0f}", "note": "Total quantity produced"},
        ]
        return render_template(
            "report_detail.html",
            page_title="Production Report",
            report_title="Production Report",
            report_subtitle="Detailed production history with visual trends by date and by model.",
            summary_cards=summary_cards,
            charts=charts,
            table_headers=["Date", "Model", "Qty", "Responsible"],
            table_rows=[[r.get("Date"), r.get("Model"), r.get("Qty"), r.get("Responsible")] for r in records],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("reports"))
    finally:
        if conn:
            conn.close()


@app.route('/reports/sales')
def reports_sales():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        records = load_sales_report(cursor)
        charts = build_sales_charts(records)
        summary_cards = [
            {"label": "Sales records", "value": str(len(records)), "note": "Rows in sales analytics"},
            {"label": "Total revenue", "value": f"{sum(_to_number(r.get('Revenue')) for r in records):,.0f} KGS", "note": "Gross sales amount"},
        ]
        return render_template(
            "report_detail.html",
            page_title="Sales Report",
            report_title="Sales Report",
            report_subtitle="Revenue, sold quantities, and product performance in one place.",
            summary_cards=summary_cards,
            charts=charts,
            table_headers=["Date", "Car Model", "Sold Qty", "Revenue", "Sales Manager"],
            table_rows=[[r.get("Date of Sale"), r.get("Car Model"), r.get("Sold Qty"), r.get("Revenue"), r.get("Sales Manager")] for r in records],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("reports"))
    finally:
        if conn:
            conn.close()


@app.route('/reports/salaries')
def reports_salaries():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        records = load_salary_report(cursor)
        charts = build_salary_charts(records)
        summary_cards = [
            {"label": "Payroll entries", "value": str(len(records)), "note": "Rows in salary history"},
            {"label": "Total paid", "value": f"{sum(_to_number(r.get('Amount')) for r in records):,.0f} KGS", "note": "Overall payroll amount"},
        ]
        return render_template(
            "report_detail.html",
            page_title="Salary Report",
            report_title="Salary Report",
            report_subtitle="Payroll history, cash outflow trend, and the largest salary totals.",
            summary_cards=summary_cards,
            charts=charts,
            table_headers=["Date", "Employee", "Position", "Amount"],
            table_rows=[[r.get("Date"), r.get("Employee"), r.get("Position"), r.get("Amount")] for r in records],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("reports"))
    finally:
        if conn:
            conn.close()


@app.route('/reports/loans')
def reports_loans():
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        records = load_loans_report(cursor)
        charts = build_loan_charts(records)
        summary_cards = [
            {"label": "Loan records", "value": str(len(records)), "note": "Active and repaid loans"},
            {"label": "Total borrowed", "value": f"{sum(_to_number(r.get('Loan_Amount')) for r in records):,.0f} KGS", "note": "Principal across all loans"},
            {"label": "Total due", "value": f"{sum(_to_number(r.get('Total_Due')) for r in records):,.0f} KGS", "note": "Principal plus interest"},
        ]
        return render_template(
            "report_detail.html",
            page_title="Loan Report",
            report_title="Loan Report",
            report_subtitle="Loan portfolio, repayment burden, and status distribution by bank.",
            summary_cards=summary_cards,
            charts=charts,
            table_headers=["ID", "Bank", "Loan Amount", "Rate %", "Date", "Status", "Total Due"],
            table_rows=[
                [
                    r.get("ID"),
                    r.get("Bank_Name"),
                    r.get("Loan_Amount"),
                    r.get("Interest_Rate"),
                    r.get("Loan_Date"),
                    r.get("Status"),
                    r.get("Total_Due"),
                ]
                for r in records
            ],
        )
    except pyodbc.Error as e:
        flash(f"Database error: {str(e)}", "danger")
        return redirect(url_for("reports"))
    finally:
        if conn:
            conn.close()


if __name__ == "__main__":
    app.run(debug=True)
