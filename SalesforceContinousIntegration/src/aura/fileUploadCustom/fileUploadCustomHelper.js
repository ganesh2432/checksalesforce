({
    MAX_FILE_SIZE:4500000,/* 6 000 000 * 3/4 to account for base64 */
    CHUNK_SIZE:500000, /* Use a multiple of 4 */
    
    save : function(component,event,helper) {
        debugger;
        //var args = event.getParam('arguments');
       // component.set("v.parentId", args.parentId);
        var fileInput = component.get("v.fileObject");
        var dupattachments = [];
        if(fileInput[0] != undefined && fileInput[0].length != undefined) {
            for(var b = 0 ; b < fileInput[0].length;b++) {
              dupattachments.push(fileInput[0][b]);
            }
        } else {
             for(var b = 0 ; b <fileInput.length;b++) {
             	 dupattachments.push(fileInput[b]); 
            }
                  
         }
        component.set("v.finalFileListToUpload",dupattachments);
        if(dupattachments.length>0) {
            
                var file = dupattachments[0];
                if (file.size > this.MAX_FILE_SIZE) {
                    alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                          'Selected file size: ' + file.size);
                    return;
                }
                this.uploadfilenew(component,file);
           
        }
       // return true;
    },
    
    uploadfilenew : function(component,file) {
        var fr = new FileReader();
        
        var self = this;
        fr.onload = $A.getCallback(function() {
            debugger;
            var fileContents = fr.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            fileContents = fileContents.substring(dataStart);
            
            self.upload(component, file, fileContents);
        });
        
        fr.readAsDataURL(file);
      
    },
    
    upload: function(component, file, fileContents) {
        debugger;
        
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        var parentId = component.get("v.parentId");
        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos,'');
       
    },
    
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        debugger;
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);
        
        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
        
        var self = this;
        action.setCallback(this, function(a) {
            console.log(a.getState());
            if(a.getState() === "SUCCESS") {
                attachId = a.getReturnValue();
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);
                if (fromPos < toPos) {
                    self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
                }
                else {
                    //alert('fileUploaded successfully !!!!!'); 
                    var attachmentNew  = component.get("v.finalFileListToUpload");
                    var counter = component.get("v.counter");
                    component.set("v.counter",counter+1);
                    var newFilefiletoupload = component.get("v.finalFileListToUpload");
                    if(newFilefiletoupload[counter+1] != undefined) {
                    	this.uploadfilenew(component,newFilefiletoupload[counter+1]);
                    }
                    if(newFilefiletoupload.length === counter+1) {
                       var popupEvent = component.getEvent("closePopup");
                        popupEvent.setParams({
                            "hidepopUp" : 'true'           
                        }).fire();
                    }
                  //return true;
                }
            }
            if(a.getState() === "ERROR") {
                var errors = a.getError();
                var message ='';
                var title ='Error Occured';
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    console.log(message);
                } 
            }
        });
        
        
        $A.enqueueAction(action); 
       
        
    },
    
    handleFilesChange: function(component, event, helper) {
        debugger;
        var fileName = 'No File Selected..';
        var choosenFileName = [];
        if (event.getSource().get("v.files").length > 0) {
            //fileName = event.getSource().get("v.files")['name'];
            for (var i = 0; i < event.getSource().get("v.files")[0].length; i++) {
                var fileSize  = (event.getSource().get("v.files")[0][i]['size']/(1024*1024)).toFixed(2);
                var fileName = event.getSource().get("v.files")[0][i]['name'];
                if(fileSize > 4) {
                    var showToast = $A.get("e.force:showToast"); 
                    showToast.setParams({ 
                        'title'   : 'File Size Exceeded', 
                        'message' : 'Please select a file with maximum size of 4MB' +fileName
                    }); 
                    showToast.fire();  
                } else {
                	choosenFileName.push(fileName+' --- '+fileSize+'MB');
                }
            }
        }
        component.set("v.selectedFiles", choosenFileName);
        console.log(component.get("v.selectedFiles"));
    },
   
    handleRemoveOnly: function(component,event,helper) {
        //event.preventDefault();
        debugger;
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