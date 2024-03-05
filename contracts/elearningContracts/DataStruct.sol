// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

// CourseAttended is stored in the Candidate smart contract and
// represents the courses attended by each candidate
struct CourseAttended {
    string institutionID;
    string courseID;
    bool enrolled;
    uint timeEnrolled;
    bool passed;
    uint timePassed;
}

// CourseInfo contains the datails about a course
struct CourseInfo {
    string institutionID;
    string courseID;
    string courseName;
    uint courseYear;
}

// InstitutionInfo contains the datails about an institution
struct InstitutionInfo {
    string institutionID;
    string institutionName;
    string addressLine;
    string country;
    string postCode;
    address[] courses;
}
