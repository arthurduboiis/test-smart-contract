const CONTRACT_ADDRESS = "0xF876da1FE731f2E8535Cb76a054400CbC455Cf50";
//0xd27d0110B3683f8E840d3044E9D0c59a17B26D18
const CHAIN_ID = '0x4';
const paramChainPolygon = [
    {
        chainId: CHAIN_ID,
        rpcUrls: ["https://rpc-mainnet.matic.network/"],
        chainName: "Polygon Mainnet",
        nativeCurrency: {
            name: "MATIC",
            symbol: "MATIC",
            decimals: 18,
        },
        blockExplorerUrls: ["https://polygonscan.con/"],
    },
];

const paramChainRinkeby = [
    {
        chainId: CHAIN_ID,
        rpcUrls: ["https://rinkeby.infura.io/v3/"],
        chainName: "Rinkeby Testnet",
        nativeCurrency: {
            name: "ETH",
            symbol: "ETH",
            decimals: 8,
        },
        blockExplorerUrls: ["https://rinkeby.etherscan.io"]
    }
]

export { CONTRACT_ADDRESS, CHAIN_ID, paramChainRinkeby };