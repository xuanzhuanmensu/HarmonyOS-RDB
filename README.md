# Relational Database CRUD Example (HarmonyOS)

This HarmonyOS application demonstrates how to use the @ohos.data.relationalStore module for database Create, Read, Update, and Delete (CRUD) operations.

## Function Overview

### Core Functions
- Database initialization and table creation
- Data CRUD operations:
  - Insert data: Add sample employee records via buttons
  - Delete data: Remove records with specific IDs
  - Update data: Modify data that meets conditions
  - Query data: Display all current employee information

### Data Structure Example
```typescript
interface Employee {
  id: number | null;
  name: string;
  age: number;
  salary: number;
  Codes: string;
}
```

## Quick Start

### Running Requirements
- DevEco Studio 5.2 or higher
- HarmonyOS SDK API 14+
- Devices or emulators supporting ArkUI

### Deployment Steps
1. Clone the project to your local machine:
```bash
git clone https://github.com/<your-username>/<your-repo>.git
```
2. Open the project directory with DevEco Studio
3. Connect a device or start an emulator
4. Click the run button ▶️ to install and launch the application

## Usage Instructions

### Interface Layout
The application contains four main areas:

- Operation button area: Buttons for CRUD functions
- Data display area: Employee data displayed in a table format
```
Serial Number | Name | Age | Salary | Codes
```

### Operation Flow

#### Adding Data
1. Click the "Add" button
2. Automatically create a new record with name, age, salary, and Codes fields

#### Deleting Data
1. First view the ID of the target record in the table
2. Click the "Delete" button (currently hardcoded to delete record with ID=2)

#### Modifying Data
1. Click the "Modify" button
2. Update the Codes field to "Java" for all records with the name "zz"

#### Querying Data
1. Click the "View" button to refresh the data
2. Automatically display the latest database records

## Technical Implementation

### Key Components
- relationalStore.RdbStore // Database management
- relationalStore.RdbPredicates // Query condition construction
- relationalStore.ResultSet // Result set processing

### Database Operation Encapsulation
- Initialization: initRdbStore()
- Insert: insert()
- Delete: remove()
- Update: update()
- Query: query()
- Result processing: processResultSet()

### Table Structure
```sql
CREATE TABLE IF NOT EXISTS EMPLOYEE (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  NAME TEXT NOT NULL,
  AGE INTEGER,
  SALARY REAL,
  Codes TEXT
)
```

## Custom Development

### Modifying Table Structure
1. Update the SQL_CREATE_TABLE definition
2. Modify the Employee interface type
3. Adjust the processResultSet and UI display logic

### Implementing Conditional Deletion
Modify the query conditions in the remove() method:

```typescript
// Example: Change to delete by name
predicates.equalTo("NAME", "zz");
```
