# INSPIRAX

## Introduction

INSPIRAX platform is aiming to create a new ecology of the digital content industry. 

Recently, NFT has entered an explosive period. This greatly helps the entire digital content product market, and it has great power to lead the market to a new stage. 

However, piracy and misappropriation in the digital content product market have become a prominent problem. So far, NFT, as the “rights certificate” on the blockchain is separated from the digital content product it represents, these two has no connection with each other. 

INSPIRAX utilizes SOUNDLINKS technology to implant indelible SOUNDLINKS DNA into audio and video works, and registers SOUNDLINKS DNA with the DRM information of audio and video products in NFT, so that the audio and video products offchain and the rights certificates onchain are anchored. When audio and video products are played back on traditional social media and content platforms, the SOUNDLINKS DNA can be detected and directed to the blockchain to verify the rights. 

Many unique brands, contents and IPs have been joining with us in such a great march. We welcome more participation from all of you.

## What is Soundlinks DNA ?
Verification protocol，Enabling NFT Protection.

Provides unique binding between NFT and digital asset associated:
1. Embeds "DNA" into digital asset
1. "DNA" Data simultaneously stored/anchored into the NFT minted
1. Uses and utilizes audio to transmit arbitrary info NFC tech that leverages audio and based on sound triggers

A same audio file can contain & transmit different information.

Soundlinks DNA requires minimal storage ( no need to store audio content itself ) - significantly reduces on-chain storage, bandwidth & computing power for interaction between on-chain/off-chain.

- `Anti-piracy`: Off-chain digital content, played back anywhere off-chain is protected and verified, as the Soundlinks DNA embedded in the digital content can be linked to the anchored NFT.

- `Digital content circulation`: Digital content can circulate freely off-chain ( existing infrastructure, such as content platforms, social platforms, etc. ). Only Soundlinks DNA needs to be stored on-chain, not the digital content itself.

- `Low-carbon environmental protection, climate awareness`: Each Soundlinks DNA <= 256bits; A MP3 format song is usually 5-6 Mbytes = 40-50 Mbits; Storage, bandwidth & computing power required by Soundlinks powered blockchain are about one in hundreds of thousands of storing files on the blockchain.

# INSPIRAX Contract Addresses

`Inspirax.cdc` : This is the main Inspirax smart contract that defines the core functionality of the NFT, base on [NBA TopShot smart contract](https://github.com/dapperlabs/nba-smart-contracts).

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0xcc743689760c543d](https://flow-view-source.com/testnet/account/0xcc743689760c543d/contract/Inspirax) |
| Mainnet |  |

`InspiraxShardedCollection.cdc` : This contract bundles together a bunch of MomentCollection objects in a dictionary, and then distributes the individual Moments between them while implementing the same public interface as the default MomentCollection implementation.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0xcc743689760c543d](https://flow-view-source.com/testnet/account/0xcc743689760c543d/contract/InspiraxShardedCollection) |
| Mainnet |  |

`InspiraxUtilityCoin.cdc` : The utility coins circulates on Inspirax.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0xcc743689760c543d](https://flow-view-source.com/testnet/account/0xcc743689760c543d/contract/InspiraxUtilityCoin) |
| Mainnet |  |

`InspiraxBeneficiaryCut.cdc` : This smart contract stores the mappings from the names of copyright owners to the vaults in which they'd like to receive tokens, as well as the cut they'd like to take from store and pack sales revenue and marketplace transactions.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0xcc743689760c543d](https://flow-view-source.com/testnet/account/0xcc743689760c543d/contract/InspiraxBeneficiaryCut) |
| Mainnet |  |

`NFTStorefront.cdc`: The general-purpose contract is used in the Inspirax market.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0x94b06cfca1d8a476](https://flow-view-source.com/testnet/account/0x94b06cfca1d8a476/contract/NFTStorefront) |
| Mainnet | [0x4eb8a10cb9f87357](https://flowscan.org/contract/A.4eb8a10cb9f87357.NFTStorefront) |

# SOUNDLINKS Contract Address

`SoundlinksDNA.cdc` : Each Inspirax NFT is embedded with a unique Soundlinks DNA.

| Network | Contract Address     |
|---------|----------------------|
| Testnet | [0x282cfe21068b3883](https://flow-view-source.com/testnet/account/0x282cfe21068b3883/contract/SoundlinksDNA) |
| Mainnet |  |

# Common Commands

#### Deploy contract
```
flow project deploy --network=testnet
```
#### Update deployed contract
```
flow project deploy --network=testnet --update
```
#### Remove deployed contract
```
flow accounts remove-contract SoundlinksDNA --network=testnet --signer=testnet-account-soundlinks

flow accounts remove-contract Inspirax --network=testnet --signer=testnet-account-inspirax
flow accounts remove-contract InspiraxShardedCollection --network=testnet --signer=testnet-account-inspirax
flow accounts remove-contract InspiraxUtilityCoin --network=testnet --signer=testnet-account-inspirax
flow accounts remove-contract InspiraxBeneficiaryCut --network=testnet --signer=testnet-account-inspirax
```

# Soundlinks DNA Commands
SoundlinksDNA contract is already deployed to testnet at [0x282cfe21068b3883](https://flow-view-source.com/testnet/account/0x282cfe21068b3883).

#### Setup Account `Transaction`
```
flow transactions send ./transactions/SoundlinksDNA/setup_account.cdc --signer testnet-account-inspirax --network=testnet
```
#### Mint DNAs `Transaction`
```
flow transactions send ./transactions/SoundlinksDNA/mint_DNAs.cdc --signer testnet-account-soundlinks --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "Array","value": [{"type": "String","value": "b822bb93905a9bd8b3a0c08168c427696436cf8bf37ed4ab8ebf41a07642e111"},{"type": "String","value": "de689e8d537fd816753da1d4fa6873e16f8dfbbcfd5d9e5c9c35a0a426645222"}]}]'
```
#### Purchase DNAs `Transaction`
```
flow transactions build ./transactions/SoundlinksDNA/purchase_DNAs.cdc --network=testnet --args-json '[{"type": "UInt32","value": "2"},{"type": "Array","value": [{"type": "String","value": "b822bb93905a9bd8b3a0c08168c427696436cf8bf37ed4ab8ebf41a07642e555"},{"type": "String","value": "de689e8d537fd816753da1d4fa6873e16f8dfbbcfd5d9e5c9c35a0a426645666"}]},{"type": "UFix64","value": "1.0"}]' --authorizer testnet-account-soundlinks --authorizer testnet-account-inspirax --proposer testnet-account-soundlinks --payer testnet-account-inspirax --filter payload --save built.rlp

flow transactions sign ./built.rlp --signer testnet-account-soundlinks --network=testnet --filter payload --save signed.rlp

flow transactions sign ./signed.rlp --signer testnet-account-inspirax --network=testnet --filter payload --save signed.rlp

flow transactions send-signed ./signed.rlp --network=testnet
```
#### Get supply `Script`
```
flow scripts execute ./scripts/SoundlinksDNA/get_supply.cdc --network=testnet
```
#### Get Amount `Script`
```
flow scripts execute ./scripts/SoundlinksDNA/get_amount.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"}]'
```

# Inspirax Commands
Inspirax contracts are already deployed to testnet at [0xcc743689760c543d](https://flow-view-source.com/testnet/account/0xcc743689760c543d).

## Inspirax NFT

### Admin `Transaction`
---
#### Admin / Create Play `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/create_play.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Dictionary","value": [{"key": {"type": "String","value": "Title"},"value": {"type": "String","value": "Play 001"}}]}]'
```
#### Admin / Create Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/create_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "String","value": "Set 001"}]'
```
#### Admin / Add Play to Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/add_play_to_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UInt32","value": "1"}]'
```
#### Admin / Add Plays to Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/add_plays_to_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "4"},{"type": "Array","value": [{"type": "UInt32","value": "7"},{"type": "UInt32","value": "8"},{"type": "UInt32","value": "9"}]}]'
```
#### Admin / Start New Series `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/start_new_series.cdc --signer testnet-account-inspirax --network=testnet
```
#### Admin / Lock Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/lock_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "2"}]'
```
#### Admin / Retire Play from Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/retire_play_from_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "3"},{"type": "UInt32","value": "4"}]'
```
#### Admin / Retire All Plays from Set `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/retire_allPlays_from_set.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "3"}]'
```
#### Admin / Mint Moment `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/mint_moment.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UInt32","value": "1"},{"type": "Address","value": "0xcc743689760c543d"}]'
```
#### Admin / Batch Mint Moments `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/batch_mint_moments.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "4"},{"type": "UInt32","value": "7"},{"type": "UInt32","value": "2"},{"type": "Address","value": "0xcc743689760c543d"}]'
```
#### Admin / Provide Moment `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/provide_moment.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0x356dd8fe327720aa"},{"type": "Array","value": [{"type": "UInt64","value": "2"},{"type": "UInt64","value": "7"},{"type": "UInt64","value": "8"}]}]'
```
#### Admin / Purchase Store by Cash `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/purchase_store_by_cash.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UFix64","value": "100.0"},{"type": "String","value": "Commonweal 001"}]'
```
#### Admin / Purchase Store by IUC `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/purchase_store_by_IUC.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UFix64","value": "20.0"},{"type": "String","value": "Commonweal 001"}]'
```
#### Admin / Purchase Pack by Cash `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/purchase_pack_by_cash.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UFix64","value": "100.0"},{"type": "String","value": "Commonweal 001"}]'
```
#### Admin / Purchase Pack by IUC `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/purchase_pack_by_IUC.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UFix64","value": "20.0"},{"type": "String","value": "Commonweal 001"}]'
```
#### Admin / Transfer Admin `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/transfer_admin.cdc --signer testnet-account-inspirax --network=testnet
```

### ShardedCollection `Transaction`
---
#### ShardedCollection / Setup Sharded Collection `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/shardedCollection/setup_sharded_collection.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt64","value": "32"}]'
```
#### ShardedCollection / Transfer from Sharded `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/shardedCollection/transfer_from_sharded.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0xd10a6123238d2075"},{"type": "UInt64","value": "1"}]'
```
#### ShardedCollection / Batch Transfer from Sharded `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/shardedCollection/batch_transfer_from_sharded.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0xd10a6123238d2075"},{"type": "Array","value": [{"type": "UInt64","value": "3"},{"type": "UInt64","value": "4"},{"type": "UInt64","value": "5"}]}]'
```

### User `Transaction`
---
#### User / Setup Account `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/user/setup_account.cdc --signer testnet-account --network=testnet
```
#### User / Transfer Moment `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/user/transfer_moment.cdc --signer testnet-account --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### User / Batch Transfer Moments `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/user/batch_transfer_moments.cdc --signer testnet-account --network=testnet --args-json '[{"type": "Address","value": "0x356dd8fe327720aa"},{"type": "Array","value": [{"type": "UInt64","value": "1"},{"type": "UInt64","value": "9"}]}]'
```

### Collections `Script`
---
#### Collections / Get Collection IDs `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_collection_ids.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"}]'
```
#### Collections / Get ID in Collection `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_id_in_collection.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Metadata `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_metadata.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Metadata Field `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_metadata_field.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"},{"type": "String","value": "Title"}]'
```
#### Collections / Get Moment PlayID `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_moment_playID.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Moment SerialNum `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_moment_serialNum.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Moment Series `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_moment_series.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Moment SetID `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_moment_setID.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Moment SetName `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_moment_setName.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UInt64","value": "1"}]'
```
#### Collections / Get Set-Play are owned `Script`
```
flow scripts execute ./scripts/InspiraxNFT/collections/get_setplays_are_owned.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "Array","value": [{"type": "UInt32","value": "1"},{"type": "UInt32","value": "4"}]},{"type": "Array","value": [{"type": "UInt32","value": "3"},{"type": "UInt32","value": "9"}]}]'
```

### Plays `Script`
---
#### Plays / Get All Plays `Script`
```
flow scripts execute ./scripts/InspiraxNFT/plays/get_all_plays.cdc --network=testnet
```
#### Plays / Get Next PlayID `Script`
```
flow scripts execute ./scripts/InspiraxNFT/plays/get_nextPlayID.cdc --network=testnet
```
#### Plays / Get Play Metadata `Script`
```
flow scripts execute ./scripts/InspiraxNFT/plays/get_play_metadata.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Plays / Get Play Metadata Field `Script`
```
flow scripts execute ./scripts/InspiraxNFT/plays/get_play_metadata_field.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "String","value": "Title"}]'
```

### Sets `Script`
---
#### Sets / Get Edition Retired `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_edition_retired.cdc --network=testnet --args-json '[{"type": "UInt32","value": "3"},{"type": "UInt32","value": "4"}]'
```
#### Sets / Get Next SetID `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_nextSetID.cdc --network=testnet
```
#### Sets / Get numMoments in edition `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_numMoments_in_edition.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "UInt32","value": "1"}]'
```
#### Sets / Get Plays in Set `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_plays_in_set.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Sets / Get Set Series `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_setSeries.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Sets / Get Set Name `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_setName.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Sets / Get SetIDs by Name `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_setIDs_by_name.cdc --network=testnet --args-json '[{"type": "String","value": "Set 001"}]'
```
#### Sets / Get Set Locked `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_set_locked.cdc --network=testnet --args-json '[{"type": "UInt32","value": "2"}]'
```
#### Sets / Get Set Data `Script`
```
flow scripts execute ./scripts/InspiraxNFT/sets/get_set_data.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Get Total Supply `Script`
```
flow scripts execute ./scripts/InspiraxNFT/get_totalSupply.cdc --network=testnet
```
#### Get Current Series `Script`
```
flow scripts execute ./scripts/InspiraxNFT/get_currentSeries.cdc --network=testnet
```

## Inspirax Utility Coin

#### Setup Account `Transaction`
```
flow transactions send ./transactions/InspiraxUtilityCoin/setup_account.cdc --signer testnet-account-inspirax --network=testnet
```
#### Mint Tokens `Transaction`
```
flow transactions send ./transactions/InspiraxUtilityCoin/mint_tokens.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "UFix64","value": "100.0"}]'
```
#### Transfer Tokens `Transaction`
```
flow transactions send ./transactions/InspiraxUtilityCoin/transfer_tokens.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UFix64","value": "50.0"},{"type": "Address","value": "0xd10a6123238d2075"}]'
```
#### Transfer Many Accounts `Transaction`
```
flow transactions send ./transactions/InspiraxUtilityCoin/transfer_many_accounts.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Dictionary","value": [{"key": {"type": "Address","value": "0xd10a6123238d2075"},"value": {"type": "UFix64","value": "10.0"}},{"key": {"type": "Address","value": "0x356dd8fe327720aa"},"value": {"type": "UFix64","value": "10.0"}}]}]'
```
#### Burn Tokens by Admin `Transaction`
```
flow transactions send ./transactions/InspiraxUtilityCoin/burn_tokens_by_admin.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UFix64","value": "10.0"}]'
```
#### Burn Tokens by User `Transaction`
```
flow transactions build ./transactions/InspiraxUtilityCoin/burn_tokens_by_user.cdc --network=testnet --args-json '[{"type": "UFix64","value": "60.0"}]' --authorizer testnet-account --authorizer testnet-account-inspirax --proposer testnet-account --payer testnet-account-inspirax --filter payload --save built.rlp

flow transactions sign ./built.rlp --signer testnet-account --network=testnet --filter payload --save signed.rlp

flow transactions sign ./signed.rlp --signer testnet-account-inspirax --network=testnet --filter payload --save signed.rlp

flow transactions send-signed ./signed.rlp --network=testnet
```
#### Get Supply `Script`
```
flow scripts execute ./scripts/InspiraxUtilityCoin/get_supply.cdc --network=testnet
```
#### Get Balance `Script`
```
flow scripts execute ./scripts/InspiraxUtilityCoin/get_balance.cdc --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"}]'
```

## Inspirax Beneficiary Cut

#### Set CopyrightOwner `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_copyrightOwner.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "String","value": "CopyrightOwner 001"},{"type": "Address","value": "0x356dd8fe327720aa"}]'
```
#### Del CopyrightOwner `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/del_copyrightOwner.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "String","value": "CopyrightOwner 002"}]'
```
#### Set Commonweal `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_commonweal.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "String","value": "Commonweal 001"},{"type": "Address","value": "0xc2cb1d5c5cc8788e"},{"type": "UFix64","value": "0.002"}]'
```
#### Del Commonweal `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/del_commonweal.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "String","value": "Commonweal 001"}]'
```
#### Set Inspirax Capability `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_inspirax_capability.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0xd10a6123238d2075"}]'
```
#### Set Inspirax Market CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_inspirax_marketCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UFix64","value": "0.04"}]'
```
#### Set Store CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_storeCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "Dictionary","value": [{"key": {"type": "String","value": "Inspirax"},"value": {"type": "UFix64","value": "0.2"}},{"key": {"type": "String","value": "CopyrightOwner 001"},"value": {"type": "UFix64","value": "0.3"}},{"key": {"type": "String","value": "CopyrightOwner 002"},"value": {"type": "UFix64","value": "0.5"}}]}]'
```
#### Del Store CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/del_storeCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"}]'
```
#### Set Pack CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_packCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "Dictionary","value": [{"key": {"type": "String","value": "Inspirax"},"value": {"type": "UFix64","value": "0.3"}},{"key": {"type": "String","value": "CopyrightOwner 001"},"value": {"type": "UFix64","value": "0.1"}},{"key": {"type": "String","value": "CopyrightOwner 002"},"value": {"type": "UFix64","value": "0.6"}}]}]'
```
#### Del Pack CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/del_packCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "2"}]'
```
#### Set Market CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/set_marketCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "Dictionary","value": [{"key": {"type": "String","value": "CopyrightOwner 001"},"value": {"type": "UFix64","value": "0.03"}},{"key": {"type": "String","value": "CopyrightOwner 002"},"value": {"type": "UFix64","value": "0.07"}}]}]'
```
#### Del Market CutPercentage `Transaction`
```
flow transactions send ./transactions/InspiraxBeneficiaryCut/del_marketCutPercentage.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt32","value": "2"}]'
```
#### Get CopyrightOwner Names `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_copyrightOwner_names.cdc --network=testnet
```
#### Get CopyrightOwner Amount `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_copyrightOwner_amount.cdc --network=testnet
```
#### Get CopyrightOwner Contain `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_copyrightOwner_contain.cdc --network=testnet --args-json '[{"type": "String","value": "CopyrightOwner 001"}]'
```
#### Get CopyrightOwner Address by Name `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_copyrightOwner_address_by_name.cdc --network=testnet --args-json '[{"type": "String","value": "CopyrightOwner 001"}]'
```
#### Get Commonweal Names `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_commonweal_names.cdc --network=testnet
```
#### Get CommonwealCutPercentage by Name `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_commonwealCutPercentage_by_name.cdc --network=testnet --args-json '[{"type": "String","value": "Commonweal 001"}]'
```
#### Get Inspirax Address `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_inspirax_address.cdc --network=testnet
```
#### Get Inspirax Market CutPercentage `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_inspirax_marketCutPercentage.cdc --network=testnet
```
#### Get Store CutPercentages Amount `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_storeCutPercentages_amount.cdc --network=testnet
```
#### Get Store CutPercentages by Name `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_storeCutPercentage_by_name.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "String","value": "Inspirax"}]'
```
#### Get Pack CutPercentages Amount `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_packCutPercentages_amount.cdc --network=testnet
```
#### Get Pack CutPercentages by Name `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_packCutPercentage_by_name.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "String","value": "Inspirax"}]'
```
#### Get Market CutPercentages Amount `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_marketCutPercentages_amount.cdc --network=testnet
```
#### Get Market CutPercentages by Name `Script`
```
flow scripts execute ./scripts/InspiraxBeneficiaryCut/get_marketCutPercentage_by_name.cdc --network=testnet --args-json '[{"type": "UInt32","value": "1"},{"type": "String","value": "CopyrightOwner 001"}]'
```

# NFTStorefront Commands
The general-purpose contract is used in the Inspirax market.

NFTStorefront contract is already deployed to testnet at [0x94b06cfca1d8a476](https://flow-view-source.com/testnet/account/0x94b06cfca1d8a476).

#### Setup Account `Transaction`
```
flow transactions send ./transactions/NFTStorefront/setup_account.cdc --signer testnet-account --network=testnet
```
#### Sell Item by IUC `Transaction`
```
flow transactions send ./transactions/NFTStorefront/sell_item_by_IUC.cdc --signer testnet-account --network=testnet --args-json '[{"type": "UInt64","value": "1"},{"type": "UFix64","value": "60.0"}]'
```
#### Remove Item `Transaction`
```
flow transactions send ./transactions/NFTStorefront/remove_item.cdc --signer testnet-account --network=testnet --args-json '[{"type": "UInt64","value": "15320080"}]'
```
#### Cleanup Item `Transaction`
```
flow transactions send ./transactions/NFTStorefront/cleanup_item.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt64","value": "15321212"},{"type": "Address","value": "0xd10a6123238d2075"}]'
```
#### Buy Item by Cash `Transaction`
```
flow transactions send ./transactions/NFTStorefront/buy_item_by_cash.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "UInt64","value": "15327264"},{"type": "Address","value": "0xd10a6123238d2075"},{"type": "Address","value": "0x356dd8fe327720aa"}]'
```
#### Buy Item by IUC `Transaction`
```
flow transactions build ./transactions/NFTStorefront/buy_item_by_IUC.cdc --network=testnet --args-json '[{"type": "UInt64","value": "15335701"},{"type": "Address","value": "0xd10a6123238d2075"}]' --authorizer testnet-account2 --authorizer testnet-account-inspirax --proposer testnet-account2 --payer testnet-account-inspirax --filter payload --save built.rlp

flow transactions sign ./built.rlp --signer testnet-account2 --network=testnet --filter payload --save signed.rlp

flow transactions sign ./signed.rlp --signer testnet-account-inspirax --network=testnet --filter payload --save signed.rlp

flow transactions send-signed ./signed.rlp --network=testnet
```
#### Get Listing Ids `Script`
```
flow scripts execute ./scripts/NFTStorefront/get_listing_ids.cdc --network=testnet --args-json '[{"type": "Address","value": "0xd10a6123238d2075"}]'
```
#### Get Listing Details `Script`
```
flow scripts execute ./scripts/NFTStorefront/get_listing_details.cdc --network=testnet --args-json '[{"type": "Address","value": "0xd10a6123238d2075"},{"type": "UInt64","value": "15321212"}]'
```