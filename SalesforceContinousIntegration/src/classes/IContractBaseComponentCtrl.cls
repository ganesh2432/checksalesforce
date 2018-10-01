/*
* @Author       	: Rahul Sangwan
* Created By 		: Rahul Sangwan (23/05/2018)
* Last Modified By 	: Rahul Sangwan (31/05/2018)
* @Description  	: Controller for IContractBaseComponent
*/

public with sharing class IContractBaseComponentCtrl {


//Purpose : To get the Theme, which will help to know, App is opened in Lightning view or Classic View.
   @AuraEnabled
    public static String getUIThemeDescription() {
        Boolean isConsoleAppSel 	= false;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
            if(tsr.isSelected()) isConsoleAppSel = true;
        }
        if(isConsoleAppSel) return 'Theme4d';
        else return 'Theme3';
    }

}