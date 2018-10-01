({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 500000,      //Chunk Max size 750Kb 
    TOTAL_FILE_UPLOADED : 0,
    
    getOppId : function(component,event,helper) {
        var locURL =  window.location.href;
        var lightningURL = $A.get("$Label.c.Lightning_URL");
        if(locURL.includes(lightningURL)){
            component.set("v.themeURL", "Theme4d");
        }else{
            component.set("v.themeURL", "Theme3");  
        }
     //   component.set("v.contractId", "8007F0000007EE7QAM");
        var action = component.get("c.getOpportunityIdFromContract"); 
        action.setParams({
            contractId: component.get("v.contractId"),
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                component.set("v.oppId", a.getReturnValue());
                this.getExistingFiles(component,event,helper);
                this.getExistingContractFiles(component,event,helper);
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    getExistingFiles : function(component,event,helper) {
        var selectedFieldsCount	= 0;
		var action = component.get("c.getAllOppFiles"); 
        action.setParams({
            oppId: component.get("v.oppId"),
            contractId: component.get("v.contractId"),
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                var res 	= a.getReturnValue();
                component.set("v.existingFileList", a.getReturnValue());
                for(var i = 0; i < res.length; i++){
                    if(res[i].isSelected)
                    selectedFieldsCount = selectedFieldsCount + 1;
                }
                component.set("v.selectedFieldsCount", selectedFieldsCount);
            }
        });
        
        $A.enqueueAction(action);         
    },
    
    
    getExistingContractFiles : function(component, event, helper){
        debugger;
        var action = component.get("c.getAllContractFiles"); 
        action.setParams({
            contractId: component.get("v.contractId"),
        });
        
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                component.set("v.existingContractFileList", a.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    deleteFile : function(component, event, helper){
        debugger;
        var listIndex		=  component.get("v.delFileId");
        component.set("v.delFileId", null);
        var fileId 			= component.get("v.existingContractFileList")[listIndex].fileId;
        var action = component.get("c.deleteDocFile");
        action.setParams({
            contractId : component.get("v.contractId"),
            documentId : fileId,
        });
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
                component.set("v.existingContractFileList", a.getReturnValue());
                document.getElementById("DeleteFileConfirmationModal").style.display = "none" ;
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    closeDeleteConfirm : function(component, event, helper){
        component.set("v.delFileId", null);
        document.getElementById("DeleteFileConfirmationModal").style.display = "none" ;
    },
    

    showDeleteConfirm : function(component, event, helper){
        var listIndex		= event.getSource().get("v.value");
        component.set("v.delFileId", listIndex);
        document.getElementById("DeleteFileConfirmationModal").style.display = "block" ;
    },
    
    
    onViewClick : function(component, event, helper){
        var listIndex		= event.getSource().get("v.value");
		var fileRec 		= component.get("v.existingFileList")[listIndex].fileId;
        var workspaceAPI 	= component.find("workspace");
        window.open("/" + fileRec, '_blank');
    },
    

    handleUploadFinished : function(component,event,helper) {
        var uploadedFiles = event.getParam("files");
        var fileId 	  	  = [];
        var fileNames 	  = [];
        for(var i = 0; i < uploadedFiles.length; i++){
            fileId.push(uploadedFiles[i].documentId);
            fileNames.push(uploadedFiles[i].name);
        }
        var action = component.get("c.createRefDocList");
        debugger;
        action.setParams({
            fileIds : fileId,
            fileName : fileNames,
            contractId : component.get("v.contractId")
        });
        action.setCallback(this, function(a) {
            debugger;
            this.getExistingContractFiles(component,event,helper);
	        $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action); 
    },
    
    
    saveRec : function(component,event,helper) {
        var action = component.get("c.copyFilesToContract");
        var reqFile = JSON.stringify(component.get("v.existingFileList"));
        console.log(reqFile);
        console.log(component.get("v.existingFileList"));
        action.setParams({
            fileDetailsWrapList : reqFile,
            contractId : component.get("v.contractId"),
        });
        action.setCallback(this, function(a) {
            if(a.getState() === "SUCCESS") {
               // alert(a.getReturnValue());
               if(component.get("v.iscalledFromKeepfile")==true)
               component.getEvent("KeepSaveEvnt").setParams({"isSaved" :true}).fire();
            }
        });
        $A.enqueueAction(action); 
    },
    
    
    sortDocNameDESC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.fileName.toLowerCase();
            var y = b.fileName.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },


    sortDocNameASC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.fileName.toLowerCase();
            var y = b.fileName.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },
    
    
    sortDocTypeDESC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.fileType.toLowerCase();
            var y = b.fileType.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },


    sortDocTypeASC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.fileType.toLowerCase();
            var y = b.fileType.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },
    
    
    sortUploadedByDESC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.createdBy.toLowerCase();
            var y = b.createdBy.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },


    sortUploadedByASC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.createdBy.toLowerCase();
            var y = b.createdBy.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },
    
    
    sortUploadedOnDESC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.createdOn.toLowerCase();
            var y = b.createdOn.toLowerCase();
            if (x < y) {return 1;}
            if (x > y) {return -1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },


    sortUploadedOnASC : function(component, event, helper){
        var configListToSort    = component.get("v.existingFileList");
        configListToSort.sort(function(a,b) {
            var x = a.createdOn.toLowerCase();
            var y = b.createdOn.toLowerCase();
            if (x < y) {return -1;}
            if (x > y) {return 1;}
            return 0;
        });
        component.set("v.existingFileList", configListToSort);
    },
    
    
    selectAll : function(component, event, helper){
        var selectedFieldsCount	= 0;
        var existingFileList	= component.get("v.existingFileList");
        var selectedHeaderCheck = event.getSource().get("v.value");
        for(var i = 0; i < existingFileList.length; i ++){
            existingFileList[i].isSelected	= selectedHeaderCheck;
        }
        component.set("v.existingFileList", existingFileList);
        if(selectedHeaderCheck) selectedFieldsCount = existingFileList.length;
        else selectedFieldsCount					= 0;
        component.set("v.selectedFieldsCount", selectedFieldsCount);
        var compEvent = component.getEvent("selectedFilesCountEvt");
	    compEvent.setParams({"selectedFieldsCount" : component.get("v.selectedFieldsCount")});                
      	compEvent.fire();
    },
    
    
    checkboxSelect : function(component, event, helper){
     	// get the selected checkbox value  
      var selectedRec = event.getSource().get("v.value");
      // get the selectedFieldsCount attrbute value(default is 0) for add/less numbers. 
      var getSelectedNumber = component.get("v.selectedFieldsCount");
      // check, if selected checkbox value is true then increment getSelectedNumber with 1 
      // else Decrement the getSelectedNumber with 1     
      if (selectedRec == true) {
       getSelectedNumber++;
      } else {
       getSelectedNumber--;
      }
      // set the actual value on selectedFieldsCount attribute to show on header part. 
      component.set("v.selectedFieldsCount", getSelectedNumber);
      var compEvent = component.getEvent("selectedFilesCountEvt");
      compEvent.setParams({"selectedFieldsCount" : component.get("v.selectedFieldsCount")});                
      compEvent.fire(); 
    },
    
    
    uploadHelper: function(component, event) {
        debugger;
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        var maxFileSizeLimitCrossed = false;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        for(var noFile = 0; noFile < file.length && maxFileSizeLimitCrossed == false; noFile ++ ){
         	if (file[noFile].size > self.MAX_FILE_SIZE) {
                component.set("v.showLoadingSpinner", false);
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file[noFile].size);
                maxFileSizeLimitCrossed = true;
	            return;
        	}   
        }
        for(var noFile = 0; noFile < file.length ; noFile++){
                            console.log(noFile);
                    // create a FileReader object 
           this.uploadFileNew(component, event, file[noFile]);

        }
    },
    
    
    uploadFileNew : function(component, event, file){
         var objFileReader = new FileReader();
        var self = this;
            // set onload function of FileReader object   
            objFileReader.onload = $A.getCallback(function() {
                var fileContents = objFileReader.result;
                var base64 = 'base64,';
                var dataStart = fileContents.indexOf(base64) + base64.length;
                
                fileContents = fileContents.substring(dataStart);
                // call the uploadProcess method 
                var startPosition = 0;
                // calculate the end size or endPostion using Math.min() function which is return the min. value   
                var endPosition = Math.min(fileContents.length, startPosition + self.CHUNK_SIZE);
                
                // start with the initial chunk, and set the attachId(last parameter)is null in begin
                self.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
                //this.uploadProcess(component, file, fileContents);
            });
            
            objFileReader.readAsDataURL(file);
    },
 
    
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'

        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.contractId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    var fileInput 	= component.find("fileId").get("v.files");
                    var totalFiles  = fileInput[0];
                    if(this.TOTAL_FILE_UPLOADED < totalFiles.length){
                       this.TOTAL_FILE_UPLOADED = this.TOTAL_FILE_UPLOADED +1;   
                    }
                    if(this.TOTAL_FILE_UPLOADED == totalFiles.length){
                        component.set("v.showLoadingSpinner", false);
                        alert('Files Uploaded Successfully.');
                        component.set("v.selectedFiles",undefined);
                        component.set("v.fileObject",undefined);
                        this.getExistingContractFiles(component,null,null);
                    }
					   
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
                var fileInput 	= component.find("fileId").get("v.files");
                    var totalFiles  = fileInput[0];
                    if(this.TOTAL_FILE_UPLOADED < totalFiles.length){
                       this.TOTAL_FILE_UPLOADED = this.TOTAL_FILE_UPLOADED +1;   
                    }
                    if(this.TOTAL_FILE_UPLOADED == totalFiles.length){
                        component.set("v.showLoadingSpinner", false);
                        alert('Files Uploaded Successfully.');
                        component.set("v.selectedFiles",undefined);
                        component.set("v.fileObject",undefined);
                        this.getExistingContractFiles(component,null,null);
                    }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var fileInput 	= component.find("fileId").get("v.files");
                    var totalFiles  = fileInput[0];
                    if(this.TOTAL_FILE_UPLOADED < totalFiles.length){
                       this.TOTAL_FILE_UPLOADED = this.TOTAL_FILE_UPLOADED +1;   
                    }
                    if(this.TOTAL_FILE_UPLOADED == totalFiles.length){
                        component.set("v.showLoadingSpinner", false);
                        alert('Files Uploaded Successfully.');
                        component.set("v.selectedFiles",undefined);
                        component.set("v.fileObject",undefined);
                        this.getExistingContractFiles(component,null,null);
                    }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    
    handleRemoveOnly: function(component,event,helper) {
        var selectedRow = event.getSource().get("v.name");
        var filesListtoShow =  component.get("v.selectedFiles");
        var filesToUpload = [];
        var dupattachments = [];
        var selectArray =[];
        filesToUpload = component.get("v.fileObject");
        for(var b = 0 ; b <filesToUpload[0].length;b++) {
            if(b!== selectedRow) {
                dupattachments.push(filesToUpload[0][b]);
            }
        }
        
        for(var x in filesListtoShow){
            selectArray.push(filesListtoShow[x]);
        }  
        selectArray.splice(selectedRow,1);
        component.set("v.selectedFiles",selectArray);
        component.set("v.fileObject",dupattachments);
      
    },
})