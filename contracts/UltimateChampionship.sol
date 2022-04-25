// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./GameData.sol";
import "./Administrator.sol";

contract UltimateChampionship is ERC721Enumerable, GameData, Administrator {
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    string public baseImageExtension = ".png";

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public cost = 0.00003 ether;
    uint256 public maxSupply = 8888;
    uint256 public maxMintAmount = 1;

    uint256 public nftPerAddressLimit = 5;
    uint256 public presalePrice = 0.00002 ether;
    uint256 public presaleSupply = 5000;
    uint256 public whitelistMaxMint = 5;

    Fighter[] internal fighters;

    mapping(address => uint256) public addressMintedBalance;

    mapping(address => bool) public onWhitelist;
    mapping(address => uint256) public whitelistClaimedBy;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseUri
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseUri);
        _tokenIds.increment();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // Whitelist

    function addToWhitelist(address[] calldata addresses) external onlyAdmin {
        for (uint256 i = 0; i < addresses.length; i++) {
            onWhitelist[addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] calldata addresses)
        external
        onlyAdmin
    {
        for (uint256 i = 0; i < addresses.length; i++) {
            onWhitelist[addresses[i]] = false;
        }
    }

    function presale(uint256 _maxEnergy) external payable whitelistIsActive {
        uint256 supply = totalSupply();

        require(supply <= presaleSupply, "Presale is sold out.");
        require(onWhitelist[msg.sender], "You are not in whitelist");
        require(
            whitelistClaimedBy[msg.sender] + maxMintAmount <= whitelistMaxMint,
            "Purchase exceeds max allowed"
        );
        require(msg.value >= presalePrice, "try ton send more ETH");

        uint256 itemId = _tokenIds.current();

        Fighter memory fighter = Fighter(itemId, 0, 5, _maxEnergy);

        fighters.push(fighter);

        whitelistClaimedBy[msg.sender] += maxMintAmount;

        _safeMint(msg.sender, itemId);
        _tokenIds.increment();
    }

    //public

    function mint(uint256 _maxEnergy) public payable contractIsActive {
        uint256 supply = totalSupply();

        require(supply + 1 <= maxSupply, "max NFT limit exceeded");
        require(msg.value >= cost, "insufficient funds");
        require(
            balanceOf(msg.sender) < nftPerAddressLimit,
            "Max NFT per wallet exceeded"
        );

        uint256 itemId = _tokenIds.current();

        Fighter memory fighter = Fighter(itemId, 0, 5, _maxEnergy);

        fighters.push(fighter);

        _safeMint(msg.sender, itemId);
        _tokenIds.increment();
    }

    // show the wallet of owner
    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerToken = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerToken);
        for (uint256 i; i < ownerToken; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        require(bytes(currentBaseURI).length > 0, "Error: Wrong baseURI");

        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    // Airdrop

    // Send NFTs to a address
    function giftNft(address _sendTo, uint256 _howMany) external onlyAdmin {
        require(
            totalSupply() + _howMany <= maxSupply,
            "Max NFT limit exceeded"
        );

        _safeMint(_sendTo, _howMany);
    }

    // Admin function

    function setBaseURI(string memory _newBaseURI) public onlyAdmin {
        baseURI = _newBaseURI;
    }

    function setCost(uint256 _newCost) public onlyAdmin {
        cost = _newCost;
    }

    function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyAdmin {
        maxMintAmount = _newMaxMintAmount;
    }

    function setNftPerAddressLimit(uint256 _newNftPerAddressLimit)
        public
        onlyAdmin
    {
        nftPerAddressLimit = _newNftPerAddressLimit;
    }

    function setWhitelistMaxMint(uint256 _newWhitelistMaxMint)
        external
        onlyAdmin
    {
        whitelistMaxMint = _newWhitelistMaxMint;
    }

    function setPresalePrice(uint256 _newPresalePrice) external onlyAdmin {
        presalePrice = _newPresalePrice;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
