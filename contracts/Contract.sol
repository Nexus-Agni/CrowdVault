// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyContract {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping (uint256 => Campaign) public campaings;

    uint256 public numberOfCampaings = 0; 

    // Creating a campaign
    function createCampaign (address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image ) public returns (uint256) {

        Campaign storage campaign = campaings[numberOfCampaings];

        require(campaign.deadline > block.timestamp, "Deadline should be a date in the future");

        campaign.title = _title;
        campaign.owner = _owner;
        campaign.deadline = _deadline;
        campaign.description = _description;
        campaign.target = _target;
        campaign.image = _image;

        numberOfCampaings++;
        return numberOfCampaings-1; 
    }

    // Donate to campaign 
    function donateToCampaign (uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaings[_id];

        campaign.donations.push(amount);
        campaign.donators.push(msg.sender);

        (bool success,) = payable (campaign.owner).call{value : amount}("");
        if (success) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // Fetch all donators
    function getDonators (uint256 _id) public view returns (address[] memory, uint256[] memory){
        return (campaings[_id].donators, campaings[_id].donations);
    }

    // Fetch all campaings
    function getCampaings () public view returns (Campaign[] memory) {
        Campaign[] memory allcampaings = new Campaign[](numberOfCampaings);

        for(uint i = 0; i < numberOfCampaings; i++) {
            Campaign storage item = campaings[i];
            allcampaings[i] = item;
        }

        return allcampaings;
    }
}