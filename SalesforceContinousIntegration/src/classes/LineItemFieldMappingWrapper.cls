public with sharing class LineItemFieldMappingWrapper {
	public cls_mappedField[] mappedFields;
	public class cls_mappedField {
		public String fieldName;	//itemNumber
		public String displayName;	//Item Number
		public String dataType;	//String
		public String length;	//255
		public String mandatory;	//YES
		public String allowedValues;	//
		public String defaultValue;	//
		public String applicableModules;	//Repository,Authoring
		public String lineItemRelationship;	//ONE-ONE
		public boolean isSelected;
		public String mappingField1;	//Description
		public String mappingObject;	//Opportunity Product
		public boolean SOT;
        public String dependantFields;
	}
	public static LineItemFieldMappingWrapper parse(String json){
		return (LineItemFieldMappingWrapper) System.JSON.deserialize(json, LineItemFieldMappingWrapper.class);
	}
}