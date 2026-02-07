-- Activate Database --
USE Db_BankingSystem;

-- Creating Customers Tables --
CREATE TABLE Tbl_Customers(
	Customer_id INT AUTO_INCREMENT PRIMARY KEY,
	Full_Name VARCHAR(100) NOT NULL,
    Gender ENUM('Male', 'Female'),
    Age INT,
    Phone_Number VARCHAR(11) UNIQUE NOT NULL,
    Email VARCHAR(50)UNIQUE NOT NULL,
    Address TEXT,
    Opening_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Accounts Table --
CREATE TABLE Tbl_Accounts(
	Account_id INT AUTO_INCREMENT PRIMARY KEY,
    Customer_id INT,
    Account_Number VARCHAR(10) UNIQUE NOT NULL,
    Account_Type ENUM('Savings', 'Current'),
    Account_Balance DECIMAL (12, 2) DEFAULT 0.00 CHECK (Account_Balance >= 0),
    Opening_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(Customer_id) REFERENCES Tbl_Customers(Customer_id) ON DELETE CASCADE
) AUTO_INCREMENT = 100;

-- Creating Transaction Table --
CREATE TABLE Tbl_Transactions(
	Transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    Account_id INT,
    Transaction_Type ENUM('Transfer', 'Withdraw', 'Deposit') NOT NULL,
    Amount DECIMAL (12, 2) NOT NULL,
    Transaction_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Account_id) REFERENCES Tbl_Accounts(Account_id)
) AUTO_INCREMENT = 200;

-- Inserting Customer Table --
INSERT INTO Tbl_Customers (Full_Name, Gender, Age, Phone_Number, Email, Address) VALUES
('Gbande Dorcas', 'Female', 24, '0902255123', 'nadoo111@gmail.com', 'Lekki'),
('Ikyaan Daniel', 'Male', 28, '0808876543', 'daniel1010@gmail.com', 'Ajah'),
('Okafor Stephanie', 'Female', 30, '0904455432', 'okasteph@yahoo.com', 'Chevron'),
('James Smith', 'Male', 45, '07022234561', 'Jaysmith111@yahoo.com', 'Ajah'),
('Dede Destiny', 'Male', 22, '0907766123', 'dededes123@gmail.com', 'Ikoyi'),
('Bem Doose', 'Female', 20, '07022552354', 'bemdoo@yahoo.com', 'Lekki'),
('Meek Favour', 'Female', 25, '0807733567', 'favourmeek@gmail.com', 'Chevron'),
('Nege Desmond', 'Male', 27, '09052022147', 'negedes36@gmail.com', 'Chevron');

-- Inserting Accounts Table --
	INSERT INTO Tbl_Accounts(Customer_id, Account_Number, Account_Type, Account_Balance) VALUES
    (1, '0002234341', 'Savings', '150000'),
	(1, '222535341', 'Current', '12000'),
	(1, '1100234545', 'Savings', '75000'),
    (2, '0005522123', 'Current', '9000'),
	(2, '2005521215', 'Current', '30000'),
	(2, '3006622122', 'Savings', '200000'),
    (3, '0006633456', 'Current', '9500'),
    (3, '3131444221', 'Savings', '250000'),
	(3, '2225500123', 'Current', '37000'),
    (4, '0025250011', 'Savings', '90000'),
    (4, '2200123111', 'Current', '12000'),
    (4, '3001115522', 'Savings', '85000'),
    (5, '0033554545', 'Current', '6000'),
    (5, '2222404011', 'Savings', '60000'),
    (5, '3131424266', 'Current', '66000'),
    (6, '0007722343', 'Savings', '15000'),
	(6, '4001112331', 'Current', '120000'),
	(6, '2113350011', 'Savings', '95000'),
    (7, '0011232311', 'Current', '19000'),
    (7, '3222111500', 'Savings', '190000'),
    (7, '1130045222', 'Current', '5000'),
    (8, '0048190430', 'Savings', '350000'),
	(8, '3119535737', 'Current', '7000'),
	(8, '2295672731', 'Savings', '100000');

-- Inserting Into Transaction Table--
INSERT INTO Tbl_Transactions (Account_id, Transaction_Type, Amount) VALUES
(100, 'Transfer', '70000'),
(101, 'Withdraw', '12000'),
(103, 'Transfer', '2000'),
(104, 'Deposit', '25000'),
(106, 'Transfer', '1500'),
(107, 'Withdraw', '40000'),
(109, 'Deposit', '70000'),
(110, 'Withdraw', '5000'),
(112, 'Deposit', '20000'),
(115, 'Deposit', '50000'),
(116, 'Transfer', '60000'),
(120, 'Withdraw', '5000'),
(118, 'Deposit', '20000'),
(121, 'Deposit', '100000'),
(121, 'Withdraw', '150000');

SELECT * FROM Tbl_Customers;
SELECT * FROM Tbl_Accounts;
SELECT * FROM Tbl_Transactions;

-- (1) Show all customers and their account details --
SELECT C.Customer_id, C.Full_Name, C.Gender, C.Age, C.Email, C.Address, C.Opening_Date AS Customer_Opening_Date, A.Account_Number,
 A.Account_Type, A.Account_Balance FROM Tbl_Customers C LEFT JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id;
 
-- (2) Display a list of all transactions for a given account--
SELECT T.Transaction_id, A.Account_Number, T.Transaction_Type, T.Amount, T.Transaction_Date
FROM  Tbl_Transactions T LEFT JOIN  Tbl_Accounts A ON T.Account_id = A.Account_id WHERE A.Account_Number = '0048190430';

-- (3) Show total balance per customer-
SELECT C.Customer_id, C.Full_Name, C.Gender, SUM(A.Account_Balance) AS Total_Balance FROM Tbl_Customers C LEFT JOIN 
Tbl_Accounts A ON C.Customer_id = A.Customer_id GROUP BY C.Customer_id ORDER BY Total_Balance DESC

-- (4) List customers who have more than one account --
SELECT C.Customer_id, C.Full_Name, C.Gender, COUNT(A.Account_id) AS Number_Of_Accounts FROM
 Tbl_Customers C LEFT JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id GROUP BY C.Customer_id, C.Full_Name, C.Gender
HAVING COUNT(A.Account_id) > 1;

-- (5) Find accounts with balance below ₦10,000.
SELECT C.Customer_id, C.Full_Name, C.Gender, A.Account_Balance  FROM
Tbl_Customers C LEFT JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id HAVING (A.Account_Balance) < 10000;

-- Create a VAT column in Transaction table that calculates VAT (7.5%) on a given transaction amount --
ALTER TABLE Tbl_Transactions ADD COLUMN VAT DECIMAL(12, 2);
UPDATE Tbl_Transactions SET VAT = Amount * 0.0075 WHERE Transaction_id = 228;

-- Create procedures to: Open a new account for a customer --
DELIMITER //
CREATE PROCEDURE New_Customer_Account(
    IN Full_Name VARCHAR(100),
    IN Gender ENUM('Male', 'Female'),
    IN Age INT,
    IN Phone_Number VARCHAR(11),
    IN Email VARCHAR(50),
    IN Address TEXT,
    IN Account_Number VARCHAR(10),
    IN Account_Type ENUM('Savings', 'Current'),
    IN Account_Balance DECIMAL(12,2)
)
BEGIN
    DECLARE New_Customer_id INT;
    -- Insert into Tbl_Customers
    INSERT INTO Tbl_Customers (Full_Name, Gender, Age, Phone_Number, Email, Address)
    VALUES (Full_Name, Gender, Age, Phone_Number, Email, Address);
    -- Get the new Customer_id
    SET New_Customer_id = LAST_INSERT_ID();
    -- Insert into Tbl_Accounts
    INSERT INTO Tbl_Accounts (Customer_id, Account_Number, Account_Type, Account_Balance)
    VALUES (New_Customer_id, Account_Number, Account_Type, Account_Balance);
END //
DELIMITER ;
-- CALL
CALL New_Customer_Account('Jethro Koko', 'Male', 30, 08099224567, 'jetkoko@gmail.com', 'Lekki', '9002323156', 'Savings', '54000');

-- Process a withdrawal from an account--
DELIMITER //
CREATE PROCEDURE Process_Withdrawal(
    IN p_Account_id INT,
    IN p_Amount DECIMAL(12, 2))
BEGIN
    DECLARE Current_Balance DECIMAL(12, 2);
    DECLARE VAT DECIMAL(12, 2);
    DECLARE New_Balance DECIMAL(12, 2);
    -- Get current balance
    SELECT Account_Balance INTO Current_Balance
    FROM Tbl_Accounts
    WHERE Account_id = p_Account_id;
    -- Calculate VAT (7.5%)
    SET VAT = p_Amount * 0.075;
    -- Ensure sufficient funds (Amount + VAT)
    IF Current_Balance < (p_Amount + VAT) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds for withdrawal including VAT';
    END IF;
    -- Compute new balance
    SET New_Balance = Current_Balance - (p_Amount + VAT);
    -- Update the balance
    UPDATE Tbl_Accounts
    SET Account_Balance = New_Balance
    WHERE Account_id = p_Account_id;
    -- Log the transaction
    INSERT INTO Tbl_Transactions (Account_id, Transaction_Type, Amount, VAT)
    VALUES (p_Account_id, 'Withdraw', p_Amount, VAT);
END;
-- CALL
CALL Process_Withdrawal(120, 20000);

-- Simulate a money transfer between two accounts using:(START TRANSACTION) (COMMIT) (ROLLBACK)
-- Ensure both sender and receiver accounts are updated together or not at all.
DELIMITER //
CREATE PROCEDURE Transfer_Funds(
    IN p_Sender_Account_ID INT,
    IN p_Receiver_Account_ID INT,
    IN p_Amount DECIMAL(12, 2))
BEGIN
    DECLARE Sender_Balance DECIMAL(12,2);
    DECLARE VAT DECIMAL(12,2);
    DECLARE Sender_New_Balance DECIMAL(12,2);
    DECLARE Receiver_New_Balance DECIMAL(12,2);
    -- Start transaction block
    START TRANSACTION;
    -- Get sender's current balance
    SELECT Account_Balance INTO Sender_Balance
    FROM Tbl_Accounts
    WHERE Account_id = p_Sender_Account_Id
    FOR UPDATE;
    -- Calculate VAT
    SET VAT = p_Amount * 0.075;
    -- Check if sender has enough money
    IF Sender_Balance < (p_Amount + VAT) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds for transfer, VAT inclusive';
    END IF;
    -- Deduct from sender
    SET Sender_New_Balance = Sender_Balance - (p_Amount + VAT);
    UPDATE Tbl_Accounts
    SET Account_Balance = Sender_New_Balance
    WHERE Account_id = p_Sender_Account_Id;
    -- Add to receiver
    UPDATE Tbl_Accounts
    SET Account_Balance = Account_Balance + p_Amount
    WHERE Account_id = p_Receiver_Account_id;
    -- Log transactions
    INSERT INTO Tbl_Transactions (Account_id, Transaction_Type, Amount, VAT)
    VALUES 
        (p_Sender_Account_ID, 'Transfer', p_Amount, VAT),
        (p_Receiver_Account_ID, 'Deposit', p_Amount, 0.00);

    -- All successful — commit the transaction
    COMMIT;
END //
-- Call
CALL Transfer_Funds(100, 109, 50000);

-- CREATING TRIGGERS--
-- Log all new transactions into a transaction_log table--

CREATE TABLE Tbl_Transactions_Log(
	Log_id INT AUTO_INCREMENT PRIMARY KEY,
	Transaction_id INT,
    Account_id INT,
    Transaction_Type ENUM('Transfer', 'Withdraw', 'Deposit'),
    Amount DECIMAL (12, 2),
    VAT DECIMAL (12, 2),
    Transaction_Date TIMESTAMP,
    Logged_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)AUTO_INCREMENT = 300;

-- Creating Triggers --
DELIMITER //
CREATE TRIGGER Tri_Transaction_Log
AFTER INSERT ON Tbl_Transactions
FOR EACH ROW
BEGIN
    INSERT INTO Tbl_Transactions_Log(Transaction_id, Account_id, Transaction_Type, Amount, VAT, Transaction_Date)
    VALUES (Transaction_id, Account_id, Transaction_Type, Amount, VAT, Transaction_Date);
END //

-- Prevent withdrawals that would leave the account with a negative balance--
CREATE TABLE Tri_Accounts (
    Tri_Account_id INT PRIMARY KEY AUTO_INCREMENT,
    Account_id INT,
    Account_Number VARCHAR(10) UNIQUE NOT NULL,
    Account_Type ENUM('Savings', 'Current'),
    Account_Balance DECIMAL(12,2) DEFAULT 0.00 CHECK (Account_Balance >= 0),
    Opening_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Account_id) REFERENCES Tbl_Accounts(Account_id)
) AUTO_INCREMENT = 400;

DELIMITER //
CREATE TRIGGER Prevent_Overdraft
BEFORE INSERT ON Tbl_Transactions
FOR EACH ROW
BEGIN
		DECLARE New_Balance DECIMAL(12,2);
        DECLARE Current_Balance DECIMAL(12,2);
    -- for withdrawals
    IF NEW.Transaction_Type = 'Withdraw' THEN
        -- Get the current balance of the account
        SELECT Account_Balance INTO Current_Balance
        FROM Tri_Accounts
        WHERE Account_id = NEW.Account_id;
        -- Check if balance is sufficient
	IF Current_Balance < (NEW.Amount + NEW.VAT) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Withdrawal Denied Due To Insufficient Funds';
	END IF;
	END IF;
END; //
-- to comfirm my trigger for Preventing withdrawals with negative values
INSERT INTO Tri_Accounts (Account_id, Account_Number, Account_Type, Account_Balance)
VALUES (104, '0001047890', 'Savings', 100000.00);
INSERT INTO Tbl_Transactions (Account_id, Transaction_Type, Amount, VAT, Transaction_Date)
VALUES (104, 'Withdraw', 270000, 50, NOW());

-- Deposit of more than 10 million naira should alert the EFCC--
CREATE TABLE EFCC_Alerts(
    Alert_id INT AUTO_INCREMENT PRIMARY KEY,
    Transaction_id INT,
    Account_id INT,
    Amount DECIMAL(12,2),
    Alert_Message VARCHAR(255),
    Alerted_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) AUTO_INCREMENT = 500;

DELIMITER //
CREATE TRIGGER EFCC_Deposit_Alert
AFTER INSERT ON Tbl_Transactions
FOR EACH ROW
BEGIN
IF NEW.Transaction_Type = 'Deposit' AND NEW.Amount > 10000000 THEN
INSERT INTO EFCC_Alerts (Transaction_id, Account_id, Amount, Alert_Message)VALUES
(NEW.Transaction_id, NEW.Account_id, NEW.Amount, CONCAT('EFCC ALERT: Deposit of ₦', NEW.Amount, ' into Account ID ', NEW.Account_id));
END IF;
END; //
-- To comfirm EFCC trigger--
INSERT INTO Tbl_Transactions (Transaction_id, Account_id, Transaction_Type, Amount, VAT, Transaction_Date)
VALUES (202, 104, 'Deposit', 12000000, 0.00, NOW());
SELECT * FROM EFCC_Alerts;

-- A view showing each customer’s total account balances --
CREATE VIEW VW_Customer_Balance AS SELECT C.Customer_id, C.Full_Name, SUM(A.Account_Balance) AS Total_Balance
FROM Tbl_Customers C JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id
GROUP BY Customer_id, Full_Name;

SELECT * FROM VW_Customer_Balance;

-- A view showing all active customers(customers with at least one transaction)
CREATE VIEW Vw_Active_Customers AS
SELECT C.Customer_id, C.Full_Name, COUNT(T.Transaction_id) AS Total_Transactions, MAX(T.Transaction_Date) AS Last_Transaction_Date
FROM Tbl_Customers C
JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id
JOIN Tbl_Transactions T ON A.Account_id = T.Account_id
GROUP BY C.Customer_id, C.Full_Name;

SELECT * FROM Vw_Active_Customers;

-- Create indexes on email in customers--
CREATE INDEX idx_email ON Tbl_Customers (Email);
SHOW INDEX FROM Tbl_Transactions;

-- Create indexes transaction_date in transactions
CREATE INDEX idx_Transaction_date ON Tbl_Transactions(Transaction_date);
SHOW INDEX FROM Tbl_Transactions;

-- Create indexes account_type in accounts
CREATE INDEX idx_Account_type ON Tbl_Accounts(Account_type);
SHOW INDEX FROM Tbl_Accounts;

-- Show Transactions and Total balance per customer For exporting --
SELECT C.Customer_id, C.Full_Name, C.Gender, COUNT(T.Transaction_id) AS Total_Transactions, SUM(T.Amount) AS Total_Trans_Amount,
SUM(A.Account_Balance) AS Total_Balance FROM Tbl_Customers C JOIN Tbl_Accounts A ON C.Customer_id = A.Customer_id
JOIN Tbl_Transactions T ON A.Account_id = T.Account_id WHERE C.Customer_id IN (SELECT Customer_id FROM Tbl_Accounts
GROUP BY Customer_id HAVING COUNT(Account_id) > 1) GROUP BY C.Customer_id;