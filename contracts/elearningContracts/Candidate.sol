// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {CourseAttended} from "./DataStruct.sol";

contract Candidate {

    address owner;
    address platformAddress;
    string candidateID;

    CourseAttended[] courseList;
    mapping(string => uint) courseIndex;

    constructor(string memory _candidateID) {
        candidateID = _candidateID;
    }

    function courseSubscription(
        string calldata _institutionID, 
        string calldata _courseID
    ) public {
        CourseAttended memory course = CourseAttended({
                                            institutionID: _institutionID,
                                            courseID: _courseID, 
                                            enrolled: true, 
                                            timeEnrolled: block.timestamp, 
                                            passed:false, 
                                            timePassed: 0
                                        });
        courseList.push(course);
        courseIndex[_courseID] = courseList.length - 1;
    }

    function coursePassed(string calldata _courseID) public {
        courseList[courseIndex[_courseID]].passed = true;
        courseList[courseIndex[_courseID]].timePassed = block.timestamp;
    }

    function getStudentInfo() public view returns(string memory) {
        return candidateID;
    }

    function getAllCoursesAttended() public view returns(CourseAttended[] memory) {
        return courseList;
    }
}