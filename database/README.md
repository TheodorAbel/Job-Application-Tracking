# Job Application Database Schema

This document describes the database schema used for the **Job Application Platform**. The schema supports various features such as job postings, applicant submissions, and employer applications. Below is a summary of the tables, their relationships, and the purpose of each table.

---

## Tables Overview

The database consists of the following key tables:

1. **Users**
2. **Applicants**
3. **Employers**
4. **JobPostings**
5. **Applications**
6. **Admin**

---

## 1. Users Table

The `Users` table stores information about all platform users, including applicants, employers, and admins. It is the central point for user identification.

### Columns:
- **UserID**: Primary key for the user.
- **FirstName**, **MiddleName**, **LastName**: Personal details of the user.
- **Email**: Unique email for each user (used for login).
- **Password**: Encrypted password for user authentication.
- **Role**: Indicates if the user is an `Admin`, `Employer`, or `Applicant`. This is used to differentiate access and functionalities on the platform.

### Relations:
- This table is related to both the `Applicants` and `Employers` tables, as they store specific information for each type of user.

---

## 2. Applicants Table

The `Applicants` table contains detailed information about users registered as applicants.

### Columns:
- **ApplicantID**: Foreign key referencing `Users(UserID)`. Identifies the applicant.
- **Resume**: A link or file path to the applicant’s resume.
- **Skills**: List of the applicant's skills.
- **Experience**: Work experience details of the applicant.

### Relations:
- Linked to the `Users` table via `UserID` (foreign key).
- Linked to the `Applications` table through `ApplicantID`.

---

## 3. Employers Table

The `Employers` table stores information about users registered as employers or companies.

### Columns:
- **EmployerID**: Foreign key referencing `Users(UserID)`. Identifies the employer.
- **CompanyName**: Name of the company.
- **CompanyDescription**: Description of the company.
- **Location**: Location of the company.
- **Industry**: The industry in which the company operates.

### Relations:
- Linked to the `Users` table via `UserID` (foreign key).
- Linked to the `JobPostings` table via `EmployerID`.

---

## 4. JobPostings Table

The `JobPostings` table contains job listings posted by employers. This table helps applicants apply for available jobs.

### Columns:
- **JobID**: Primary key for the job posting.
- **EmployerID**: Foreign key referencing `Employers(EmployerID)`. Identifies the employer who posted the job.
- **JobTitle**: Title of the job.
- **JobDescription**: Detailed description of the job.
- **Requirements**: Pre-requisite skills or qualifications.
- **Location**: Location of the job.
- **SalaryRange**: The salary range for the job.

### Relations:
- Linked to the `Employers` table via `EmployerID` (foreign key).
- Linked to the `Applications` table via `JobID`.

---

## 5. Applications Table

The `Applications` table tracks the job applications submitted by applicants. Each application links an applicant to a job posting.

### Columns:
- **ApplicationID**: Primary key for each application.
- **ApplicantID**: Foreign key referencing `Applicants(ApplicantID)`.
- **JobID**: Foreign key referencing `JobPostings(JobID)`.
- **Status**: The status of the application (e.g., "Pending", "Shortlisted", "Rejected").
- **AppliedAt**: The date and time when the applicant applied.

### Relations:
- Linked to the `Applicants` table via `ApplicantID` (foreign key).
- Linked to the `JobPostings` table via `JobID` (foreign key).

---

## 6. Admin Table

The `Admin` table stores information specific to platform administrators. It contains a subset of the fields from the `Users` table, tailored to administrative users.

### Columns:
- **AdminID**: Foreign key referencing `Users(UserID)`. Identifies the admin user.
- **Role**: Should be set to 'Admin' for this table.
- **Permissions**: Defines what administrative tasks the user can perform (e.g., managing job postings, approving applicants).

### Relations:
- Linked to the `Users` table via `UserID` (foreign key).

---

## Relationships Between Tables

The following relationships exist between the tables in the database:

- **Users ↔ Applicants**: One-to-One relationship. Each applicant is a user with additional personal information.
- **Users ↔ Employers**: One-to-One relationship. Each employer is a user with company-related information.
- **Employers ↔ JobPostings**: One-to-Many relationship. An employer can post multiple jobs, but each job posting belongs to one employer.
- **Applicants ↔ Applications**: One-to-Many relationship. An applicant can apply for multiple jobs.
- **JobPostings ↔ Applications**: One-to-Many relationship. A job can receive multiple applications.
- **Users ↔ Admin**: One-to-One relationship. Each admin is a user but with administrative privileges.

---

## SQL Server Foreign Key Constraints

- The `Applications` table has foreign key constraints to ensure referential integrity between applicants, job postings, and their applications. The foreign keys ensure that a valid applicant and a valid job posting are referenced in each application.

- **Example of Foreign Keys:**
    ```sql
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID) ON DELETE NO ACTION,
    FOREIGN KEY (JobID) REFERENCES JobPostings(JobID) ON DELETE NO ACTION
    ```

- **ON DELETE NO ACTION**: Prevents the deletion of records from the parent tables (`Applicants` or `JobPostings`) if they are referenced in the `Applications` table.

---




!!!stored proceudres coming soon