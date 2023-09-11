global class ScheduledB2BRebuildSearchIndexBatch implements Schedulable {
    public String webStoreName;

    global void execute(SchedulableContext sc) {
        ConnectApi.CommerceSearchIndexBuildType indexBuildType = ConnectApi.CommerceSearchIndexBuildType.Incremental;
        List<WebStore> webStoreList = [SELECT Id FROM WebStore WHERE Name = :webstoreName];
        String indexBuildStatus = '';

        if (!webStoreList.isEmpty() ) {
            if(Test.isRunningTest()) {
                indexBuildStatus = 'Failed';
            } else {
                ConnectApi.CommerceSearchIndexLogCollection searchIndexLogsList = ConnectApi.CommerceSearchSettings.getCommerceSearchIndexLogs(webStoreList[0].Id);
                indexBuildStatus = searchIndexLogsList.indexLogs[0].indexBuildStatus.name();
            }

            if (indexBuildStatus.equals('Failed')) {
                indexBuildType = ConnectApi.CommerceSearchIndexBuildType.Full;
            }

            if(!Test.isRunningTest() && !indexBuildStatus.equals('InProgress')){
                ConnectApi.CommerceSearchIndex commerceSearchIndex = ConnectApi.CommerceSearchSettings.createCommerceSearchIndex(webStoreList[0].Id, indexBuildType);
            }
        }
    }

    public ScheduledB2BRebuildSearchIndexBatch(String storeName) {
        webStoreName = storeName;
    }

}