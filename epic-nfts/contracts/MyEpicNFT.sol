// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {Base64} from "./libraries/Base64.sol";

// Console.log library
import "hardhat/console.sol";

// inherit an OpenZepellin contract - prevents boiler plate
contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    mapping(string => string[]) words;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[][] wordSet = [
        [
            "Satisfying",
            "Writer",
            "Trees",
            "Right",
            "Ritzy",
            "Edge",
            "Industrious",
            "Muddled",
            "Arrange",
            "Pathetic",
            "Drink",
            "Craven"
        ],
        [
            "Flag",
            "Error",
            "Healthy",
            "Homeless",
            "Apparatus",
            "Offer",
            "Guiltless",
            "Undesirable",
            "Fireman",
            "Entertaining",
            "Unkempt",
            "Annoy"
        ],
        [
            "Absorbing",
            "Squalid",
            "Meek",
            "Sticky",
            "Crabby",
            "Wealthy",
            "Soda",
            "Sweet",
            "Wakeful",
            "Zebra",
            "Stereotyped",
            "Obnoxious"
        ]
    ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("this is my NFT contract");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomWordFromList(uint256 tokenId, uint256 listNumber)
        public
        view
        returns (string memory)
    {
        string memory listName = "";
        if (listNumber == 0) {
            listName = "FIRST_WORDS";
        } else if (listNumber == 1) {
            listName = "SECOND_WORDS";
        } else {
            listName = "THIRD_WORDS";
        }

        string[] memory wordSetToUse = wordSet[listNumber];

        uint256 rand = random(
            string(abi.encodePacked(listName, Strings.toString(tokenId)))
        );

        rand = rand % wordSetToUse.length;
        console.log("rand number: %d", rand);
        return wordSetToUse[rand];
    }

    function makeEnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWordFromList(newItemId, 0);
        string memory second = pickRandomWordFromList(newItemId, 1);
        string memory third = pickRandomWordFromList(newItemId, 2);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory metadata = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", metadata)
        );

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "NFT id: %s | minted_to: %s | uri: %s",
            newItemId,
            msg.sender,
            finalTokenUri
        );

        _tokenIds.increment();
    }
}
