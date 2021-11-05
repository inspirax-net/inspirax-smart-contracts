# INSPIRAX

## Introduction

INSPIRAX platform is aiming to create a new ecology of the digital content industry. 

Recently, NFT has entered an explosive period. This greatly helps the entire digital content product market, and it has great power to lead the market to a new stage. 

However, piracy and misappropriation in the digital content product market have become a prominent problem. So far, NFT, as the “rights certificate” on the blockchain is separated from the digital content product it represents, these two has no connection with each other. 

INSPIRAX utilizes SOUNDLINKS technology to implant indelible SOUNDLINKS DNA into audio and video works, and registers SOUNDLINKS DNA with the DRM information of audio and video products in NFT, so that the audio and video products offchain and the rights certificates onchain are anchored. When audio and video products are played back on traditional social media and content platforms, the SOUNDLINKS DNA can be detected and directed to the blockchain to verify the rights. 

Many unique brands, contents and IPs have been joining with us in such a great march. We welcome more participation from all of you.

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
#### Admin / Provide Moment.cdc `Transaction`
```
flow transactions send ./transactions/InspiraxNFT/admin/provide_moment.cdc --signer testnet-account-inspirax --network=testnet --args-json '[{"type": "Address","value": "0x356dd8fe327720aa"},{"type": "Array","value": [{"type": "UInt64","value": "2"},{"type": "UInt64","value": "7"},{"type": "UInt64","value": "8"}]}]'
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
flow transactions send ./transactions/InspiraxNFT/user/batch_transfer_moments.cdc --signer testnet-account --network=testnet --args-json '[{"type": "Address","value": "0xcc743689760c543d"},{"type": "Array","value": [{"type": "UInt64","value": "2"},{"type": "UInt64","value": "3"},{"type": "UInt64","value": "4"}]}]'
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