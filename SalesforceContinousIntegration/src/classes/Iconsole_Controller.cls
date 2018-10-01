public with sharing class Iconsole_Controller {
	public static String iconsole{get;set;}
	public static void newCallOut(){
		//iconsole='Ganesh';
		iconsole=IconsoleIntegration.callOut();
		System.debug(iconsole);
	}
}