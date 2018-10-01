trigger IContractGetContract on GetContract__e (after insert) {
 
    IcontractGetContractPltfrmEvntHelper.getcontractpltfrmEvnt(Trigger.New);
}