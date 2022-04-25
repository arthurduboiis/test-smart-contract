pragma solidity ^0.8.0;

//@author BringStorming
//@title USCNFT


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

import "./ERC721A.sol";

contract NFTERC721A is Ownable, ERC721A, PaymentSplitter {

    using Strings for uint;

    enum Step { 
        Before,
        WhitelistSale,
        PublicSale,
        SoldOut,
        Reveal
    }

    string public baseURI;

    Step public sellingStep;

    uint private constant MAX_SUPPLY = 8888;
    uint private constant MAX_WHITELIST = 2888;
    uint private constant MAX_PUBLIC = 5900;
    uint private constant MAX_GIFT = 100;
    uint private constant MAX_MINT_PER_WHITELIST = 1;

    uint public wlSalePrice = 0.00020 ether;
    uint public publicSalePrice = 0.00030 ether;

    bytes32 public merkleRoot;

    uint public saleStartTime = 1655114400;

    mapping(address => uint) public amountNFTSperWalletWhitelistSale;

    uint private teamLength;

    constructor(address[] memory _team, uint[] memory _teamShares, bytes32 _merkleRoot, string memory _baseURI)
    ERC721A("Ultimate Solana Championship", "USC")
    PaymentSplitter(_team, _teamShares) {
        merkleRoot = _merkleRoot;
        baseURI = _baseURI;
        teamLength = _team.length;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable callerIsUser {
        uint price = wlSalePrice;
        require(price != 0, "price is 0");
        //require(currentTime() >= saleStartTime, "Presale has not started yet");
        //require(currentTime() < saleStartTime + 300 minutes, "whitelist sale is finished");
        require(sellingStep == Step.WhitelistSale, "Whitelist sale is not activated");
        require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
        require(amountNFTSperWalletWhitelistSale[msg.sender] + _quantity <= MAX_MINT_PER_WHITELIST,"You can only mint 1 NFT on the whitelist Sale");
        require(totalSupply() + _quantity <= MAX_WHITELIST, "Max supply exceeded");
        require(msg.value >= price * _quantity, "Not enought funds");
        amountNFTSperWalletWhitelistSale[msg.sender] += _quantity;
        _safeMint(_account, _quantity);
    }


    // need new mapping if it is not infinite mint when public sale
    function publicSaleMint(address _account, uint _quantity) external payable callerIsUser {
        uint price = publicSalePrice;
        require(price != 0, "Price is 0");
        require(sellingStep == Step.PublicSale, "Public sale is not activate");
        require(totalSupply() + _quantity <= MAX_PUBLIC, "max supply exceeded");
        require(msg.value >= price * _quantity, "Not enought funds");
        _safeMint(_account, _quantity);
    }

    function gift(address _to, uint _quantity) external onlyOwner {
        require(sellingStep > Step.PublicSale, "Gift is after the public sale"); // show when you want to gift an NFT
        require(totalSupply() + _quantity <= MAX_SUPPLY, "Reached max supply");
        _safeMint(_to, _quantity);
    }

    function setSaleStartTime(uint _saleStartTime) external onlyOwner {
        saleStartTime = _saleStartTime;
    }

    function currentTime() internal view returns(uint) {
        return block.timestamp;
    }

    function setStep(uint _step) external onlyOwner{
        sellingStep = Step(_step);
    }

    function getWlSalePrice() public view returns(uint){
        return wlSalePrice;
    }

    function getPublicSalePrice() public view returns(uint) {
        return publicSalePrice;
    }

    function tokenURI(uint _tokenId) public view virtual override returns(string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token ");

        return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
    }

    //whitelist
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
        return _verify(leaf(_account), _proof);
    }

    function leaf(address _account) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(_account));
    }

    function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
        return MerkleProof.verify(_proof, merkleRoot, _leaf);
    }

}