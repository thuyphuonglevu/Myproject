// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EvidenceManagement {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    enum Role {
        NONE,
        OFFICER,
        ANALYST,
        COURT
    }

    enum EvidenceStatus {
        UPLOADED,
        UNDER_REVIEW,
        VERIFIED,
        REJECTED,   
        ARCHIVED
    }

    enum CaseStatus {
        ACTIVE,
        CLOSED
    }

    struct Case {
        string caseId;
        string title;
        string description;
        address officer;
        CaseStatus status;
        uint256 createdAt;
        uint256 closedAt;
    }

    struct CustodyRecord {
        address actor;
        string action;
        uint256 timestamp;
    }

    struct Evidence {
        string evidenceId;
        string caseId;
        string fileHash;
        string fileURI;
        address creator;
        uint256 createdAt;
        EvidenceStatus status;
    }

    mapping(string => Evidence) private evidences;
    mapping(string => CustodyRecord[]) private custodyHistory;
    mapping(string => string[]) private caseEvidenceIds;
    mapping(string => string) private hashToEvidenceId;
    mapping(address => Role) public roles;
    mapping(string => Case) public cases;
    mapping(string => bool) public caseExists;
    
    // Mảng lưu danh sách tất cả evidence IDs
    string[] public allEvidenceIds;
    string[] public allCaseIds;

    // ============ MODIFIERS ============
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    modifier onlyOfficer() {
        require(roles[msg.sender] == Role.OFFICER, "Only officer");
        _;
    }

    modifier onlyAnalyst() {
        require(roles[msg.sender] == Role.ANALYST, "Only analyst");
        _;
    }

    modifier onlyCourt() {
        require(roles[msg.sender] == Role.COURT, "Only court");
        _;
    }

    modifier evidenceExists(string memory _id) {
        require(evidences[_id].createdAt != 0, "Evidence not found");
        _;
    }

    modifier caseExistsMod(string memory _caseId) {
        require(caseExists[_caseId], "Case not found");
        _;
    }

    // ============ EVENTS ============
    event RoleAssigned(address indexed user, Role role);
    event EvidenceAdded(string evidenceId, address creator);
    event ReviewStarted(string evidenceId, address analyst);
    event EvidenceVerified(string evidenceId, address analyst);
    event EvidenceRejected(string evidenceId, address analyst); 
    event EvidenceArchived(string evidenceId);
    event CaseCreated(string caseId, address officer, string title);
    event CaseArchived(string caseId, address officer);

    // ============ ROLE FUNCTIONS ============
    function assignRole(address _user, Role _role) public onlyAdmin {
        roles[_user] = _role;
        emit RoleAssigned(_user, _role);
    }

    // ============ CASE FUNCTIONS ============
    function createCase(
        string memory _caseId,
        string memory _title,
        string memory _description
    ) public onlyOfficer {
        require(!caseExists[_caseId], "Case already exists");
        
        cases[_caseId] = Case({
            caseId: _caseId,
            title: _title,
            description: _description,
            officer: msg.sender,
            status: CaseStatus.ACTIVE,
            createdAt: block.timestamp,
            closedAt: 0
        });
        caseExists[_caseId] = true;
        
        allCaseIds.push(_caseId);
        
        emit CaseCreated(_caseId, msg.sender, _title);
    }

    function getCase(string memory _caseId) 
        public 
        view 
        caseExistsMod(_caseId)
        returns (Case memory) 
    {
        return cases[_caseId];
    }

    function getAllCaseIds() public view returns (string[] memory) {
        return allCaseIds;
    }

    function archiveCase(string memory _caseId) 
        public 
        onlyOfficer 
        caseExistsMod(_caseId) 
    {
        Case storage c = cases[_caseId];
        require(c.status == CaseStatus.ACTIVE, "Case already closed");
        require(c.officer == msg.sender, "Only case officer can archive");
        
        string[] memory evidenceIds = caseEvidenceIds[_caseId];
        
        for (uint i = 0; i < evidenceIds.length; i++) {
            string memory evId = evidenceIds[i];
            Evidence storage ev = evidences[evId];
            
            require(
                ev.status == EvidenceStatus.VERIFIED || 
                ev.status == EvidenceStatus.REJECTED,
                "All evidence must be processed"
            );
            
            ev.status = EvidenceStatus.ARCHIVED;
            
            custodyHistory[evId].push(
                CustodyRecord(msg.sender, "ARCHIVED", block.timestamp)
            );
            
            emit EvidenceArchived(evId);
        }
        
        c.status = CaseStatus.CLOSED;
        c.closedAt = block.timestamp;
        
        emit CaseArchived(_caseId, msg.sender);
    }

    // ============ EVIDENCE FUNCTIONS ============
    function addEvidence(
        string memory _evidenceId,
        string memory _caseId,
        string memory _fileHash,
        string memory _fileURI
    ) public onlyOfficer caseExistsMod(_caseId) {
        require(cases[_caseId].status == CaseStatus.ACTIVE, "Case is closed");
        require(evidences[_evidenceId].createdAt == 0, "Evidence exists");
        require(bytes(hashToEvidenceId[_fileHash]).length == 0, "Hash already exists");

        evidences[_evidenceId] = Evidence({
            evidenceId: _evidenceId,
            caseId: _caseId,
            fileHash: _fileHash,
            fileURI: _fileURI,
            creator: msg.sender,
            createdAt: block.timestamp,
            status: EvidenceStatus.UPLOADED
        });

        custodyHistory[_evidenceId].push(
            CustodyRecord(msg.sender, "CREATED", block.timestamp)
        );

        caseEvidenceIds[_caseId].push(_evidenceId);
        hashToEvidenceId[_fileHash] = _evidenceId;
        
        allEvidenceIds.push(_evidenceId);

        emit EvidenceAdded(_evidenceId, msg.sender);
    }

    function startReview(string memory _id)
        public
        onlyAnalyst
        evidenceExists(_id)
    {
        Evidence storage ev = evidences[_id];
        require(ev.status == EvidenceStatus.UPLOADED, "Invalid status");

        ev.status = EvidenceStatus.UNDER_REVIEW;

        custodyHistory[_id].push(
            CustodyRecord(msg.sender, "REVIEW_STARTED", block.timestamp)
        );

        emit ReviewStarted(_id, msg.sender);
    }

    function markVerified(string memory _id)
        public
        onlyAnalyst
        evidenceExists(_id)
    {
        Evidence storage ev = evidences[_id];
        require(ev.status == EvidenceStatus.UNDER_REVIEW, "Not under review");

        ev.status = EvidenceStatus.VERIFIED;

        custodyHistory[_id].push(
            CustodyRecord(msg.sender, "VERIFIED", block.timestamp)
        );

        emit EvidenceVerified(_id, msg.sender);
    }

    function rejectEvidence(string memory _id)
        public
        onlyAnalyst
        evidenceExists(_id)
    {
        Evidence storage ev = evidences[_id];
        require(ev.status == EvidenceStatus.UNDER_REVIEW, "Not under review");

        ev.status = EvidenceStatus.REJECTED;

        custodyHistory[_id].push(
            CustodyRecord(msg.sender, "REJECTED", block.timestamp)
        );

        emit EvidenceRejected(_id, msg.sender);
    }

    // ============ VIEW FUNCTIONS ============
    function getEvidence(string memory _id)
        public
        view
        evidenceExists(_id)
        returns (Evidence memory)
    {
        return evidences[_id];
    }

    function getCustodyHistory(string memory _id)
        public
        view
        evidenceExists(_id)
        returns (CustodyRecord[] memory)
    {
        return custodyHistory[_id];
    }

    function getEvidenceByCase(string memory _caseId)
        public
        view
        caseExistsMod(_caseId)
        returns (string[] memory)
    {
        return caseEvidenceIds[_caseId];
    }

    function getAllEvidenceIds() public view returns (string[] memory) {
        return allEvidenceIds;
    }

    function verifyEvidence(string memory _hash)
        public
        view
        onlyCourt
        returns (bool exists, string memory evidenceId)
    {
        evidenceId = hashToEvidenceId[_hash];
        return (bytes(evidenceId).length > 0, evidenceId);
    }
}