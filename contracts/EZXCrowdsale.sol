pragma solidity 0.4.23;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract ERC20 {
  function totalSupply()public view returns (uint total_Supply);
  function balanceOf(address who)public view returns (uint256);
  function allowance(address owner, address spender)public view returns (uint);
  function transferFrom(address from, address to, uint value)public returns (bool ok);
  function approve(address spender, uint value)public returns (bool ok);
  function transfer(address to, uint value)public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}


contract EZExchange is ERC20
{ 
	using SafeMath for uint256;
	
    // Name of the token
    string public constant name = "EZ Exchange";

    // Symbol of token
    string public constant symbol = "EZX";
    uint8 public constant decimals = 18;
    uint public _totalsupply = 200000000 * 10 ** 18; // 200 Million total supply // muliplies dues to decimal precision
    address public owner;                    // Owner of this contract
    uint256 public _price_tokn; 
    uint256 no_of_tokens;
    uint256 bonus_token;
    uint256 total_token;
    bool stopped = false;
    uint256 public pre_startdate;
    uint256 public ico1_startdate;
    uint256 public ico2_startdate;
    uint256 public ico3_startdate;
    uint256 public ico4_startdate;
    uint256 pre_enddate;
    uint256 ico1_enddate;
    uint256 ico2_enddate;
    uint256 ico3_enddate;
    uint256 ico4_enddate;
    uint256 maxCap_PRE;
    uint256 maxCap_ICO1;
    uint256 maxCap_ICO2;
    uint256 maxCap_ICO3;
    uint256 maxCap_ICO4;
    
    bool public lockstatus; 
    
    uint public priceFactor;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint bon;
    uint public bonus;
    
     enum Stages 
	 {
        NOTSTARTED,
        PREICO,
        ICO1,
        ICO2,
        ICO3,
        ICO4,
        PAUSED,
        ENDED
	 }
    Stages public stage;
    
    modifier atStage(Stages _stage) {
        require (stage == _stage);
        _;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
     _;
    }
    
  constructor (uint256 EtherPriceFactor) public
    {
         require(EtherPriceFactor != 0);
        owner = msg.sender;
        balances[owner] = 80000000 * 10 **18; // 80 million to owner
        stage = Stages.NOTSTARTED;
        lockstatus = true;
        priceFactor = EtherPriceFactor;
      emit  Transfer(0, owner, balances[owner]);
    }
  
   function setpricefactor(uint256 newPricefactor) external onlyOwner
    {
        priceFactor = newPricefactor;
    }
    function () public payable 
    {
        require(stage != Stages.ENDED);
        require(!stopped && msg.sender != owner);
        no_of_tokens = ((msg.value).mul(priceFactor.mul(100))).div(_price_tokn);
        bonus = bonuscal();
        bonus_token = ((no_of_tokens).mul(bonus)).div(100); 
        total_token = no_of_tokens + bonus_token;
        transferTokens(msg.sender,total_token);
       
    }
    //bonuc calculation for preico on per day basis
     function bonuscal() private returns (uint256 cp)
        {
           if( stage == Stages.PREICO && now <= pre_enddate )
            { 
               bon = 40;
            }
               
            else if(stage == Stages.ICO1 && now <= ico1_enddate )
            {
              bon = 30;
            }
            else if(stage == Stages.ICO2 && now <= ico2_enddate)
            {
              bon = 20;
            }
             else if(stage == Stages.ICO3 && now <= ico3_enddate)
            {
              bon = 10;
            }
             else if(stage == Stages.ICO4 && now <= ico4_enddate)
            {
               bon = 0;
            }
              else
           {
            revert();
           }
            return bon;
        }
    
  
     function start_PREICO() public onlyOwner atStage(Stages.NOTSTARTED)
      {
          stage = Stages.PREICO;
          stopped = false;
          maxCap_PRE = 20000000 * 10 **18;  // 20 million
           balances[address(this)] = maxCap_PRE;
          pre_startdate = now;
          pre_enddate = now + 30 days;
          _price_tokn = 30; // Price in Cents
        emit  Transfer(0, address(this), maxCap_PRE);
          }
      
      function start_ICO1() public onlyOwner atStage(Stages.PREICO)
      {
         
          require(now > pre_enddate || balances[address(this)] == 0);
          stage = Stages.ICO1;
          stopped = false;
          maxCap_ICO1 = 25000000 * 10 **18; // 25 million
          balances[address(this)] = (balances[address(this)]).add(maxCap_ICO1) ;
          ico1_startdate = now;
          ico1_enddate = now + 7 days;
           _price_tokn = 40; // Price in Cents
        emit  Transfer(0, address(this), maxCap_ICO1);
      }
    
    function start_ICO2() public onlyOwner atStage(Stages.ICO1)
      {
          
          require(now > ico1_enddate || balances[address(this)] == 0);
          stage = Stages.ICO2;
          stopped = false;
          maxCap_ICO2 = 25000000 * 10 **18; // 25 million
          balances[address(this)] = (balances[address(this)]).add(maxCap_ICO2) ;
          ico2_startdate = now;     
          ico2_enddate = now + 7 days;
        emit  Transfer(0, address(this), maxCap_ICO2);
          
      }
      
       
    function start_ICO3() public onlyOwner atStage(Stages.ICO2)
      {
         
          require(now > ico2_enddate || balances[address(this)] == 0);
          stage = Stages.ICO3;
          stopped = false;
          maxCap_ICO3 = 25000000 * 10 **18; // 25 million
          balances[address(this)] = (balances[address(this)]).add(maxCap_ICO3) ;
          ico3_startdate = now;     
          ico3_enddate = now + 7 days;
         emit Transfer(0, address(this), maxCap_ICO3);
          
      }
      
       function start_ICO4() public onlyOwner atStage(Stages.ICO3)
      {
        
          require(now > ico3_enddate || balances[address(this)] == 0);
          stage = Stages.ICO4;
          stopped = false;
          maxCap_ICO4 = 25000000 * 10 **18; // 25 million
          balances[address(this)] = (balances[address(this)]).add(maxCap_ICO4) ;
          ico4_startdate = now;     
          ico4_enddate =now + 7 days;
         emit Transfer(0, address(this),maxCap_ICO4);
          
      }
    
     
    // called by the owner, pause ICO
    function PauseICO() external onlyOwner
    {
        stopped = true;
       }

    // called by the owner , resumes ICO
    function ResumeICO() external onlyOwner
    {
        stopped = false;
    }
   
     
     
      function end_ICO() external onlyOwner atStage(Stages.ICO4)
     {
        
         require(now > ico4_enddate || balances[address(this)] == 0);
         stage = Stages.ENDED;
         uint256 x = balances[address(this)];
         lockstatus = false;
         balances[owner] = (balances[owner]).add( balances[address(this)]);
         balances[address(this)] = 0;
         emit Transfer(address(this), owner , x);
        
     }
	 
	 // what is the total supply of the ech tokens
     function totalSupply() public view returns (uint256 total_Supply) {
         total_Supply = _totalsupply;
     }
    
     // What is the balance of a particular account?
     function balanceOf(address _owner)public view returns (uint256 balance) {
         return balances[_owner];
     }
    
     // Send _value amount of tokens from address _from to address _to
     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
     // fees in sub-currencies; the command should fail unless the _from account has
     // deliberately authorized the sender of the message via some mechanism; we propose
     // these standardized APIs for approval:
     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
     require( _to != 0x0);
     require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
     balances[_from] = (balances[_from]).sub(_amount);
     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
     balances[_to] = (balances[_to]).add(_amount);
    emit Transfer(_from, _to, _amount);
     return true;
         }
    
     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
     // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount)public returns (bool success) {
         require( _spender != 0x0 && !lockstatus);
         allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
         require( _owner != 0x0 && _spender !=0x0);
         return allowed[_owner][_spender];
     }

     // Transfer the balance from owner's account to another account
     function transfer(address _to, uint256 _amount)public returns (bool success) {
         if ( msg.sender == owner) {
            require(balances[owner] >= _amount && _amount >= 0);
            balances[owner] = balances[owner].sub(_amount);
            balances[_to] += _amount;
            emit Transfer(msg.sender, _to, _amount);
            return true;
        }
        else if(!lockstatus)
         {
           require(balances[msg.sender] >= _amount && _amount >= 0);
           balances[msg.sender] = (balances[msg.sender]).sub(_amount);
           balances[_to] = (balances[_to]).add(_amount);
           emit Transfer(msg.sender, _to, _amount);
           return true;
          }

        else{
            revert();
        }
         }
    
          // Transfer the balance from owner's account to another account
    function transferTokens(address _to, uint256 _amount) private returns(bool success) {
        require( _to != 0x0);       
        require(balances[address(this)] >= _amount && _amount > 0);
        balances[address(this)] = (balances[address(this)]).sub(_amount);
        balances[_to] = (balances[_to]).add(_amount);
       emit Transfer(address(this), _to, _amount);
        return true;
        }

    
    function drain() external onlyOwner {
        address myAddress = this;
        owner.transfer(myAddress.balance);
       
    }
    
}