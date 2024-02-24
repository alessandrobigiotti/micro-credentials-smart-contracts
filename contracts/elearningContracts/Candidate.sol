// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {CourseAttended} from "./DataStruct.sol";

contract Candidate {

    address owner;
    address platformAddress;
    string candidateID;

    mapping(string => mapping(string => CourseAttended)) courseAttended;

    CourseAttended[] courseCompleted;

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
        courseAttended[_institutionID][_courseID] = course;
    }

    function coursePassed(string calldata _institutionID, string calldata _courseID) public {
        courseAttended[_institutionID][_courseID].passed = true;
        courseAttended[_institutionID][_courseID].timePassed = block.timestamp;
        courseCompleted.push(courseAttended[_institutionID][_courseID]);
    }

    function verifyExam(string calldata _institutionID, string calldata _courseID) public view returns(bool){
        return courseAttended[_institutionID][_courseID].passed;
    }

    function getStudentInfo() public view returns(string memory) {
        return candidateID;
    }

    function getAllCoursesAttended() public view returns(CourseAttended[] memory) {
        return courseCompleted;
    }
}
