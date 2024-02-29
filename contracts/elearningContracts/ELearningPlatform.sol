// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./Institution.sol";
import "./Candidate.sol";

import {InstitutionInfo, CourseInfo, CourseAttended} from "./DataStruct.sol";
import {ICandidateContract, IInstitution} from "./Interfaces.sol";

contract ELearningPlatform {

    event NewInstitution(string message, address indexed institutionAddress, string indexed institutionID);
    event NewCandidate(string message, string indexed candidateID);

    address public ownerPlatform;
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
        require(msg.sender == ownerPlatform);
      _;
    }

    // Create the smart contract ELearningPlatform.sol
    constructor (string memory _platformName) {
        ownerPlatform = msg.sender;
        platformName = _platformName;
    }

    // Register a new institution
    function registerInstitution(
        address _instAddress,
        string memory _institutionID,
        string memory _institutionName,
        string memory _addressLine,
        string memory _country,
        string memory _postecode
    ) public ownerPermissions { // Only the owner can add new institutions
        // Check if the institution already exists
        require(!checkInstitution(_institutionID));
        Institution institution = new Institution(
            address(this),
            _instAddress,
            _institutionID,
            _institutionName,
            _addressLine,
            _country,
            _postecode
        );

        institutionsList.push(address(institution));
        institutionIndex[_institutionID] = institutionsList.length - 1;
        institutionKeys[_institutionID] = _instAddress;
        istiturionRegistered[_institutionID] = true;

        // emit an event indicating the creation of the new institution
        emit NewInstitution("New Institution created!", address(institution), _institutionID);
    }

    // Register a new Candidate
    function registerCandidate(
        string calldata _candidateID
    ) public ownerPermissions { // Only the owner can add new candidates
        // Check if the candidate already exists
        require(!checkCandidate(_candidateID));

        Candidate candidate = new Candidate(
            _candidateID,
            address(this)
        );

        candidateList.push(address(candidate));
        candidateIndex[_candidateID] = candidateList.length - 1;
        candidateRegistered[_candidateID] = true;

        emit NewCandidate("New Candidate created!", _candidateID);
    }

    // Register a new Course
    function registerCourse(string calldata _institutionID, string calldata _courseID, string calldata _courseName, uint _courseYear) public {
        // An institution must be registered
        require(checkInstitution(_institutionID));
        // Only the owner of the institution can add new courses
        require(msg.sender == institutionKeys[_institutionID]);
        // Send an internal transaction to institution smart contract
        this.internalRegiterCourse(_institutionID, _courseID, _courseName, _courseYear);
    }

    function internalRegiterCourse(string calldata _institutionID, string calldata _courseID, string calldata _courseName, uint _courseYear) external {
        // Restrict the sender to this smart contract only
        require(msg.sender == address(this));
        IInstitution(institutionsList[institutionIndex[_institutionID]]).registerCourse(_courseID, _courseName, _courseYear);
    }

    // Subscribe a Candidate to a new Course
    function courseSubscription(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) public {
        // The candidate and the institution must be registered
        require(checkCandidate(_candidateID) && checkInstitution(_institutionID));
        // The course must exist
        require(IInstitution(institutionsList[institutionIndex[_institutionID]]).checkCourse(_courseID));
        // Only the institution that erogate the course can accept the registration of a new candidate
        require(msg.sender == institutionKeys[_institutionID]);
        // Send an internal transaction to candidate smart contract
        this.internalCourseSubcription(_institutionID, _courseID, _candidateID);
    }

    function internalCourseSubcription(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) external {
        require(msg.sender == address(this));
        ICandidateContract(candidateList[candidateIndex[_candidateID]]).courseSubscription(_institutionID, _courseID);
    }

    // Candidate pass an exame
    function passCourse(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) public {
        //  The candidate and the institution must be registered
        require(checkCandidate(_candidateID) && checkInstitution(_institutionID));
        // The course must exist
        require(IInstitution(institutionsList[institutionIndex[_institutionID]]).checkCourse(_courseID));
        // Only the institution that erogate the course can accept the registration of a new candidate
        require(msg.sender == institutionKeys[_institutionID]);
        // Send an internal transaction to candidate smart contract
        this.internalPassCourse(_institutionID, _courseID, _candidateID);
    }

    function internalPassCourse(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) external {
        require(msg.sender == address(this));
        ICandidateContract(candidateList[candidateIndex[_candidateID]]).coursePassed(_institutionID, _courseID);
    }

    // Verify if an exam is passed by a candidate
    function checkExam(string calldata _institutionID, string calldata _courseID, string calldata _candidateID) external view ownerPermissions returns(bool) {
        return ICandidateContract(candidateList[candidateIndex[_candidateID]]).verifyExam(_institutionID, _courseID);
    }
    
    // retrieve the course info
    function getCourseInfo(string calldata _institutionID, string calldata _courseID) external view returns(CourseInfo memory) {
        return IInstitution(institutionsList[institutionIndex[_institutionID]]).getCourseInfo(_courseID);
    }

    // retrieve the info about an institution
    function getInstitutionInfo(string calldata _istitutionID) external view returns(InstitutionInfo memory) {
        return IInstitution(institutionsList[institutionIndex[_istitutionID]]).getInstitutionInfo();
    }

    // Retrieve all courses attended by a candidate
    function getAllCandidateCourses(string memory _candidateID) external view returns(CourseAttended[] memory) {
        // check if the candidate exists
        require(checkCandidate(_candidateID));
        // retireve all the courses attended by a certain candidate
        return ICandidateContract(candidateList[candidateIndex[_candidateID]]).getAllCoursesAttended();
    }

    // Verify if an Institution exists
    function checkInstitution(string memory _institutionID) public view returns(bool) {
        if(istiturionRegistered[_institutionID]) {
            return true;
        }
        return false;
    }

    // Verify if a Candidate exists
    function checkCandidate(string memory _candidateID) public view returns(bool) {
        if(candidateRegistered[_candidateID]) {
            return true;
        }
        return false;
    }
}
