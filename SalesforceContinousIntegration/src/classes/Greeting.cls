public class Greeting {    
   public static String greet{get;set;}
      @AuraEnabled 
    public static String getName(String name){
        greet=name;
        return greet;
    }
}