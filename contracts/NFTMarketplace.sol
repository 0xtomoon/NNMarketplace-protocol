//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IERC20Burnable.sol";
import "./interface/IERC721Burnable.sol";
import "./interface/INFTB.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract NFTMarketplace is Initializable, ERC1155Holder, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using AddressUpgradeable for address;
    
    IERC20 public mkpToken;
    IERC20Burnable public gemToken;
    IERC721Burnable public nftA;
    INFTB public nftB;

    uint256 public constant FEE = 5;
    uint256 public constant UPGRADE_GEM_AMOUNT = 1000 * 10**18;
    uint256 public constant UPGRADE_COOLDOWN = 14 days;

    struct ServiceProviders {
        address provider1;
        address provider2;
        address provider3;
    }
    
    ServiceProviders public serviceProviders;

    struct SaleInfo {
        uint256 price;
        bool isListed;
    }
    mapping(uint256 => SaleInfo) public saleInfos;
    mapping(uint256 => uint256) public nftBUnlockTime;

    // @notice Emitted after successful NFT list
    // @param tokenId The tokenId of NFT which is listed
    // @param price The amount of sale price
    // @param seller The address of seller
    event NFTAListed(uint256 indexed tokenId, uint256 price, address indexed seller);

    // @notice Emitted after successful NFT purchase
    // @param tokenId The tokenId of NFT which is listed
    // @param price The amount of sale price
    // @param buyer The address of buyer
    event NFTASold(uint256 indexed tokenId, uint256 price, address indexed buyer);

    // @notice Emitted after successful NFT upgrade
    // @param tokenId The tokenId of NFT which is upgraded
    // @param owner The address of owner
    event NFTAUpgraded(uint256 indexed tokenId, address indexed owner);

    modifier isListed(uint256 tokenId) {
        require(saleInfos[tokenId].isListed, "The NFT is not currently available for sale");
        _;
    }

    function initialize(
        address _mkpToken,
        address _gemToken,
        address _nftA,
        address _nftB,
        address _provider1,
        address _provider2,
        address _provider3
    ) public initializer {
        __Ownable_init();
        mkpToken = IERC20(_mkpToken);
        gemToken = IERC20Burnable(_gemToken);
        nftA = IERC721Burnable(_nftA);
        nftB = INFTB(_nftB);
        serviceProviders.provider1 = _provider1;
        serviceProviders.provider2 = _provider2;
        serviceProviders.provider3 = _provider3;
    }

    // @notice List NFT
    // @param tokenId The tokenId of NFT to be listed
    // @param price The amount of sale price
    function listNFT(uint256 tokenId, uint256 price) external {
        require(price != 0, "Price must be greater than zero");
        require(!saleInfos[tokenId].isListed, "NFT is already listed for sale");
        saleInfos[tokenId].price = price;
        saleInfos[tokenId].isListed = true;
        emit NFTAListed(tokenId, price, msg.sender);
    }

    // @notice Purchase NFT of tokenID
    // @param tokenId The tokenId of NFT to be purchased
    function purchaseNFT(uint256 tokenId) external isListed(tokenId) nonReentrant {
        address seller = nftA.ownerOf(tokenId);
        uint256 price = saleInfos[tokenId].price;
        uint256 feeAmount = price * FEE / 100;
        uint256 sellerAmount = price - feeAmount;
        uint256 serviceProviderFee = feeAmount / 3;

        // Transfer MKP token to seller
        mkpToken.transferFrom(msg.sender, seller, sellerAmount);

        // Transfer NFT to buyer
        nftA.transferFrom(seller, msg.sender, tokenId);

        // Transfer fee to service providers
        mkpToken.transferFrom(msg.sender, serviceProviders.provider1, serviceProviderFee);
        mkpToken.transferFrom(msg.sender, serviceProviders.provider2, serviceProviderFee);
        mkpToken.transferFrom(msg.sender, serviceProviders.provider3, serviceProviderFee);

        // Initialize the status
        saleInfos[tokenId].price = 0;
        saleInfos[tokenId].isListed = false;

        emit NFTASold(tokenId, price, msg.sender);
    }
    
    // @notice Upgrade NFT of tokenID
    // @param tokenId The tokenId of NFT to be upgraded
    function upgradeNFT(uint256 tokenId) external nonReentrant {
        require(!saleInfos[tokenId].isListed, "NFT is listed for sale");
        require(gemToken.balanceOf(msg.sender) >= UPGRADE_GEM_AMOUNT, "Not enough gem");
        
        // Burn nftA and gem
        nftA.burn(tokenId);
        gemToken.burnFrom(msg.sender, UPGRADE_GEM_AMOUNT);

        // Mint nftB
        nftB.mint(msg.sender, tokenId, 1, "");
        // NFT B will be locked for 14 days
        nftBUnlockTime[tokenId] = block.timestamp + UPGRADE_COOLDOWN;
        
        emit NFTAUpgraded(tokenId, msg.sender);
    }
}