public class CreateContractVisualforceController {
public String currentRecordId {get;set;}

public CreateContractVisualforceController(ApexPages.StandardController controller) {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');    
}
}