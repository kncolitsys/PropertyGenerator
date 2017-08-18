<!--- Form that gets a beginning directory (asks if it recursively searches for cfc's in the sub dirs) --->
<cfparam name="form.dir" default="c:\websites\model.jobs2web.com\"/>
<cfparam name="form.maplogicalpath" default="/j2w"/>
<cfparam name="form.mapdirpath" default="c:\websites\model.jobs2web.com\model\jobs"/>
<cfparam name="form.exclude" default="getInstance,getNumericNull,getStringNull,getBinaryNull,getDateNull,getBeanConfigValue"/>
<cfparam name="form.path" default=""/> 

<!--- Author: penny - Date: 1/1/2009 --->
<cffunction name="removeTrailingSlash" output="false" access="public" returntype="string" hint="removes any / or \ trailing from a path">
	<cfset var retString = arguments[1]>
	
	<cftrace text="#right(retString,1)#">
	
	<cfif REFind('[/\\]',right(retString,1))>
		<!--- replace the last character with nothing --->
		<cfset retString = mid(retString,1,len(retString)-1)>
	</cfif>
	<cfreturn retString/>
</cffunction>

<!--- Author: penny - Date: 12/16/2008 --->
<cffunction name="replaceMapLogicalPath" output="false" access="public" returntype="string" hint="takes a dir path, and replaces it with the maplogicalpath path and slashes to dot notation">
	<cfargument name="directoryPath" type="string" required="true"/>
	
	<cfset var MappedPath =REreplace(REREplace(replacenocase(arguments.directoryPath,removeTrailingSlash(form.mapdirpath),form.maplogicalpath,'one'),'[\\/]','.','all'),'\.','','ONE')>
	<cfset MappedPath = replacenocase(MappedPath,'.cfc','','one')>
	<cfreturn MappedPath	/>
</cffunction>

<!--- Author: penny - Date: 12/16/2008 --->
<cffunction name="convertMissingProperties" output="false" access="public" returntype="void" hint="takes a metadata Structure and returns the array of properties missing based on 'getter' methods">
	<cfargument name="stc" type="struct" required="true"/>
	<cfset var arrArray = ArrayNew(1)/>
	<cfset var stcTemp = StructNew()/>
	<cfset var sortkeys = arrayNew(1)/>
	<cfset var sortKey = structNew()/>
	<cfset var i = 0>
	<cfset var propertyArrayPosition = 0>
	
	<!--- Loop over Each Function in the Object --->
	<cfloop from="1" to="#arraylen(arguments.stc.functions)#" index="i">
		<!--- get the function name like getX as long as it's not in the list of exclude functions and check whether i should overwrite this property or not from UI options --->
		<cfif left(arguments.stc.functions[i].name,3) eq 'get' AND 
				NOT listfindnocase(form.exclude,arguments.stc.functions[i].name)  
			>
			<cfset stcTemp = StructNew()>
			<cfset stcTemp.name = replacenocase(arguments.stc.functions[i].name,'get','','one')>
			
			<!--- Determine if they want to Overwrite the Properties or not --->
			<cfset propertyArrayPosition = PropertyPositionFound( arguments.stc,stcTemp.name )>
			
				<cfif propertyArrayPosition eq 0>
				<!--- Candidate for the Properties Tag --->
					
					<!--- set the default value for this as an empty String (todo: may have to change to a valid numeric for numeric data types) --->
					<cfset stcTemp.default = ''>
					
					<cfif structkeyexists( arguments.stc.functions[i],'returntype' )>
						<cfset stcTemp.type = arguments.stc.functions[i].returntype>
					<cfelse>
						<cfset stcTemp.type = 'any'><!--- may not work well with flex: todo: ask cnf if any return type works well --->
					</cfif> 
					
				<cfelse>
				
					<cfset stcTemp = StructCopy(arguments.stc.PROPERTIES[propertyArrayPosition])>
				
				</cfif>
			 
			 <!--- Lower CASE the PROPERTY Name --->
			<cfif structkeyexists(form,"lcase")>
				<cfset stcTemp.name = lcase(stcTemp.name)>
			</cfif>
				
			<!--- finally append the Structure to the Array Position --->
			<cfset ArrayAppend(arrArray,stcTemp) >
			
		</cfif>
		
	</cfloop>
	
	<!--- soft the array if alphasort --->
	<cfif structkeyexists(form,"alphasort")> 
		<cfset sortKey.keyName = "name"/>
		<cfset sortKey.sortOrder = "ascending"/>	
		<cfset arrayAppend(sortKeys, sortKey)/>
		<cfset arrArray = sortArrayOfStructures(arrArray,sortKeys)>
	</cfif>
	<!--- now that I'm done - insert the arrayinto the Properties position. --->
	<cfset arguments.stc.PROPERTIES = arrArray> 
	<!--- Don't forget about the 'alias' --->
	
	<cfreturn />
</cffunction>

<!--- Author: penny - Date: 12/16/2008 --->
<cffunction name="PropertyPositionFound" output="false" access="public" returntype="numeric" hint="returns the position they key was found">
	<cfargument name="stc" type="struct" required="true" hint="meta data structure"/>
	<cfargument name="PropertyKey" type="string" required="true" hint="property key in the array to match against"/>
	<cfset var positionFound = 0><!--- default was NOT found in the Properties struct --->
	<cfset var i = 0>
	
	<!---  if the property was found and overwrite is false--->
	<cfif structkeyexists(arguments.stc,"PROPERTIES") AND NOT structkeyexists(form,"overwrite")>
		<cfloop from="1" to="#arraylen(arguments.stc.PROPERTIES)#" index="i">
			<cfif arguments.stc.PROPERTIES[i].name eq arguments.PropertyKey>
				<cfset positionFound = i><!--- don't overwrite me return the NODE that this was found --->
				<cfbreak/>
			</cfif>		
		</cfloop>
	</cfif>	
	
	<cfreturn positionFound	/>
</cffunction>

<cfscript>
/**
* Sorts an array of structures on one or more keys.
*
* @param arrayToSort      Array of structs to sort. (Required)
* @param sortKeys      Array of structs the define the sort. (Required)
* @param doDuplicate      Return a duplicate of the data, not a pointer. Defaults to false. (Optional)
* @return Returns an array of structs.
* @author Martijn van der Woud (martijnvanderwoud@orange.nl)
* @version 0, September 27, 2008
*/
function sortArrayOfStructures(arrayToSort,sortKeys){
    // This function takes three arguments, of which the third is optional
    
    // The first argument 'arrayToSort' is (obviously) the array to sort. This must be an array that is to be sorted
    // on one or more keys. Keys to be sorted on must contain numbers or strings
    
    // Sortkeys are specified as stuctures in the second argument 'sortkeys', which is an array
    // sortkey struct must contain the following keys:
    // keyname - string - the name of a key on which to     
    // sortorder - string - either "ascending" or "descending"
    
    //NOTE: By default, the structures in the returned array point to the same memory location
    // as the structures in the argument 'arrayToSort'. After executing this function
    // changing a structure in the returned array thus also changes the corresponding
    // structure in the argument array, and vice versa! If this kind of behavior is unwanted,
    // specify the third argument 'doDuplicate' as true.
    
    // a struct to hold variables local to this function
    var locals = structNew();
        
    // by default, return the structs in the array by reference
    if (ArrayLen(Arguments) eq 2)    {
        arguments[3] = false;
    }
        
    // the array to be returned by this function (now empty)
    locals.arrayToReturn = arrayNew(1);
    // the number of elements in the array that was passed in
    locals.nElements = arrayLen(arguments.arrayToSort);
    // the number of key on which sorting is to take place
    locals.nSortKeys = arrayLen(arguments.sortKeys);
                
    // for every element in the array that was passed in
    for (locals.i = 1; locals.i lte locals.nElements; locals.i = locals.i + 1) {
        // reference to the data in the current element in 'arrayToSort'
        locals.elementData = arguments.arrayToSort[locals.i];            
            
        // purpose of the code below is to determine on what position the
        // current element is to be put on the array to be returned
        // the position is initialized as 1
        locals.insertPosition = 1;
            
        // for every element that has been previously put in the array to return
        for (locals.j = 1; locals.j lt locals.i; locals.j = locals.j + 1) {
                
            // reference to the current element in the array to return
            locals.previousElementData = locals.arrayToReturn[locals.j];
                
            // boolean used in the loop over sortkeys, to indicate that the loop over
            // elements in the array to return must be broken out of.
            locals.doBreak = false;
                
            // for every sortkey
            for (locals.k = 1; locals.k lte locals.nSortKeys; locals.k = locals.k + 1) {
                    
                // specifications for the current key
                locals.currentKey = arguments.sortKeys[locals.k];
                locals.currentValue = locals.elementData[locals.currentKey.keyName];
                    
                // value of the current key in the current element in the array to return
                locals.previousValue = locals.previousElementData[locals.currentKey.keyName];
                    
                // boolean indicating if the key-value of the current element in the passed-in array
                // is greater than the key-value in the current element, previously inserted in the array to return
                locals.currentGreater = locals.currentValue gt locals.previousValue;
                // boolean indicating if the key-value in the array to return is greater
                locals.previousGreater = locals.previousValue gt locals.currentValue;                    
                    
                // boolean indicating if the current element in the array to sort must go
                // BEFORE the previously inserted element in the array to return
                locals.currentFirst =
                    (locals.currentGreater AND (locals.currentKey.sortOrder eq "descending"))
                    OR (locals.previousGreater AND (locals.currentKey.sortOrder eq "ascending"));
                    
                // boolean indication if the current element in the array to sort must go
                // AFTER the previously inserted element in the array to return
                locals.previousFirst =
                    (locals.previousGreater AND (locals.currentKey.sortOrder eq "descending"))
                    OR (locals.currentGreater AND (locals.currentKey.sortOrder eq "ascending"));
                    
                    
                // if the element previously inserted in the array to return goes first
                if (locals.previousFirst)
                    {
                    //     increment the insertPosition of the element in arrayToSort by one
                    locals.insertPosition = locals.insertPosition + 1;
                    // break out of the loop over sortkeys
                    break;
                    }
                        
                // if the current element in the array to sort goes first     
                if (locals.currentFirst)
                    {
                    // indicate that the loop over previously inserted elements in the array to return
                    // must be broken out of
                    locals.doBreak = true;
                    // break out of the loop over sortkeys
                    break;
                    }                
            } // end of loop over sortkeys
                
                
            // break out of the loop over previously inserted elements in the array to return,
            // when so indicated by the inner loop (over sortkeys)
            if (locals.doBreak)
                {
                break;
                }
                    
        } //end of loop over elements that were previously put in the array to return
            
            
        // at this point locals.insertPosition holds the correct position, where the current
        // element in the array to sort (argument) should be put
            
        // based on the value of the 'doDuplicate' argument, get either a deep copy or a reference of the
        // data to insert in the array to return
        if (arguments[3]) {
            locals.insertData = duplicate(locals.elementData);
        } else {
            locals.insertData = locals.elementData;
        }
                        
        // if the insertposition is not greater than the current length of the array to return
        if (locals.insertPosition lt locals.i)
            {
            // do an insert into the correct position
            arrayInsertAt(locals.arrayToReturn,locals.insertPosition,locals.insertData);
            }
        else // if not ..
            {
            // do an append    
            arrayAppend(locals.arrayToReturn,locals.insertData);
            }            
    } // end of loop over elements in the array that was passed in
    return locals.arrayToReturn;        
}
</cfscript>

<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="returnObjectsMetaData" output="false" access="public" returntype="struct" hint="creates the object and returns the meta data.">
	<cfargument name="path" type="string" required="true"/>
	<!--- do a Create Object on each Object and get the meta data on it ---> 
			<cfset var obj = createObject( "component", "#replacemaplogicalpath(path)#")>
			<!--- get the meta data Structure on the Object --->
			<cfset var stcStruct = getMetaData(obj) >
			
	<cfreturn stcStruct	/>
</cffunction>


<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="CommitCFPROPERTY" output="false" access="public" returntype="void" hint="does the final processing of the data objects">
	<cfargument name="formData" type="struct" required="true"/>
	<!--- I can optinally Write These files to Disk If I need to - for each cfc
			path_1 = c:\websites\model.jobs2web.com\model\jobs\job.cfc
			properties_1 = id,created,name,somevalue
		 --->
		 <cfset var FindFormValue = ''>
		 <cfset var continue = true>
		 <cfset var found = false>
		 <cfset var i = 0>
		 <cfset var CFCPath = ''>
		 <cfset var CFCProperties = ''>
		 <cfset var stcStruct = StructNew()>
		 
		 <cfset FindFormValue = 1><!--- id of the form values to find --->
		 
		 <cfloop condition="#continue#">
			<cfset found = false>
			<cfloop list="#arguments.formData.fieldnames#" index="i">
				<cfif i eq 'path_#FindFormValue#'>
					<!--- Process the Found Item --->
					<cfset CFCPath = form["path_#FindFormValue#"]> 
					
					<!--- it's possible for them to have chosen the CFC, but NO properties of it --->
					<cfif structkeyexists(form,"properties_#FindFormValue#")>
						
					<cfset CFCProperties = form["properties_#FindFormValue#"]> 
					
					<!--- Now these properties are Already 'cached' in the CFC as I've set the metadata 
						so all i should have to do is
						a.) remote the Property keys that are NOT in the list of CFCProperties passed (checkboxes)
						b.) Once that's done and the new Structure has been re=assigned to the Object's metadata I can read that and write it to the CFC.
						
					--->
					
					<cfset stcStruct = returnObjectsMetaData(form["path_#FindFormValue#"])>
					
					<!--- remove any properties that are not passed --->
					
					<cfset removeCFCPROPERTIES(stcStruct,CFCProperties)>

					<!--- Execute the SAVE back to the file --->
					<cfset saveObjectsMetaData(stcStruct,CFCPath)/>
 
					<cfset found = true>
					
					</cfif>
				</cfif>
			</cfloop>
			<cfif not found> 
				<cfset continue = false>
				<cfbreak/>
			</cfif>
			
			<cfset FindFormValue = FindFormValue+1>
		
		</cfloop>
	
	
	<cfreturn 	/>
</cffunction>

<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="saveObjectsMetaData" output="false" access="public" returntype="void" hint="takes the meta data and a path and creates / manipulates the cfproperty tags.">
	<cfargument name="stcMetaData" type="struct" required="true"/>
	<cfargument name="cfcPath" type="string" required="true"/>
	
	<!--- Take the PROPERTIES Structure if available --->
	<cfif structkeyexists(arguments.stcMetaData,"PROPERTIES")>
	
		<cfset privateSaveObjectPROPERTIES(arguments.stcMetaData.PROPERTIES,arguments.cfcPath)>
		
	</cfif>
	
	<cfreturn	/>
</cffunction>

<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="privateSaveObjectPROPERTIES" output="true" access="private" returntype="void" hint="does the save of just the metadata tothe cfc">
	<cfargument name="stcPROPERTIES" type="array" required="true"/>
	<cfargument name="cfcPath" type="string" required="true"/>
	
	<cfset var i = 0>
	<cfset var tmpPROPERTYDATA = '#chr(13)##chr(10)#'> 
	
	<cfloop from="1" to="#ArrayLen(arguments.stcPROPERTIES)#" index="i">
		<cfset tmpPROPERTYDATA = tmpPROPERTYDATA & '#chr(9)#<cfproperty name="#arguments.stcPROPERTIES[i].name#" type="#arguments.stcPROPERTIES[i].type#" default="#arguments.stcPROPERTIES[i].default#" hint="#arguments.stcPROPERTIES[i].name# {Generated by cfproperty inspector}"/>#chr(13)##chr(10)#'/>
	</cfloop>
	<!--- write to disk --->
	 <cfset findandreplaceCFPropertyTags(arguments.cfcPath,tmpPROPERTYDATA)/>  
 <!--- <cffile action="write" file="c:\dump\#getfileFromPath(arguments.cfcPath)#" output="#tmpPROPERTYDATA#" /> --->
	<cfreturn  />
</cffunction>

<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="removeCFCPROPERTIES" output="false" access="public" returntype="void" hint="attempts to remove any structure keys on the PROPERTIES Array that is not in the list">
	<cfargument name="stcMetaData" type="struct" required="true"/>
	<cfargument name="PropertyList" type="string" required="true"/>
	
	<cfset var i = 0>
	
	<cfif structkeyexists(arguments.stcMetaData,"PROPERTIES")>
		<cfloop from="#arraylen(arguments.stcMetaData.PROPERTIES)#" to="1" step="-1" index="i">
			<!--- from the bottom up - make sure each key is in the list --->
			<cfif not listfindnocase(arguments.PropertyList, arguments.stcMetaData.PROPERTIES[i].name)>
				<!--- delete the Array Position --->
				<cfset ArrayDeleteAt(arguments.stcMetaData.PROPERTIES,i) >
	
			</cfif>
		
		</cfloop>
	
	</cfif>
	
	<cfreturn 	/>
</cffunction>


<!--- Author: penny - Date: 12/17/2008 --->
<cffunction name="findandreplaceCFPropertyTags" output="true" access="public" returntype="struct" hint="figures out where the property tags begin and end and returns that in a structure">
	<cfargument name="CFCPath" type="string" required="true"/>
	<cfargument name="propertyData" type="string" required="true" hint="this is what will be used as the cfproperty tags in the cfc"/>
	
		<cfset var q = ''>
	<cfset var found = true>
	<cfset var counter = 1> 
	<cfset var arrArray = arraynew(1)>
	<cfset var stcPosition = StructNew()>
	<cfset var fileContents = ''>
	<cfset var stcReturn = StructNew()>
	<cfset var tmpFileData = StructNew()>
	
	<cfset stcReturn.start = 1>
	<cfset stcReturn.end = 1>
	
	<cfset stcPosition.position = 1>
	<cfset stcPosition.length = 0>

	<cffile action="read" file="#arguments.CFCPath#" variable="fileContents">
	
	<cfloop condition="#found#">
		<!--- look for cfproperty tags - first and last --->
		<cfset q = refindnocase('<cfproperty[^>]*>',fileContents,stcPosition.position+stcPosition.length,'true')>
		<cfif q.pos[1]>
		
				<cfset stcPosition.position = q.pos[1]>
				<cfset stcPosition.length = q.len[1]> 
				<cfset ArrayAppend(arrArray,StructCopy(stcPosition)) > 
				
		<cfelse>
		
			<cfset found = false>		
			<cfbreak/>
		
		</cfif>
		 	
		 	<cfset counter = counter+1>
		
		 	<cfif counter gt 1000><!--- just in case something goes wrong here - stop at 1K --->
		 		<cfset found = false>
				<cfbreak/>
			</cfif>
	
	</cfloop>
		
		<!--- if there are NO property tags - then just start after the cfcomponent Tag --->
		<cfif arraylen(arrArray)>
		
			<!--- get the first position in the Array as the area to start --->
			<cfset stcReturn.start = arrArray[1].position-1>
 			<cfset stcReturn.end = arrArray[arraylen(arrArray)].position+arrArray[arraylen(arrArray)].length+1> 
		<cfelse>
			
			<cfset q = refindnocase('<cfcomponent[^>]*>',fileContents,1,'true')>
			<cfif q.pos[1]>
				<!--- start and end the replace at the same spot --->
				<cfset stcReturn.start = q.pos[1]+q.len[1]> 
				<cfset stcReturn.end =  q.pos[1]+q.len[1]>
			</cfif>
		</cfif> 
		
		<cfset stcReturn.count = stcReturn.end-stcREturn.start>
		  <!--- now that I know where to start and End - go ahead and replace the data in the file or rewrite the file --->
		   <cfset tmpFileData.startText = mid(fileContents,1,stcReturn.start)>
		  <cfset tmpFileData.middleText =  arguments.propertyData >
		  <cfset tmpFileData.endText = mid(fileContents,stcReturn.end,len(fileContents)-stcREturn.end+1)>
		  
		  <cffile action="write" file="#arguments.cfcPath#" output="#tmpFileData.startText##tmpFileData.middleText##tmpFileData.endText#" addnewline="false" />
 	<cfreturn stcReturn />
</cffunction>
 