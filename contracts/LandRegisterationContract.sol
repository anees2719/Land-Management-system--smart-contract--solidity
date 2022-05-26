//SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0<0.9.0;


contract LandRegisteration{

    
    struct landRegistery{
        uint landId;
        string area;
        string city;
        string state;
        uint landPrice;
        address propertyPID;
        bool status;

    }


    struct landInspector{
        address id;
        string name;
        uint age;
        string designation;
    }

    landInspector public inspector;


    struct seller{
        string name;
        uint age;
        string city;
        string CNIC;
        string email;
        bool status;
    }

    struct buyer{
        string name;
        uint age;
        string city;
        string CNIC;
        string email;
        bool status;
    }


    mapping (uint=>landRegistery) lands;
    mapping (address=>landInspector) public landInspectors;
    mapping (address=>seller) public sellers;
    mapping (address=>buyer) buyers;

    seller[] sellerArray;
    buyer[] buyerArray;

    constructor(string memory _name, uint _age, string memory _designation ){
        inspector=landInspector(msg.sender,_name,_age,_designation);
        landInspectors[msg.sender] =inspector;
    
    }

    
    modifier onlyInspector() {
        require(msg.sender==inspector.id,'You are not the owner');
        _;
    }

    function verifySeller(address _seller) public onlyInspector(){
        sellers[_seller].status=true;

    }

    function verifyBuyer(address _buyer) public onlyInspector(){
        buyers[_buyer].status=true;
    }

    function verifyLand(uint _landId) public onlyInspector(){
        lands[_landId].status=true;
    }

    function isSeller(address _seller) public view returns(seller memory){
       return sellers[_seller];


    }
    
    function isBuyer(address _buyer) public view returns(buyer memory){
        return buyers[_buyer];
    }

    function isSellerVerified(address _seller) public view returns(bool){
        return sellers[_seller].status;
    }

    function isBuyerVerified(address _buyer) public  view returns(bool){
        return buyers[_buyer].status;
    }

    function isLandVerified(uint _landId) public view returns(bool){
        return lands[_landId].status;
    }

    function LandOwner(uint _landId) public view returns(address){
        return(lands[_landId].propertyPID);
    }

    function getLandCity(uint _landId) public view returns(string memory){
        return(lands[_landId].city);

    }

    function getLandArea(uint _landId) public view returns(string memory){
        return(lands[_landId].area);

    }

    function getLandPrice(uint _landId) public view returns(uint){
        return(lands[_landId].landPrice);

    }



    function registerSeller(string memory _name,uint _age,string memory _city,string memory _CNIC,string memory _email)public  {
   
        seller memory newSeller=seller(_name,_age,_city,_CNIC,_email,false);
        sellerArray.push(newSeller);
        sellers[msg.sender]=newSeller;
    }
    

    function registerBuyer(string memory _name,uint _age,string memory _city,string memory _CNIC,string memory _email)public  {
   
        buyer memory newBuyer=buyer(_name,_age,_city,_CNIC,_email,false);
        buyerArray.push(newBuyer);
        buyers[msg.sender]=newBuyer;
    }

    function registerLand(uint _landId, string memory _area,string memory _city, string memory _state, uint _landPrice) public {
        require(isSellerVerified(msg.sender), " Seller is not verified");
        landRegistery memory newLand=landRegistery(_landId,_area,_city,_state,_landPrice,msg.sender,false);
        lands[_landId]=newLand;
    }

    function buyLand(uint _landId) public payable {
        
        address payable _buyer= payable(msg.sender);
        address payable landOwner=payable(lands[_landId].propertyPID);

        require(isBuyerVerified(_buyer),"Buyer is not verified");
        require(isLandVerified(_landId),"Land is not verified");

        require(msg.value>=lands[_landId].landPrice);

        landOwner.transfer(msg.value);
        
        lands[_landId].propertyPID=_buyer;

    }


    function transferOwnerShip(uint _landId, address _receiver) public {

        require(LandOwner(_landId)==msg.sender,"You are not the owner of this land");
        require(lands[_landId].status,"Land is not verified");
        lands[_landId].propertyPID=_receiver;

    }








    









}