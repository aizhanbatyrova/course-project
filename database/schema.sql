IF DB_ID(N'CarManufacturing') IS NULL
    CREATE DATABASE [CarManufacturing];
GO

USE [CarManufacturing];
GO

IF OBJECT_ID(N'[dbo].[Production Requests]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Production Requests] (
    [Request_ID] int IDENTITY(1,1) NOT NULL,
    [Creation_Date] datetime CONSTRAINT [DF_Production_Requests_Creation_Date] DEFAULT (getdate()) NOT NULL,
    [Last_Update_Date] datetime CONSTRAINT [DF_Production_Requests_Last_Update_Date] DEFAULT (getdate()) NOT NULL,
    [Status] nvarchar(100) NOT NULL,
    [Applicant_Full_Name] nvarchar(200) NOT NULL,
    [Finished_Product_ID] int NOT NULL,
    [Quantity] int CONSTRAINT [DF_Production_Requests_Quantity] DEFAULT ((1)) NOT NULL,
    [Rejection_Reason] nvarchar(500) NULL,
    [Error_Stage] nvarchar(100) NULL,
    CONSTRAINT [PK__Producti__E9C5B293AEC4F894] PRIMARY KEY ([Request_ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Units_of_Measurement]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Units_of_Measurement] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(50) NOT NULL,
    CONSTRAINT [PK__Units_of__3214EC2712B9E9D7] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Positions]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Positions] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Job_Title] nvarchar(100) NOT NULL,
    CONSTRAINT [PK__Position__3214EC2775954671] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Budget]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Budget] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Budget_Amount] money NOT NULL,
    CONSTRAINT [PK__Budget__3214EC2754FC657A] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Employees]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Employees] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Full_Name] nvarchar(255) NOT NULL,
    [Position_ID] int NULL,
    [Salary] money NULL,
    [Address] nvarchar(MAX) NULL,
    [Phone_Number] nvarchar(20) NULL,
    CONSTRAINT [PK__Employee__3214EC27F3F4C425] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Raw_Materials]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Raw_Materials] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(255) NOT NULL,
    [Unit_ID] int NULL,
    [Quantity] float CONSTRAINT [DF_Raw_Materials_Quantity] DEFAULT ((0)) NULL,
    [Amount] money CONSTRAINT [DF_Raw_Materials_Amount] DEFAULT ((0)) NULL,
    CONSTRAINT [PK__Raw_Mate__3214EC270503DB6D] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Finished_Products]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Finished_Products] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(255) NOT NULL,
    [Unit_ID] int NULL,
    [Quantity] float CONSTRAINT [DF_Finished_Products_Quantity] DEFAULT ((0)) NULL,
    [Amount] money CONSTRAINT [DF_Finished_Products_Amount] DEFAULT ((0)) NULL,
    CONSTRAINT [PK__Finished__3214EC27861B6097] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Ingredients]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Ingredients] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Product_ID] int NULL,
    [Raw_Material_ID] int NULL,
    [Quantity] float NOT NULL,
    CONSTRAINT [PK__Ingredie__3214EC276AEBFD55] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Raw_Material_Purchases]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Raw_Material_Purchases] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Raw_Material_ID] int NULL,
    [Quantity] float NOT NULL,
    [Amount] money NOT NULL,
    [Purchase_Date] datetime CONSTRAINT [DF_Raw_Material_Purchases_Purchase_Date] DEFAULT (getdate()) NULL,
    [Employee_ID] int NULL,
    CONSTRAINT [PK__Raw_Mate__3214EC27AD0B0B18] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Product_Production]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Product_Production] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Product_ID] int NULL,
    [Quantity] float NOT NULL,
    [Prod_Date] datetime CONSTRAINT [DF_Product_Production_Prod_Date] DEFAULT (getdate()) NULL,
    [Employee_ID] int NULL,
    CONSTRAINT [PK__Product___3214EC27BF8BD7A9] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Product_Sales]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Product_Sales] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Product_ID] int NULL,
    [Quantity] float NOT NULL,
    [Amount] money NOT NULL,
    [Sale_Date] datetime CONSTRAINT [DF_Product_Sales_Sale_Date] DEFAULT (getdate()) NULL,
    [Employee_ID] int NULL,
    CONSTRAINT [PK__Product___3214EC278CA6682B] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Salary_Payments]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Salary_Payments] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Employee_ID] int NULL,
    [Amount] money NULL,
    [Payment_Date] datetime CONSTRAINT [DF_Salary_Payments_Payment_Date] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK__Salary_P__3214EC270105EA14] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[dbo].[Business_Loans]', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Business_Loans] (
    [ID] int IDENTITY(1,1) NOT NULL,
    [Bank_Name] nvarchar(100) NULL,
    [Loan_Amount] money NULL,
    [Interest_Rate] float NULL,
    [Loan_Date] datetime CONSTRAINT [DF_Business_Loans_Loan_Date] DEFAULT (getdate()) NULL,
    [Status] nvarchar(50) CONSTRAINT [DF_Business_Loans_Status] DEFAULT ('Active') NULL,
    CONSTRAINT [PK__Business__3214EC277B139337] PRIMARY KEY ([ID])
);
END
GO

IF OBJECT_ID(N'[FK__Employees__Posit__164452B1]', N'F') IS NULL
    ALTER TABLE [dbo].[Employees] ADD CONSTRAINT [FK__Employees__Posit__164452B1] FOREIGN KEY ([Position_ID]) REFERENCES [dbo].[Positions] ([ID]);
GO

IF OBJECT_ID(N'[FK__Finished___Unit___1DE57479]', N'F') IS NULL
    ALTER TABLE [dbo].[Finished_Products] ADD CONSTRAINT [FK__Finished___Unit___1DE57479] FOREIGN KEY ([Unit_ID]) REFERENCES [dbo].[Units_of_Measurement] ([ID]);
GO

IF OBJECT_ID(N'[FK__Ingredien__Produ__22AA2996]', N'F') IS NULL
    ALTER TABLE [dbo].[Ingredients] ADD CONSTRAINT [FK__Ingredien__Produ__22AA2996] FOREIGN KEY ([Product_ID]) REFERENCES [dbo].[Finished_Products] ([ID]);
GO

IF OBJECT_ID(N'[FK__Ingredien__Raw_M__239E4DCF]', N'F') IS NULL
    ALTER TABLE [dbo].[Ingredients] ADD CONSTRAINT [FK__Ingredien__Raw_M__239E4DCF] FOREIGN KEY ([Raw_Material_ID]) REFERENCES [dbo].[Raw_Materials] ([ID]);
GO

IF OBJECT_ID(N'[FK__Product_P__Emplo__2D27B809]', N'F') IS NULL
    ALTER TABLE [dbo].[Product_Production] ADD CONSTRAINT [FK__Product_P__Emplo__2D27B809] FOREIGN KEY ([Employee_ID]) REFERENCES [dbo].[Employees] ([ID]);
GO

IF OBJECT_ID(N'[FK__Product_P__Produ__2B3F6F97]', N'F') IS NULL
    ALTER TABLE [dbo].[Product_Production] ADD CONSTRAINT [FK__Product_P__Produ__2B3F6F97] FOREIGN KEY ([Product_ID]) REFERENCES [dbo].[Finished_Products] ([ID]);
GO

IF OBJECT_ID(N'[FK__Product_S__Emplo__31EC6D26]', N'F') IS NULL
    ALTER TABLE [dbo].[Product_Sales] ADD CONSTRAINT [FK__Product_S__Emplo__31EC6D26] FOREIGN KEY ([Employee_ID]) REFERENCES [dbo].[Employees] ([ID]);
GO

IF OBJECT_ID(N'[FK__Product_S__Produ__300424B4]', N'F') IS NULL
    ALTER TABLE [dbo].[Product_Sales] ADD CONSTRAINT [FK__Product_S__Produ__300424B4] FOREIGN KEY ([Product_ID]) REFERENCES [dbo].[Finished_Products] ([ID]);
GO

IF OBJECT_ID(N'[FK__Raw_Mater__Emplo__286302EC]', N'F') IS NULL
    ALTER TABLE [dbo].[Raw_Material_Purchases] ADD CONSTRAINT [FK__Raw_Mater__Emplo__286302EC] FOREIGN KEY ([Employee_ID]) REFERENCES [dbo].[Employees] ([ID]);
GO

IF OBJECT_ID(N'[FK__Raw_Mater__Raw_M__267ABA7A]', N'F') IS NULL
    ALTER TABLE [dbo].[Raw_Material_Purchases] ADD CONSTRAINT [FK__Raw_Mater__Raw_M__267ABA7A] FOREIGN KEY ([Raw_Material_ID]) REFERENCES [dbo].[Raw_Materials] ([ID]);
GO

IF OBJECT_ID(N'[FK__Raw_Mater__Unit___1920BF5C]', N'F') IS NULL
    ALTER TABLE [dbo].[Raw_Materials] ADD CONSTRAINT [FK__Raw_Mater__Unit___1920BF5C] FOREIGN KEY ([Unit_ID]) REFERENCES [dbo].[Units_of_Measurement] ([ID]);
GO

IF OBJECT_ID(N'[FK__Salary_Pa__Emplo__5CD6CB2B]', N'F') IS NULL
    ALTER TABLE [dbo].[Salary_Payments] ADD CONSTRAINT [FK__Salary_Pa__Emplo__5CD6CB2B] FOREIGN KEY ([Employee_ID]) REFERENCES [dbo].[Employees] ([ID]);
GO

IF OBJECT_ID(N'[FK_ProductionRequests_FinishedProducts]', N'F') IS NULL
    ALTER TABLE [dbo].[Production Requests] ADD CONSTRAINT [FK_ProductionRequests_FinishedProducts] FOREIGN KEY ([Finished_Product_ID]) REFERENCES [dbo].[Finished_Products] ([ID]);
GO

IF OBJECT_ID(N'[dbo].[View_Current_Warehouse]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Current_Warehouse];
GO
CREATE VIEW View_Current_Warehouse AS
SELECT 
    rm.Name AS [Part Name],
    rm.Quantity AS [Available Quantity],
    u.Name AS [Measure Unit],
    rm.Amount AS [Total Asset Value]
FROM Raw_Materials rm
JOIN Units_of_Measurement u ON rm.Unit_ID = u.ID;

GO

IF OBJECT_ID(N'[dbo].[View_Employee_List]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Employee_List];
GO
CREATE VIEW View_Employee_List AS
SELECT 
    e.Full_Name AS [Employee],
    pos.Job_Title AS [Position],
    e.Salary AS [Monthly Salary],
    e.Phone_Number AS [Contact]
FROM Employees e
JOIN Positions pos ON e.Position_ID = pos.ID;

GO

IF OBJECT_ID(N'[dbo].[View_Product_Ingredients]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Product_Ingredients];
GO
CREATE VIEW View_Product_Ingredients AS
SELECT 
    p.Name AS [Car Model],
    rm.Name AS [Material Needed],
    i.Quantity AS [Required Amount],
    u.Name AS [Unit]
FROM Finished_Products p
JOIN Ingredients i ON p.ID = i.Product_ID
JOIN Raw_Materials rm ON i.Raw_Material_ID = rm.ID
JOIN Units_of_Measurement u ON rm.Unit_ID = u.ID;

GO

IF OBJECT_ID(N'[dbo].[View_Production_Log]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Production_Log];
GO

CREATE VIEW [dbo].[View_Production_Log]
AS
SELECT 
    pp.Prod_Date AS [Date],
    fp.Name AS [Model],
    pp.Quantity AS [Qty],
    e.Full_Name AS [Responsible]
FROM Product_Production pp
JOIN Finished_Products fp ON pp.Product_ID = fp.ID
JOIN Employees e ON pp.Employee_ID = e.ID

GO

IF OBJECT_ID(N'[dbo].[View_Purchase_Details]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Purchase_Details];
GO
CREATE VIEW View_Purchase_Details AS
SELECT 
    rp.Purchase_Date AS [Date],
    rm.Name AS [Material Purchased],
    rp.Quantity AS [Qty],
    rp.Amount AS [Total Cost],
    e.Full_Name AS [Purchasing Manager]
FROM Raw_Material_Purchases rp
JOIN Raw_Materials rm ON rp.Raw_Material_ID = rm.ID
JOIN Employees e ON rp.Employee_ID = e.ID;

GO

IF OBJECT_ID(N'[dbo].[View_Sales_Summary]', N'V') IS NOT NULL
    DROP VIEW [dbo].[View_Sales_Summary];
GO
CREATE VIEW View_Sales_Summary AS
SELECT 
    s.Sale_Date AS [Date of Sale],
    p.Name AS [Car Model],
    s.Quantity AS [Sold Qty],
    s.Amount AS [Revenue],
    e.Full_Name AS [Sales Manager]
FROM Product_Sales s
JOIN Finished_Products p ON s.Product_ID = p.ID
JOIN Employees e ON s.Employee_ID = e.ID;

GO

IF OBJECT_ID(N'[dbo].[sp_CheckBudget]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_CheckBudget];
GO
CREATE PROCEDURE dbo.sp_CheckBudget
    @PurchaseAmount MONEY,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PurchaseAmount IS NULL OR @PurchaseAmount < 0
    BEGIN
        SET @Result = 1;
        SELECT @Result AS Result;
        RETURN;
    END;

    IF COALESCE((SELECT Budget_Amount FROM dbo.Budget WHERE ID = 1), 0) >= @PurchaseAmount
        SET @Result = 0;
    ELSE
        SET @Result = 1;

    SELECT @Result AS Result;
END
GO

IF OBJECT_ID(N'[dbo].[sp_GetLoan]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_GetLoan];
GO
CREATE PROCEDURE dbo.sp_GetLoan
    @BankName NVARCHAR(100),
    @Amount MONEY,
    @Rate FLOAT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NULLIF(LTRIM(RTRIM(@BankName)), '') IS NULL OR @Amount IS NULL OR @Amount <= 0
    BEGIN
        SET @Result = 1;
        SELECT @Result AS Result;
        RETURN;
    END;

    INSERT INTO dbo.Business_Loans (Bank_Name, Loan_Amount, Interest_Rate, Loan_Date, Status)
    VALUES (@BankName, @Amount, @Rate, GETDATE(), 'Active');

    UPDATE dbo.Budget SET Budget_Amount = Budget_Amount + @Amount WHERE ID = 1;

    SET @Result = 0;
    SELECT @Result AS Result;
END
GO

IF OBJECT_ID(N'[dbo].[sp_InsertPurchase]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_InsertPurchase];
GO
CREATE PROCEDURE dbo.sp_InsertPurchase
    @MaterialID INT,
    @Qty FLOAT,
    @Amount MONEY,
    @EmpID INT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Qty IS NULL OR @Qty <= 0 OR @Amount IS NULL OR @Amount <= 0
    BEGIN
        SET @Result = 2;
        SELECT @Result AS Result;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Raw_Materials WHERE ID = @MaterialID)
    BEGIN
        SET @Result = 3;
        SELECT @Result AS Result;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE ID = @EmpID)
    BEGIN
        SET @Result = 4;
        SELECT @Result AS Result;
        RETURN;
    END;

    DECLARE @BudgetCheck INT;
    EXEC dbo.sp_CheckBudget @Amount, @BudgetCheck OUTPUT;

    IF @BudgetCheck = 0
    BEGIN
        INSERT INTO dbo.Raw_Material_Purchases (Raw_Material_ID, Quantity, Amount, Purchase_Date, Employee_ID)
        VALUES (@MaterialID, @Qty, @Amount, GETDATE(), @EmpID);
        SET @Result = 0;
    END
    ELSE
        SET @Result = 1;

    SELECT @Result AS Result;
END
GO

IF OBJECT_ID(N'[dbo].[sp_PaySalaries]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_PaySalaries];
GO
CREATE PROCEDURE dbo.sp_PaySalaries
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TotalSalary MONEY;
    SELECT @TotalSalary = COALESCE(SUM(Salary), 0) FROM dbo.Employees;

    DECLARE @BudgetCheck INT;
    EXEC dbo.sp_CheckBudget @TotalSalary, @BudgetCheck OUTPUT;

    IF @BudgetCheck = 0
    BEGIN
        UPDATE dbo.Budget SET Budget_Amount = Budget_Amount - @TotalSalary WHERE ID = 1;
        INSERT INTO dbo.Salary_Payments (Employee_ID, Amount, Payment_Date)
        SELECT ID, Salary, GETDATE() FROM dbo.Employees;
        SET @Result = 0;
    END
    ELSE
        SET @Result = 1;

    SELECT @Result AS Result, @TotalSalary AS TotalSalary;
END
GO

IF OBJECT_ID(N'[dbo].[sp_ProduceProduct]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ProduceProduct];
GO
CREATE PROCEDURE dbo.sp_ProduceProduct
    @ProductID INT,
    @Quantity INT,
    @EmployeeID INT,
    @ProductionCost MONEY OUTPUT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @ProductionCost = 0;

    IF @Quantity IS NULL OR @Quantity <= 0
    BEGIN
        SET @Result = 4;
        SELECT @Result AS Result, @ProductionCost AS ProductionCost;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Finished_Products WHERE ID = @ProductID)
    BEGIN
        SET @Result = 5;
        SELECT @Result AS Result, @ProductionCost AS ProductionCost;
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Ingredients WHERE Product_ID = @ProductID)
    BEGIN
        SET @Result = 3;
        SELECT @Result AS Result, @ProductionCost AS ProductionCost;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM dbo.Ingredients i
        JOIN dbo.Raw_Materials rm ON i.Raw_Material_ID = rm.ID
        WHERE i.Product_ID = @ProductID
          AND COALESCE(rm.Quantity, 0) < i.Quantity * @Quantity
    )
    BEGIN
        SET @Result = 1;
        SELECT @Result AS Result, @ProductionCost AS ProductionCost;
        RETURN;
    END;

    SET @ProductionCost = dbo.fn_CalculateProductionCost(@ProductID, @Quantity);

    DECLARE @BudgetCheck INT;
    EXEC dbo.sp_CheckBudget @ProductionCost, @BudgetCheck OUTPUT;

    IF @BudgetCheck = 1
    BEGIN
        SET @Result = 2;
        SELECT @Result AS Result, @ProductionCost AS ProductionCost;
        RETURN;
    END;

    UPDATE rm
    SET rm.Quantity = rm.Quantity - i.Quantity * @Quantity,
        rm.Amount = CASE
            WHEN rm.Amount - (i.Quantity * @Quantity * CASE WHEN rm.Quantity > 0 THEN rm.Amount / rm.Quantity ELSE 0 END) < 0 THEN 0
            ELSE rm.Amount - (i.Quantity * @Quantity * CASE WHEN rm.Quantity > 0 THEN rm.Amount / rm.Quantity ELSE 0 END)
        END
    FROM dbo.Raw_Materials rm
    JOIN dbo.Ingredients i ON rm.ID = i.Raw_Material_ID
    WHERE i.Product_ID = @ProductID;

    UPDATE dbo.Budget
    SET Budget_Amount = Budget_Amount - @ProductionCost
    WHERE ID = 1;

    UPDATE dbo.Finished_Products
    SET Quantity = COALESCE(Quantity, 0) + @Quantity,
        Amount = COALESCE(Amount, 0) + @ProductionCost
    WHERE ID = @ProductID;

    INSERT INTO dbo.Product_Production (Product_ID, Quantity, Prod_Date, Employee_ID)
    VALUES (@ProductID, @Quantity, GETDATE(), @EmployeeID);

    SET @Result = 0;
    SELECT @Result AS Result, @ProductionCost AS ProductionCost;
END
GO

IF OBJECT_ID(N'[dbo].[trg_AfterSale]', N'TR') IS NOT NULL
    DROP TRIGGER [dbo].[trg_AfterSale];
GO
CREATE TRIGGER dbo.trg_AfterSale
ON dbo.Product_Sales
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity <= 0 OR Amount <= 0)
    BEGIN
        RAISERROR('Sale quantity and amount must be greater than zero.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM (
            SELECT Product_ID, SUM(Quantity) AS Quantity
            FROM inserted
            GROUP BY Product_ID
        ) s
        JOIN dbo.Finished_Products fp ON fp.ID = s.Product_ID
        WHERE COALESCE(fp.Quantity, 0) < s.Quantity
    )
    BEGIN
        RAISERROR('Insufficient finished product stock for sale.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE fp
    SET fp.Quantity = fp.Quantity - s.Quantity
    FROM dbo.Finished_Products fp
    JOIN (
        SELECT Product_ID, SUM(Quantity) AS Quantity
        FROM inserted
        GROUP BY Product_ID
    ) s ON s.Product_ID = fp.ID;

    UPDATE dbo.Budget
    SET Budget_Amount = Budget_Amount + (SELECT SUM(Amount) FROM inserted)
    WHERE ID = 1;
END
GO

IF OBJECT_ID(N'[dbo].[trg_RawMaterialPurchase]', N'TR') IS NOT NULL
    DROP TRIGGER [dbo].[trg_RawMaterialPurchase];
GO
CREATE TRIGGER dbo.trg_RawMaterialPurchase
ON dbo.Raw_Material_Purchases
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE Quantity <= 0 OR Amount <= 0)
    BEGIN
        RAISERROR('Purchase quantity and amount must be greater than zero.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    DECLARE @TotalAmount MONEY;
    SELECT @TotalAmount = SUM(Amount) FROM inserted;

    IF (SELECT Budget_Amount FROM dbo.Budget WHERE ID = 1) < @TotalAmount
    BEGIN
        RAISERROR('Insufficient budget for raw material purchase.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE dbo.Budget
    SET Budget_Amount = Budget_Amount - @TotalAmount
    WHERE ID = 1;

    UPDATE rm
    SET rm.Quantity = COALESCE(rm.Quantity, 0) + x.Quantity,
        rm.Amount = COALESCE(rm.Amount, 0) + x.Amount
    FROM dbo.Raw_Materials rm
    JOIN (
        SELECT Raw_Material_ID, SUM(Quantity) AS Quantity, SUM(Amount) AS Amount
        FROM inserted
        GROUP BY Raw_Material_ID
    ) x ON x.Raw_Material_ID = rm.ID;
END
GO
