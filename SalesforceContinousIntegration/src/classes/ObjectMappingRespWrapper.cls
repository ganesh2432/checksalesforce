public class ObjectMappingRespWrapper {
    
    public cls_objectMap[] objectMap;
    
    public class cls_objectMap {
        public String fieldName;	//Region
        public String displayName;	//Region
        public String dataType;	//ENUM
        public String length;	//30
        public String mandatory;	//YES
        public String allowedValues;	//US, EMEA, APAC, ANZ
        public String defaultValue;	//ANZ
        public String applicableModules;	//AUTHORING, REPOSITORY
        public String contractRelationship;	//ONE-ONE
        public cls_subFields subFields;
        public boolean isSelected;
        public String mappingField1;	//BillingStreet
        public String mappingField2;	//Amount
        public String sot;
    }
    
    public class cls_subFields {
        public cls_subField[] subField;
    }
    
    public class cls_subField {
        public String fieldName;	//
        public String displayName;	//
        public String dataType;	//
        public String length;	//
        public String mandatory;	//
        public String allowedValues;	//
        public String defaultValue;	//
    }
    
    
    public static ObjectMappingRespWrapper parse(String json){
        return (ObjectMappingRespWrapper) System.JSON.deserialize(json, ObjectMappingRespWrapper.class);
    }
    
}