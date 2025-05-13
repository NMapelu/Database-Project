-- Employee Management System Database Setup
-- Creates tables with proper constraints and relationships

-- 1. Create department table
CREATE TABLE department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

-- 2. Create employee table (1-M relationship with department)
CREATE TABLE employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary > 0),
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- 3. Create project table
CREATE TABLE project (
    proj_id INT AUTO_INCREMENT PRIMARY KEY,
    proj_name VARCHAR(50) NOT NULL UNIQUE,
    budget DECIMAL(12, 2) NOT NULL CHECK (budget >= 0),
    start_date DATE,
    end_date DATE,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- 4. Create junction table for M-M relationship between employee and project
CREATE TABLE emp_project (
    emp_id INT NOT NULL,
    proj_id INT NOT NULL,
    hours_worked INT NOT NULL DEFAULT 0 CHECK (hours_worked >= 0),
    PRIMARY KEY (emp_id, proj_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (proj_id) REFERENCES project(proj_id) ON DELETE CASCADE
);

-- 5. Create salary history table (1-M relationship with employee)
CREATE TABLE salary_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10, 2) NOT NULL,
    new_salary DECIMAL(10, 2) NOT NULL,
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE
);

-- Sample data insertion
INSERT INTO department (dept_name, location) VALUES 
('Human Resources', 'Building A, Floor 1'),
('Engineering', 'Building B, Floor 3'),
('Marketing', 'Building A, Floor 2');

INSERT INTO employee (name, position, hire_date, salary, dept_id) VALUES
('Sarah Johnson', 'HR Director', '2018-05-15', 85000.00, 1),
('Michael Chen', 'Senior Developer', '2019-03-10', 110000.00, 2),
('Emily Wilson', 'Marketing Specialist', '2020-11-22', 65000.00, 3);

INSERT INTO project (proj_name, budget, start_date, end_date) VALUES
('Employee Portal', 75000.00, '2023-01-15', '2023-06-30'),
('Product Launch', 120000.00, '2023-02-01', '2023-09-30'),
('Internal Training', 25000.00, '2023-03-01', NULL);

INSERT INTO emp_project (emp_id, proj_id, hours_worked) VALUES
(1, 3, 15),  -- Sarah working on Internal Training
(2, 1, 120), -- Michael working on Employee Portal
(3, 2, 80);  -- Emily working on Product Launch

INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date) VALUES
(2, 95000.00, 110000.00, '2022-12-15 09:00:00'),
(3, 60000.00, 65000.00, '2023-01-10 10:30:00');