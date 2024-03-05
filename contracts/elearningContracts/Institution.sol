// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./Course.sol";
import {InstitutionInfo, CourseInfo} from "./DataStruct.sol";

import {ICourse} from "./Interfaces.sol";

contract Institution {

    event NewCourseRegistered(string message, address indexed courseAddress);

    address platformAddress;
    address institutionAddress;
    string institutionID;
    string institutionName;
    string addressLine;
    string country;
    string postCode;

    address[] coursesContarcts;
    mapping(string => uint) public courseContractIndexes;
    mapping(string => bool) public courseRegistered;

    constructor(
        address _platformAddress,
        address _institutionAddress,
        string memory _institutionID,
        string memory _institutionName,
        string memory _addressLine,
        string memory _country,
        string memory _postcode
    ) {
        platformAddress = _platformAddress;
        institutionAddress = _institutionAddress;
        institutionID = _institutionID;
        institutionName = _institutionName;
        addressLine = _addressLine;
        country = _country;
        postCode = _postcode;
    }

    function registerCourse(
        string calldata _courseID,
        string calldata _courseName,
        uint _courseYear

    ) public {
        require(msg.sender == platformAddress);
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

        emit NewCourseRegistered("New Course registered!", address(course));
    }

    function getInstitutionInfo() public view
        returns(InstitutionInfo memory)
    {
        InstitutionInfo memory info = InstitutionInfo({
            institutionID: institutionID,
            institutionName: institutionName,
            addressLine: addressLine,
            country: country,
            postCode: postCode,
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
