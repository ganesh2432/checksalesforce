public with sharing class suppliers_controller {
	
	public static List<Procurewise.Supplier> suppliers {get;set;}
	public static String supplierName{get;set;}
    public static List<Procurewise.Supplier> results{get;set;}

    public static void callOut(){
    	
      suppliers=Procurewise.callout();
    }
    
    public static void clear(){
    	
    	suppliers=null;
        results=null;
    }

    public static void getResults(){
        results=Procurewise.getResults(supplierName);
    }   
}