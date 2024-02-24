// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {CourseInfo} from "./DataStruct.sol";

contract Course {

    address platformAddress;
    address institutionAddress;
    string institutionID;
    string courseID;
    string courseName;
    uint courseYear;

    constructor(
        address _platformAddress,
        string memory _institutionID,
        string memory _courseID,
        string memory _courseName,
        uint _courseYear
    ) {
        platformAddress = _platformAddress;
        institutionAddress = msg.sender;
        institutionID = _institutionID;
        courseID = _courseID;
        courseName = _courseName;
        courseYear = _courseYear;
    }

    function getCourseInfo() public view returns(CourseInfo memory) {
        CourseInfo memory info = CourseInfo({
            institutionID: institutionID,
            courseID: courseID,
            courseName: courseName,
            courseYear: courseYear
        });
        return info;
    }

}