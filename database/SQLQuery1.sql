-- Create the database
CREATE DATABASE JobApplicationDB;
GO

USE JobApplicationDB;
GO

--- USERS TABLE
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'Employer', 'Applicant')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- APPLICANTS TABLE
CREATE TABLE Applicants (
    ApplicantID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Resume NVARCHAR(MAX) NULL,
    Bio NVARCHAR(MAX) NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- EMPLOYERS TABLE
CREATE TABLE Employers (
    EmployerID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    CompanyName NVARCHAR(100) NOT NULL,
    CompanyDescription NVARCHAR(MAX) NULL,
    IsVerified BIT DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- JOB POSTINGS TABLE
CREATE TABLE JobPostings (
    JobID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Requirements NVARCHAR(MAX) NULL,
    Location NVARCHAR(100) NULL,
    Salary NVARCHAR(50) NULL,
    PostedAt DATETIME DEFAULT GETDATE(),
    Deadline DATETIME NOT NULL,
    FOREIGN KEY (EmployerID) REFERENCES Employers(EmployerID) ON DELETE CASCADE
);

-- APPLICATIONS TABLE
CREATE TABLE Applications (
    ApplicationID INT IDENTITY(1,1) PRIMARY KEY,
    ApplicantID INT NOT NULL,
    JobID INT NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending', -- e.g., Pending, Shortlisted, Rejected
    AppliedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID) ON DELETE NO ACTION,
    FOREIGN KEY (JobID) REFERENCES JobPostings(JobID) ON DELETE NO ACTION
);


-- VERIFICATION DOCUMENTS TABLE
CREATE TABLE VerificationDocuments (
    DocumentID INT IDENTITY(1,1) PRIMARY KEY,
    EmployerID INT NOT NULL,
    DocumentPath NVARCHAR(MAX) NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 0,
    FOREIGN KEY (EmployerID) REFERENCES Employers(EmployerID) ON DELETE CASCADE
);

-- REPORTS TABLE
CREATE TABLE Reports (
    ReportID INT IDENTITY(1,1) PRIMARY KEY,
    ReportedBy INT NOT NULL,
    TargetType NVARCHAR(50) NOT NULL CHECK (TargetType IN ('JobPosting', 'Employer', 'Applicant')),
    TargetID INT NOT NULL,
    Reason NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending', -- e.g., Pending, Resolved
    ReportedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReportedBy) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- ADMINS TABLE
CREATE TABLE Admins (
    AdminID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Super Admin', 'Moderator')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
