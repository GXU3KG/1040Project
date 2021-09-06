pragma solidity >=0.7.0 <0.9.0;

/**
 * 1040project V1  -chuanxiaocantbefuckedwith
 * this contract can get your in, b careful
 * 
 **/


 contract demo{
     
     address private owners_address;
     
    //  //Regist_fee
    //  uint256 regist_fee = 3 ether

    //client struct
     struct Client {           
         uint256 balance;
         address superior;
         uint256 level;
     }
     
     //the mapping of client addreses and client structs
     mapping (address => Client) client_map;

     
     //defined that the contract creater who will also be the top level client
     constructor () public payable {
         owners_address = msg.sender;
         client_map[owners_address] = Client(0, owners_address, 1);
     }
     
     modifier onlyOwner() { 
        require(
            msg.sender == owners_address,
            "Only Owner can call this."
        );
        _;
    }
    
    
    // registor
    
    function regist(address superior) public payable {
        require(
            msg.value >= 3 ether,
            "Require at lest 3 ether regist fee"
        );
        
        require(
            client_map[msg.sender].level == 0,
            "Address is registed."
        );
        
        //check if the superior exist 
        if(client_map[superior].level == 0){
            superior = owners_address;
        }
        
        client_map[msg.sender] = Client(0, superior, client_map[superior].level + 1);
        
        uint256 recive_fee = msg.value;
        
        //update superior's accont 
        address cur_vip = superior;
        uint cur_benefits;
        for(uint i=client_map[msg.sender].level; i>1; i--){
            cur_benefits = recive_fee / 3;
            if(cur_vip == owners_address){
                client_map[cur_vip].balance += recive_fee;
            }else{
                client_map[cur_vip].balance += cur_benefits;
            }
            recive_fee -= cur_benefits;
            cur_vip = client_map[cur_vip].superior;
        }
        
    }
    
    
    //function for clients to get their benefits
    function send_my_banefit_to_addr (address payable sender) public payable{
        uint _balance = client_map[msg.sender].balance;
        client_map[msg.sender].balance = 0;
        sender.transfer(_balance);
    }
    
    //  function change_owner (address owner) payable public onlyOwner{
    //      owners_address = owner;
    //  }
     
     
    //get updates
     function get_contract_balence () view public returns (uint) {
         return address(this).balance;
     }
     
     function get_user_balence (address user_address) view public returns (uint) {
         return client_map[user_address].balance;
     }
     
     function check_user_superior_address (address user_address) view public returns (address) {
         return client_map[user_address].superior;
     }
     
 }
