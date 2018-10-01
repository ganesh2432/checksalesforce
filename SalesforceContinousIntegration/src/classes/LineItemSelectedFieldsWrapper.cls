public with sharing class LineItemSelectedFieldsWrapper {

	public cls_selFields[] selFields;
	public class cls_selFields {
		public String fieldName;	//quantity
		public String displayName;	//Quantity
		public String dataType;	//BigDecimal
		public String length;	//
		public String mandatory;	//YES
		public String allowedValues;	//
		public String defaultValue;	//
		public String applicableModules;	//Repository,Authoring
		public String lineItemRelationship;	//ONE-ONE
		public boolean isSelected;
        public String dependantFields;
	}
	public static LineItemSelectedFieldsWrapper parse(String json){
		return (LineItemSelectedFieldsWrapper) System.JSON.deserialize(json, LineItemSelectedFieldsWrapper.class);
	}

}