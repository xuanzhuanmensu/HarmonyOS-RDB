Relational Database CRUD Example (HarmonyOS)

This HarmonyOS application demonstrates how to perform database Create, Read, Update, and Delete (CRUD) operations using the @ohos.data.relationalStore module.

Feature Overview

Core Features
Database Initialization & Table Creation

Data CRUD Operations:

Insert Data: Add sample employee records via button

Delete Data: Remove records with specific IDs

Update Data: Modify qualifying data

Query Data: Display all current employee information

Data Structure Example

interface Employee {
  id: number | null;
  name: string;
  age: number;
  salary: number;
  Codes: string;

Quick Start

System Requirements
DevEco Studio 5.2 or higher

HarmonyOS SDK API 14+

ArkUI-supported device or emulator

Deployment Steps
Clone the project locally:

      git clone https://github.com/<your-username>/<your-repo>.git
   
Open the project directory in DevEco Studio

Connect device or launch emulator

Click Run button ▶️ to install and launch the application

Usage Instructions

Interface Layout

The application contains four main areas:  
Action Button Area: CRUD function buttons  

Data Display Area: Employee data displayed in table format  

ID Name Age Salary
 Codes  

Operation Flow
Add Data:

Click "Add" button

Automatically creates a new record with name, age, salary, and Codes fields
Delete Data:

First check the target record ID in the table

Click "Delete" button (currently hardcoded to delete record with ID=2)
Update Data:

Click "Modify" button

Updates the Codes field to "Java" for all records with name "zz"
Query Data:

Click "Query" button to refresh data

Automatically displays latest database records

Technical Implementation

Key Components

relationalStore.RdbStore // Database management
relationalStore.RdbPredicates // Query condition construction
relationalStore.ResultSet // Result set processing

Encapsulated Database Operations
Initialization: initRdbStore()

Insert: insert()

Delete: remove()

Update: update()

Query: query()

Result Processing: processResultSet()

Table Structure

CREATE TABLE IF NOT EXISTS EMPLOYEE (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  NAME TEXT NOT NULL,
  AGE INTEGER,
  SALARY REAL,
  Codes TEXT
)

Custom Development

Modify Table Structure
Update SQL_CREATE_TABLE definition

Modify Employee interface type

Adjust processResultSet and UI display logic

Implement Conditional Deletion

Modify query conditions in the remove() method:

// Example: Change to delete based on name
predicates.equalTo("NAME", "zz");
