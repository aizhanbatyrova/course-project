USE [CarManufacturing];
GO

DISABLE TRIGGER ALL ON [dbo].[Units_of_Measurement];
GO

DISABLE TRIGGER ALL ON [dbo].[Positions];
GO

DISABLE TRIGGER ALL ON [dbo].[Employees];
GO

DISABLE TRIGGER ALL ON [dbo].[Budget];
GO

DISABLE TRIGGER ALL ON [dbo].[Raw_Materials];
GO

DISABLE TRIGGER ALL ON [dbo].[Finished_Products];
GO

DISABLE TRIGGER ALL ON [dbo].[Ingredients];
GO

DISABLE TRIGGER ALL ON [dbo].[Raw_Material_Purchases];
GO

DISABLE TRIGGER ALL ON [dbo].[Product_Production];
GO

DISABLE TRIGGER ALL ON [dbo].[Product_Sales];
GO

DISABLE TRIGGER ALL ON [dbo].[Business_Loans];
GO

DISABLE TRIGGER ALL ON [dbo].[Salary_Payments];
GO

DISABLE TRIGGER ALL ON [dbo].[Production Requests];
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Units_of_Measurement])
BEGIN
    SET IDENTITY_INSERT [dbo].[Units_of_Measurement] ON;
    INSERT INTO [dbo].[Units_of_Measurement] ([ID], [Name]) VALUES (1, N'kg');
    INSERT INTO [dbo].[Units_of_Measurement] ([ID], [Name]) VALUES (2, N'pcs');
    INSERT INTO [dbo].[Units_of_Measurement] ([ID], [Name]) VALUES (3, N'liters');
    INSERT INTO [dbo].[Units_of_Measurement] ([ID], [Name]) VALUES (4, N'set');
    INSERT INTO [dbo].[Units_of_Measurement] ([ID], [Name]) VALUES (5, N'm2');
    SET IDENTITY_INSERT [dbo].[Units_of_Measurement] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Positions])
BEGIN
    SET IDENTITY_INSERT [dbo].[Positions] ON;
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (1, N'Chief Executive Officer');
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (2, N'Chief Engineer');
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (3, N'Workshop Supervisor');
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (4, N'Procurement Manager');
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (5, N'Auto Mechanic');
    INSERT INTO [dbo].[Positions] ([ID], [Job_Title]) VALUES (6, N'Sales Manager');
    SET IDENTITY_INSERT [dbo].[Positions] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Employees])
BEGIN
    SET IDENTITY_INSERT [dbo].[Employees] ON;
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (1, N'Peter Ivanov', 1, 250000.0000, N'Москва, ул. Тверская 1', N'89161112233');
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (2, N'Anna Smirnova', 4, 95000.0000, N'Москва, ул. Лесная 45', N'89164445566');
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (3, N'Oleg Kuznetsov', 2, 180000.0000, N'Химки, ул. Заводская 10', N'89167778899');
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (4, N'Maxim Lebedev', 3, 110000.0000, N'Люберцы, ул. Южная 2', N'89160001122');
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (5, N'Dmitry Popov', 5, 85000.0000, N'Москва, ул. Полевая 8', N'89163334455');
    INSERT INTO [dbo].[Employees] ([ID], [Full_Name], [Position_ID], [Salary], [Address], [Phone_Number]) VALUES (6, N'Elena Sokolova', 6, 90000.0000, N'Москва, ул. Новая 15', N'89166667788');
    SET IDENTITY_INSERT [dbo].[Employees] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Budget])
BEGIN
    SET IDENTITY_INSERT [dbo].[Budget] ON;
    INSERT INTO [dbo].[Budget] ([ID], [Budget_Amount]) VALUES (1, 10456489.9756);
    SET IDENTITY_INSERT [dbo].[Budget] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Raw_Materials])
BEGIN
    SET IDENTITY_INSERT [dbo].[Raw_Materials] ON;
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (1, N'Body', 1, 8.0, 508121.1636);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (2, N'Transmission', 2, 10.0, 51550000.0000);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (3, N'Engine', 2, 3.0, 803000.0000);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (4, N'Wheels', 4, 3.0, 558000.0000);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (5, N'Interior', 5, 2.0, 192200.0000);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (6, N'Electronics', 2, 8.0, 577037.0370);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (7, N'Suspension', 3, 0.0, 0.0000);
    INSERT INTO [dbo].[Raw_Materials] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (8, N'Brakes', 5, 8.0, 290909.0909);
    SET IDENTITY_INSERT [dbo].[Raw_Materials] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Finished_Products])
BEGIN
    SET IDENTITY_INSERT [dbo].[Finished_Products] ON;
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (1, N'Business-S Sedan', 2, 1.0, 12151550.1562);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (2, N'Storm Crossover', 2, 4.0, 60000.0000);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (3, N'Lightning Electric Car', 2, 5.0, 4437104.6411);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (4, N'Hyundai Sonata Sedan', 2, 3.0, 45000.0000);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (6, N'Lexus ES Sedan', 1, 6.0, 67267477.6445);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (7, N'Kia Sportage Crossover', 1, 10.0, 41000.0000);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (8, N'Genesis G80 Sedan', 1, 4.0, 68000.0000);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (9, N'SsangYong Rexton SUV', 1, 7.0, 33743933.2667);
    INSERT INTO [dbo].[Finished_Products] ([ID], [Name], [Unit_ID], [Quantity], [Amount]) VALUES (10, N'Lexus RX Crossover', 1, 6.0, 72000.0000);
    SET IDENTITY_INSERT [dbo].[Finished_Products] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Ingredients])
BEGIN
    SET IDENTITY_INSERT [dbo].[Ingredients] ON;
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (13, 1, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (14, 1, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (15, 1, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (16, 1, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (17, 1, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (18, 1, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (19, 1, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (20, 1, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (21, 2, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (22, 2, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (23, 2, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (24, 2, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (25, 2, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (26, 2, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (27, 2, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (28, 2, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (29, 3, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (30, 3, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (31, 3, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (32, 3, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (33, 3, 6, 2.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (34, 3, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (35, 3, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (36, 4, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (37, 4, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (38, 4, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (39, 4, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (40, 4, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (41, 4, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (42, 4, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (43, 4, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (44, 6, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (45, 6, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (46, 6, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (47, 6, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (48, 6, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (49, 6, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (50, 6, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (51, 6, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (52, 7, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (53, 7, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (54, 7, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (55, 7, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (56, 7, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (57, 7, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (58, 7, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (59, 7, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (60, 8, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (61, 8, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (62, 8, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (63, 8, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (64, 8, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (65, 8, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (66, 8, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (67, 8, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (68, 9, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (69, 9, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (70, 9, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (71, 9, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (72, 9, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (73, 9, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (74, 9, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (75, 9, 8, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (76, 10, 1, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (77, 10, 2, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (78, 10, 3, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (79, 10, 4, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (80, 10, 5, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (81, 10, 6, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (82, 10, 7, 1.0);
    INSERT INTO [dbo].[Ingredients] ([ID], [Product_ID], [Raw_Material_ID], [Quantity]) VALUES (83, 10, 8, 1.0);
    SET IDENTITY_INSERT [dbo].[Ingredients] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Raw_Material_Purchases])
BEGIN
    SET IDENTITY_INSERT [dbo].[Raw_Material_Purchases] ON;
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (0, 1, 100.0, 2000000.0000, N'20260212 21:42:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (1, 2, 20.0, 4000000.0000, N'20260212 21:42:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (2, 3, 10.0, 5000000.0000, N'20260212 21:42:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (3, 4, 50.0, 1500000.0000, N'20260212 21:42:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (4, 6, 15.0, 3000000.0000, N'20260212 21:42:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (5, 1, 2.0, 50000.0000, N'20260226 23:55:30', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (6, 3, 4.0, 20000.0000, N'20260226 23:55:49', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (7, 4, 5.0, 10000.0000, N'20260226 23:56:00', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (8, 5, 5.0, 11000.0000, N'20260226 23:56:26', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (9, 1, 66.0, 333333.0000, N'20260227 08:49:06', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (10, 1, 5.0, 10000.0000, N'20260227 08:49:29', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (11, 7, 25.0, 20000.0000, N'20260227 08:58:13', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (12, 1, 100.0, 100000.0000, N'20260227 10:04:20', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (13, 3, 10.0, 10000.0000, N'20260227 10:04:37', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (14, 7, 20.0, 20000.0000, N'20260304 15:46:51', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (15, 6, 15.0, 50000.0000, N'20260304 15:47:03', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (16, 6, 10.0, 100000.0000, N'20260415 15:40:25', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (17, 5, 15.0, 150000.0000, N'20260415 15:40:40', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (18, 3, 10.0, 500000.0000, N'20260415 15:40:57', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (19, 7, 15.0, 150000.0000, N'20260415 15:41:32', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (20, 2, 5.0, 200000.0000, N'20260415 15:41:56', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (21, 4, 20.0, 100000.0000, N'20260429 13:48:14', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (22, 5, 25.0, 550000.0000, N'20260429 13:50:53', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (23, 2, 20.0, 200000.0000, N'20260509 13:17:11', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (24, 2, 15.0, 150000000.0000, N'20260510 09:30:29', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (25, 6, 1.0, 150000.0000, N'20260513 14:09:25', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (26, 7, 50.0, 500000.0000, N'20260513 15:32:05', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (28, 7, 2.0, 500000.0000, N'20260518 20:23:50', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (29, 6, 1.0, 25000.0000, N'20260518 20:24:12', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (30, 4, 5.0, 250000.0000, N'20260518 20:45:08', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (31, 5, 4.0, 200000.0000, N'20260521 19:46:44', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (32, 6, 1.0, 40000.0000, N'20260522 13:38:05', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (33, 3, 5.0, 500000.0000, N'20260522 13:53:47', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (34, 1, 10.0, 200000.0000, N'20260522 13:54:07', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (35, 2, 10.0, 100000.0000, N'20260522 13:54:17', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (36, 8, 10.0, 200000.0000, N'20260522 13:54:42', 2);
    INSERT INTO [dbo].[Raw_Material_Purchases] ([ID], [Raw_Material_ID], [Quantity], [Amount], [Purchase_Date], [Employee_ID]) VALUES (37, 6, 10.0, 100000.0000, N'20260522 13:54:53', 2);
    SET IDENTITY_INSERT [dbo].[Raw_Material_Purchases] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Product_Production])
BEGIN
    SET IDENTITY_INSERT [dbo].[Product_Production] ON;
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (0, 1, 5.0, N'20260212 21:42:30', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1, 3, 3.0, N'20260212 21:42:30', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1010, NULL, 1.0, N'20260227 09:11:01', NULL);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1011, 1, 1.0, N'20260227 09:44:07', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1012, 1, 1.0, N'20260227 09:48:25', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1013, 2, 1.0, N'20260227 09:48:36', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1014, 3, 1.0, N'20260227 09:48:46', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1015, 2, 1.0, N'20260227 09:48:54', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1016, 2, 1.0, N'20260227 09:50:15', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1017, 3, 1.0, N'20260227 09:50:22', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1018, 2, 1.0, N'20260227 09:50:29', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1019, 2, 1.0, N'20260227 09:56:29', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1020, 1, 1.0, N'20260227 09:56:53', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1021, 2, 1.0, N'20260227 09:57:32', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1022, 2, 1.0, N'20260227 10:02:11', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1023, 3, 1.0, N'20260227 10:02:33', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1024, 3, 1.0, N'20260227 10:05:13', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1025, 3, 1.0, N'20260304 15:40:59', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1026, 3, 1.0, N'20260304 15:46:23', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1027, 3, 1.0, N'20260304 15:49:06', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1028, 1, 1.0, N'20260415 15:42:08', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1029, 1, 1.0, N'20260429 13:48:21', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1030, 1, 1.0, N'20260429 13:48:25', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1031, 1, 1.0, N'20260429 13:51:05', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1032, 3, 1.0, N'20260429 13:51:14', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1033, 1, 1.0, N'20260513 14:09:34', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1035, 3, 1.0, N'20260518 20:45:43', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1036, 9, 1.0, N'20260521 19:47:00', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1037, 6, 1.0, N'20260521 20:03:19', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1038, 6, 1.0, N'20260522 13:40:40', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1039, 1, 2.0, N'20260522 13:54:57', 4);
    INSERT INTO [dbo].[Product_Production] ([ID], [Product_ID], [Quantity], [Prod_Date], [Employee_ID]) VALUES (1040, 3, 1.0, N'20260522 14:02:11', 4);
    SET IDENTITY_INSERT [dbo].[Product_Production] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Product_Sales])
BEGIN
    SET IDENTITY_INSERT [dbo].[Product_Sales] ON;
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (0, 1, 2.0, 7000000.0000, N'20260212 21:42:30', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1, 3, 1.0, 5500000.0000, N'20260212 21:42:30', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1006, 3, 2.0, 3000000.0000, N'20260227 08:58:54', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1010, 2, 3.0, 4500000.0000, N'20260304 15:41:51', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1011, 1, 2.0, 2000000.0000, N'20260330 17:36:05', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1012, 1, 1.0, 750000.0000, N'20260415 15:43:11', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1013, 1, 1.0, 1000000.0000, N'20260429 13:48:43', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1014, 3, 2.0, 3000000.0000, N'20260512 19:35:33', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1015, 1, 1.0, 990000.0000, N'20260513 14:09:48', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1017, 6, 2.0, 400000.0000, N'20260518 20:46:06', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1018, 6, 1.0, 1000000.0000, N'20260521 19:48:33', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1019, 6, 1.0, 43798213.2500, N'20260521 20:03:19', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1020, 8, 1.0, 1200000.0000, N'20260522 13:48:48', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1021, 9, 1.0, 1200000.0000, N'20260522 13:49:02', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1022, 1, 2.0, 4000000.0000, N'20260522 13:49:50', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1024, 1, 1.0, 1000000.0000, N'20260522 13:55:08', 6);
    INSERT INTO [dbo].[Product_Sales] ([ID], [Product_ID], [Quantity], [Amount], [Sale_Date], [Employee_ID]) VALUES (1025, 3, 1.0, 1253076.1200, N'20260522 14:02:11', 6);
    SET IDENTITY_INSERT [dbo].[Product_Sales] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Business_Loans])
BEGIN
    SET IDENTITY_INSERT [dbo].[Business_Loans] ON;
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1, N'Demir Bank', 5000000.0000, 12.5, N'20260225 15:15:42', N'Repaid');
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1002, N'demir bank', 100000.0000, 10.5, N'20260227 09:36:55', N'Active');
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1003, N'Mbank', 200000.0000, 10.5, N'20260227 10:02:57', N'Active');
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1004, N'Mbank', 300000.0000, 10.5, N'20260227 10:05:33', N'Repaid');
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1005, N'Mbank', 300000.0000, 10.5, N'20260429 13:51:27', N'Active');
    INSERT INTO [dbo].[Business_Loans] ([ID], [Bank_Name], [Loan_Amount], [Interest_Rate], [Loan_Date], [Status]) VALUES (1006, N'Demir Bank', 2000000.0000, 10.5, N'20260512 19:36:29', N'Repaid');
    SET IDENTITY_INSERT [dbo].[Business_Loans] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Salary_Payments])
BEGIN
    SET IDENTITY_INSERT [dbo].[Salary_Payments] ON;
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1, 1, 250000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (2, 2, 95000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (3, 3, 180000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (4, 4, 110000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (5, 5, 85000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (6, 6, 90000.0000, N'20260225 15:15:25');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1014, 1, 250000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1015, 2, 95000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1016, 3, 180000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1017, 4, 110000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1018, 5, 85000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1019, 6, 90000.0000, N'20260227 09:36:33');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1020, 1, 250000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1021, 2, 95000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1022, 3, 180000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1023, 4, 110000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1024, 5, 85000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1025, 6, 90000.0000, N'20260227 09:49:02');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1026, 1, 250000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1027, 2, 95000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1028, 3, 180000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1029, 4, 110000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1030, 5, 85000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1031, 6, 90000.0000, N'20260227 10:02:38');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1032, 1, 250000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1033, 2, 95000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1034, 3, 180000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1035, 4, 110000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1036, 5, 85000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1037, 6, 90000.0000, N'20260227 10:05:21');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1038, 1, 250000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1039, 2, 95000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1040, 3, 180000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1041, 4, 110000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1042, 5, 85000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1043, 6, 90000.0000, N'20260304 15:41:56');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1044, 1, 250000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1045, 2, 95000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1046, 3, 180000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1047, 4, 110000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1048, 5, 85000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1049, 6, 90000.0000, N'20260304 16:17:55');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1050, 1, 250000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1051, 2, 95000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1052, 3, 180000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1053, 4, 110000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1054, 5, 85000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1055, 6, 90000.0000, N'20260330 17:36:12');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1056, 1, 250000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1057, 2, 95000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1058, 3, 180000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1059, 4, 110000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1060, 5, 85000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1061, 6, 90000.0000, N'20260415 15:43:19');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1062, 1, 250000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1063, 2, 95000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1064, 3, 180000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1065, 4, 110000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1066, 5, 85000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1067, 6, 90000.0000, N'20260429 13:48:49');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1068, 1, 250000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1069, 2, 95000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1070, 3, 180000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1071, 4, 110000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1072, 5, 85000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1073, 6, 90000.0000, N'20260429 13:51:20');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1074, 1, 250000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1075, 2, 95000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1076, 3, 180000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1077, 4, 110000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1078, 5, 85000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1079, 6, 90000.0000, N'20260518 18:49:47');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1080, 1, 250000.0000, N'20260521 19:47:11');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1081, 2, 95000.0000, N'20260521 19:47:11');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1082, 3, 180000.0000, N'20260521 19:47:11');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1083, 4, 110000.0000, N'20260521 19:47:11');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1084, 5, 85000.0000, N'20260521 19:47:11');
    INSERT INTO [dbo].[Salary_Payments] ([ID], [Employee_ID], [Amount], [Payment_Date]) VALUES (1085, 6, 90000.0000, N'20260521 19:47:11');
    SET IDENTITY_INSERT [dbo].[Salary_Payments] OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Production Requests])
BEGIN
    SET IDENTITY_INSERT [dbo].[Production Requests] ON;
    INSERT INTO [dbo].[Production Requests] ([Request_ID], [Creation_Date], [Last_Update_Date], [Status], [Applicant_Full_Name], [Finished_Product_ID], [Quantity], [Rejection_Reason], [Error_Stage]) VALUES (1, N'20260521 20:03:19', N'20260521 20:03:19', N'Completed', N'Batyrova Aizhan', 6, 1, NULL, NULL);
    INSERT INTO [dbo].[Production Requests] ([Request_ID], [Creation_Date], [Last_Update_Date], [Status], [Applicant_Full_Name], [Finished_Product_ID], [Quantity], [Rejection_Reason], [Error_Stage]) VALUES (2, N'20260522 14:02:11', N'20260522 14:02:11', N'Completed', N'Aizhan', 3, 1, NULL, NULL);
    INSERT INTO [dbo].[Production Requests] ([Request_ID], [Creation_Date], [Last_Update_Date], [Status], [Applicant_Full_Name], [Finished_Product_ID], [Quantity], [Rejection_Reason], [Error_Stage]) VALUES (3, N'20260522 14:03:18', N'20260522 14:03:18', N'Error', N'aaa', 1, 2, N'Raw material procurement failed for material ID 7. Code: 2.', N'In the process of raw material procurement');
    SET IDENTITY_INSERT [dbo].[Production Requests] OFF;
END
GO

ENABLE TRIGGER ALL ON [dbo].[Units_of_Measurement];
GO

ENABLE TRIGGER ALL ON [dbo].[Positions];
GO

ENABLE TRIGGER ALL ON [dbo].[Employees];
GO

ENABLE TRIGGER ALL ON [dbo].[Budget];
GO

ENABLE TRIGGER ALL ON [dbo].[Raw_Materials];
GO

ENABLE TRIGGER ALL ON [dbo].[Finished_Products];
GO

ENABLE TRIGGER ALL ON [dbo].[Ingredients];
GO

ENABLE TRIGGER ALL ON [dbo].[Raw_Material_Purchases];
GO

ENABLE TRIGGER ALL ON [dbo].[Product_Production];
GO

ENABLE TRIGGER ALL ON [dbo].[Product_Sales];
GO

ENABLE TRIGGER ALL ON [dbo].[Business_Loans];
GO

ENABLE TRIGGER ALL ON [dbo].[Salary_Payments];
GO

ENABLE TRIGGER ALL ON [dbo].[Production Requests];
GO
