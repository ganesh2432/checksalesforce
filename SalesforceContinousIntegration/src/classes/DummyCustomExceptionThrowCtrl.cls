public class DummyCustomExceptionThrowCtrl {

    public static void checkExceptionInsert(){
        System.Savepoint sp = Database.setSavepoint();
        Exception ex;
        try{
            Integer i = 0, j = 10;
            Integer k = j / i;            
        }catch(Exception e){
            String errorMessage = e.getMessage();
            ex 					= e;
            throw new CustomException(errorMessage);
        }finally{
            if(String.isNotBlank(ex.getMessage()))Database.rollback(sp);
            HandleBusinessException.captureError('ValueMappingController', 'getIContractFields', ex);
        }
    }
}