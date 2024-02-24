// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {InstitutionInfo, CourseInfo, CourseAttended} from "./DataStruct.sol";

interface ICandidateContract {
    function courseSubscription(string  calldata _institutionID, string calldata _courseID) external;
    function coursePassed(string calldata _institutionID, string calldata _courseID) external;
    function verifyExam(string calldata _institutionID, string calldata _courseID) external view returns(bool);
    function getAllCoursesAttended() external view returns(CourseAttended[] memory);
}

interface IInstitution {
    function getInstitutionInfo() external view returns(InstitutionInfo memory);
    function registerCourse(string calldata _courseID, string calldata _courseName, uint _courseYear) external;
    function getCourseInfo(string calldata _courseID) external view returns(CourseInfo memory);
    function checkCourse(string calldata _courseID) external view returns(bool);
}

interface ICourse{
    function getCourseInfo() external view returns(CourseInfo memory);
}
