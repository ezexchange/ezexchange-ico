// Inject our version (1.0.0-beta.33) of web3.js into the DApp.
window.addEventListener('load', function () {
    // Checking if Web3 provider is available (Mist/MetaMask)
    if (typeof Web3.givenProvider !== 'undefined') {
        let web3 = new Web3(Web3.givenProvider || web3.currentProvider);
        console.log('Using Web3 Version:', web3.version);
        if(web3._provider.isMetaMask) {
            // Check if Metamask is available
            console.log('Got MetaMask! Hurray');
        }
    } else {
        console.log('Please Use Metamask extension to transact in ETH.');
        web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/"));
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        // web3 = new Web3(new Web3.providers.WebsocketProvider('wss://mainnet.infura.io/ws'));
    }
    startApp();
});

function startDApp() {
    // On Load Functionality was not working, hence temp fix
    web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/"));
    startApp();
}

async function initDApp() {
    let coinbaseAccount = getCoinbase();
    window.walletAddress = coinbaseAccount;
    window.EZXTokenContract = new web3.eth.Contract(EZXICOContractABI, EZXICOContractAddress, {
        from: coinbaseAccount,
        gasPrice: '20000000000'                 // default gas price in wei, 20 gwei in this case
    });
}

function getETHBalance() {
    return new Promise(resolve => {
        web3.eth.getBalance(walletAddress, (error, result) => {
            if (!error) {
                console.log(web3.utils.fromWei(result, "ether"));
                resolve(web3.utils.fromWei(result, "ether"));
            } else {
                resolve(error);
            }
        });
    });
}

function getEZXBalance() {
    return new Promise(resolve => {
        EZXTokenContract.methods.balanceOf(walletAddress).call((error, result) => {
            if (!error) {
                console.log(web3.utils.fromWei(result, "ether"));
                resolve(web3.utils.fromWei(result, "ether"));
            } else {
                resolve(error);
            }
        });
    });
}

function getCoinbase() {
    //return document.getElementById('accountAddress').innerHTML;
    return "0x86ccc22e01cdbaff1b78b246d67e07fa00116436";
}

async function fetchAccountDetails() {
    let walletETHBalance = await getETHBalance();
    document.getElementById('etherBalance').innerHTML = walletETHBalance;
    let walletEZXBalance = await getEZXBalance();
    document.getElementById('tokenBalance').innerHTML = walletEZXBalance;
}
