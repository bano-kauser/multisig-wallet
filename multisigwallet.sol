pragma solidity 0.8.17;
pragma abicoder v2;
 
 contract Wallet {

     address[] public owners;
     uint limit;

      modifier onlyOwners(){
         bool owner = false;
         for(uint i=0; i<=owners.length; i++){
             if(owners[1] == msg.sender){
                 owner = true;
             }
         }
         require(owner == true);
         _;

     }

     constructor(address[] memory _owners, uint _limit){
         owners = _owners;
         limit = _limit;

     }
    
     function deposit() public payable {}
     struct Transfer{
         uint amount;
         address payable receiver;
         uint approvals;
         bool hasBeenSent;
         uint id;
     }
      event transferRequestsCreated(uint _id , uint _amount, address _initiator, address _receiver);
      event approvalsReceived(uint _id, uint _approval, address _approver);
      event transferApproved(uint _id);


     Transfer[] transferRequests;

      

     function createTransfer(uint _amount, address payable _receiver)public onlyOwners{
       emit transferRequestsCreated (transferRequests.length, _amount,msg.sender, _receiver);
         transferRequests.push(Transfer( _amount, _receiver,0,false, transferRequests.length));
     }
     mapping(address => mapping(uint => bool)) approvals;
     
      function approve(uint _id)public onlyOwners{
         
         
           require(transferRequests[_id].hasBeenSent ==false);
            require(approvals[msg.sender][_id] == false,"you already voted");
          approvals[msg.sender][_id] = true;
          transferRequests[_id].approvals++;

          if(transferRequests[_id].approvals >= limit){
              transferRequests[_id].hasBeenSent = true;
              transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
          }
          
          }

          function getTransferRequests()public view returns(Transfer[] memory){
             return transferRequests; 

          
          }

          function getBalance()public view returns(uint){
               return address(this).balance;


      }



 }
 