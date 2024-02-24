// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

struct CourseAttended {
    string institutionID;
    string courseID;
    bool enrolled;
    uint timeEnrolled;
    bool passed;
    uint timePassed;
}

struct CourseInfo {
    string institutionID;
    string courseID;
    string courseName;
    uint courseYear;
}

struct InstitutionInfo {
    string institutionID;
    string institutionName;
    string addressLine;
    string country;
    string posteCode;
    address[] courses;
}
