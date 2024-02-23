// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SocialFi is Ownable {
    struct Article {
        address author;
        string content;
        uint256 upvotes;
    }

    mapping(uint256 => Article) public articles;
    uint256 private nextArticleId;

    event ArticlePublished(uint256 articleId, address author);
    event ArticleUpvoted(uint256 articleId, address voter);

    // Publishes an article with the provided content
    function publishArticle(string memory _content) public {
        articles[nextArticleId] = Article(msg.sender, _content, 0);
        emit ArticlePublished(nextArticleId, msg.sender);
        nextArticleId++;
    }

    // Upvotes an article, increasing its upvote count
    function upvoteArticle(uint256 _articleId) public {
        require(_articleId < nextArticleId, "Invalid article ID");
        articles[_articleId].upvotes++;
        emit ArticleUpvoted(_articleId, msg.sender);
    }

    // Allows the contract owner to withdraw any ERC20 tokens sent to the contract
    function withdrawTokens(address _token, address _to, uint256 _amount) public onlyOwner {
        IERC20(_token).transfer(_to, _amount);
    }
}