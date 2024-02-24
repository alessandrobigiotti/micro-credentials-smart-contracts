// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./Institution.sol";
import "./Candidate.sol";

import {InstitutionInfo, CourseInfo, CourseAttended} from "./DataStruct.sol";

interface ICandidateContract {
    function courseSubscription(string  calldata _institutionID, string calldata _courseID) external;
    function coursePassed(string calldata _courseID) external;
    function getAllCoursesAttended() external;
}

interface IInstitution {
    function getInstitutionInfo() external view returns(InstitutionInfo memory);
    function registerCourse(string calldata _courseID, string calldata _courseName, uint _courseYear) external;
    function getCourseInfo(string calldata _courseID) external view returns(CourseInfo memory);
    function checkCourse(string calldata _courseID) external view returns(bool);
}

contract ELearningPlatform {

    event NewInstitutionRegitered(address indexed institutionAddress, string indexed institutionID);
    event NewCandidateRegistered(string indexed candidateID);

    address public owner;
    string public platformName;
    
    // Institution data
    address[] institutionsList;
    mapping(string => uint) institutionIndex;
    mapping(string => address) institutionKeys;
    mapping(string => bool) istiturionRegistered;

    // Candidate data
    address[] candidateList;
    mapping(string => uint) candidateIndex;
    mapping(string => bool) candidateRegistered;

    modifier ownerPermissions {
        require(msg.sender == owner);
      _;
    }

    constructor (string memory _platformName) {
        owner = msg.sender;
        platformName = _platformName;
    }

    function registerInstitution(
        address _instAddress,
        string memory _institutionID,
        string memory _institutionName,
        string memory _addressLine,
        string memory _country,
        string memory _postecode
    ) public ownerPermissions {
        require(!checkInstitution(_institutionID), "Error: Institution already registered.");
        Institution institution = new Institution(
            _instAddress,
            _institutionID,
            _institutionName,
            _addressLine,
            _country,
            _postecode
        );

        institutionsList.push(address(institution));
        institutionIndex[_institutionID] = institutionsList.length - 1;
        institutionKeys[_institutionID]= _instAddress;
        istiturionRegistered[_institutionID] = true;

        emit NewInstitutionRegitered(address(institution), _institutionID);
    }


    function registerCandidate(
        string calldata _candidateID
    ) public ownerPermissions {
        require(!checkCandidate(_candidateID), "Error: Candidate already registered.");

        Candidate candidate = new Candidate(
            _candidateID
        );

        candidateList.push(address(candidate));
        candidateIndex[_candidateID] = candidateList.length - 1;
        candidateRegistered[_candidateID] = true;

        emit NewCandidateRegistered(_candidateID);
    }

    function courseSubscription(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) external {
        require(checkCandidate(_candidateID) && checkInstitution(_institutionID));
        require(IInstitution(institutionsList[institutionIndex[_institutionID]]).checkCourse(_courseID));
        ICandidateContract(candidateList[candidateIndex[_candidateID]]).courseSubscription(_institutionID, _courseID);

    }

    function registerCourse(string calldata _institutionID, string calldata _courseID, string calldata _courseName, uint _courseYear) external {
        IInstitution(institutionsList[institutionIndex[_institutionID]]).registerCourse(_courseID, _courseName, _courseYear);
    }


    function getCourseInfo(string calldata _institutionID, string calldata _courseID) external view returns(CourseInfo memory) {
        return IInstitution(institutionsList[institutionIndex[_institutionID]]).getCourseInfo(_courseID);
    }

    // Auxiliary functions
    function checkInstitution(string memory _institutionID) public view returns(bool) {
        if(istiturionRegistered[_institutionID]) {
            return true;
        }
        return false;
    }

    function checkCandidate(string memory _candidateID) public view returns(bool) {
        if(candidateRegistered[_candidateID]) {
            return true;
        }
        return false;
    }

    function getInstitutionInfo(string calldata _istitutionID) external view returns(InstitutionInfo memory) {
        address instAddr = institutionsList[institutionIndex[_istitutionID]];
        return IInstitution(instAddr).getInstitutionInfo();
    }

    function getAllCandidateCourses(string calldata _candidateID) external view returns(CourseAttended memory) {

    }

    function checkCandidateCourse(string calldata _candidateID) external view returns(bool) {

    }


}