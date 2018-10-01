public class FieldSelectionRespWrapper {
    
    public cls_selFields[] selFields;
    
	public class cls_selFields {
		public String fieldName;	//Region
		public String displayName;	//Region
		public String dataType;	//ENUM
		public String length;	//30
		public String mandatory;	//YES
		public String allowedValues;	//US, EMEA, APAC, ANZ
		public String defaultValue;	//ANZ
		public String applicableModules;	//AUTHORING, REPOSITORY
		public String contractRelationship;	//ONE-ONE
		public String dependantFields; 
		public cls_subFields[] subFields;
		public boolean isSelected;
        public Boolean isDependent;
	}
    
	/*public class cls_subFields {
		public cls_subField[] subField;
	}*/
    
	public class cls_subFields {
		public String fieldName;	//
		public String displayName;	//
		public String dataType;	//
		public String length;	//
		public String mandatory;	//
		public String allowedValues;	//
		public String defaultValue;	//
	}
    
	public static FieldSelectionRespWrapper parse(String json){
		return (FieldSelectionRespWrapper) System.JSON.deserialize(json, FieldSelectionRespWrapper.class);
	}

}