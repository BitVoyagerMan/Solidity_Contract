

pragma solidity ^0.8.9;
import "./DateTime.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./MyToken.sol";

contract Token {
    address public owner;
    address[] public users; 
    bool isTopToBottom = true;

    
    uint tomonth_total_variable_score;
    uint max_role = 0;

    MyToken usdt = MyToken(0xb37a89580231d8a0C47518e6E311473816c48e9D);

    mapping(uint => address[]) public roles;
    mapping(address => uint) public fixed_score;
    mapping(address => uint) public variable_score;

    event withdraw_fixed_pay_event(address indexed _from, address indexed _to, uint256 _value);
    event withdraw_variable_pay_event(address indexed _from, address indexed _to, uint256 _value);
    event User_Added(address indexed user,  uint role);
    event Fixed_Score_set(uint score);
    event Variable_Score_set(uint score);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owners are allowed!!!!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
    function getDay(uint256 timestamp) public pure returns (uint256 day) {
        day = DateTime.getDay(timestamp);
    }

    function _calculate_variable_pay_amount() onlyOwner private {
        
        uint temp = tomonth_total_variable_score ;
        if(isTopToBottom == true){
           for(uint i = max_role; i > 0; i --){
                
                if(roles[i].length > 0){
                    temp /= 2;
                    for(uint j = 0; j < roles[i].length; j ++){
                        variable_score[roles[i][j]] = temp / roles[i].length;

                        usdt.approve(roles[i][j], fixed_score[roles[i][j]] + variable_score[roles[i][j]]);
                    }
                }
            }
        }else{
            for(uint i = 1; i <= max_role;  i ++){
                if(roles[i].length > 0){
                    temp /= 2;
                    for(uint j = 0; j < roles[i].length; j ++){
                        variable_score[roles[i][j]] = temp / roles[i].length;
                        usdt.approve(roles[i][j], fixed_score[roles[i][j]] + variable_score[roles[i][j]]);
                    }
                }
            }
        }
    }

    function addUser(address user, uint role) onlyOwner public  {
        users.push(user);
        roles[role].push(user);
        if(max_role < role) max_role = role;
        
        _calculate_variable_pay_amount();
        emit User_Added(user, role);
    }
    function setVariableDirection(bool topToBottom) onlyOwner public  {
        isTopToBottom = topToBottom;
        _calculate_variable_pay_amount();
    }

    function setFixedMonthlyScore(uint fixedScore) onlyOwner public {
        for(uint i = 0; i < users.length; i ++){
            fixed_score[users[i]] = fixedScore;
            usdt.approve(users[i], fixed_score[users[i]] + variable_score[users[i]]);
        }
        emit Fixed_Score_set(fixedScore);
    }

    function setVariableMonthlyScore(uint variableScore) onlyOwner public  {
        tomonth_total_variable_score = variableScore;
        _calculate_variable_pay_amount();
        emit Variable_Score_set(tomonth_total_variable_score);
    }

    function withdraw_fixed_pay() public  {
        uint timestamp = block.timestamp;
        //if(getDay(timestamp) == 1){
            usdt.transferFrom(owner, msg.sender, fixed_score[msg.sender]);
            //emit withdraw_fixed_pay_event(owner, msg.sender, fixed_score[msg.sender]);
            fixed_score[msg.sender] = 0;
        //}
    }

    function withdraw_variable_pay() public {
        uint256 timestamp = block.timestamp;
        //if(getDay(timestamp) == 15){
            usdt.transferFrom(owner, msg.sender, variable_score[msg.sender]);
            //emit  withdraw_variable_pay_event(owner, msg.sender, variable_score[msg.sender]);
            variable_score[msg.sender] = 0;
        //}
    }
}