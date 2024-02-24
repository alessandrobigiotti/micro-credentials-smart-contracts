// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./Course.sol";
import {InstitutionInfo, CourseInfo} from "./DataStruct.sol";

import {ICourse} from "./Interfaces.sol";

contract Institution {

    event NewCourseRegistered(address indexed courseAddress);

    address platformAddress;
    string institutionID;
    string institutionName;
    string addressLine;
    string country;
    string posteCode;

    address[] coursesContarcts;
    mapping(string => uint) public courseContractIndexes;
    mapping(string => bool) public courseRegistered;

    constructor(
        address _platformAddress,
        string memory _institutionID,
        string memory _institutionName,
        string memory _addressLine,
        string memory _country,
        string memory _postecode
    ) {
        platformAddress = _platformAddress;
        institutionID = _institutionID;
        institutionName = _institutionName;
        addressLine = _addressLine;
        country = _country;
        posteCode = _postecode;
    }

    function registerCourse(
        string calldata _courseID,
        string calldata _courseName,
        uint _courseYear

    ) public {
        Course course = new Course(
            platformAddress,
            institutionID,
            _courseID,
            _courseName,
            _courseYear
        );
        coursesContarcts.push(address(course));
        courseContractIndexes[_courseID] = coursesContarcts.length-1;
        courseRegistered[_courseID] = true;

        emit NewCourseRegistered(address(course));
    }

    function getInstitutionInfo() public view
        returns(InstitutionInfo memory)
    {
        InstitutionInfo memory info = InstitutionInfo({
            institutionID: institutionID,
            institutionName: institutionName,
            addressLine: addressLine,
            country: country,
            posteCode: posteCode,
            courses: coursesContarcts
        });
        return info;
    }

    function getCourseInfo(string calldata _courseID) external view returns(CourseInfo memory) {
        return ICourse(coursesContarcts[courseContractIndexes[_courseID]]).getCourseInfo();
    }

    function checkCourse(string calldata _courseID) public view returns(bool) {
        return courseRegistered[_courseID];
    }

}
