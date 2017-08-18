<cfif structkeyexists(form,"btnProcess") or structkeyexists(form,"btnCommit")>
	
		<!--- Read in Each cfc and getMetaData() on them - determine existing properties, and insert new ones that are missing - in alphabetical order  --->
		<cfoutput> 	
			<fieldset>
				<legend>Results <label for="chkAllResults"><input id="chkAllResults" type="checkbox" onclick="selectAllResults()"/> Check All</legend>
			<cfset counter = 1>
			<cfloop list="#form.path#" index="i">
			<!--- Read in each fill file path -  --->
		<cfset stcStruct = returnObjectsMetaData(i)>
			<!--- do a Create Object on each Object and get the meta data on it ---> 
			<!--- <cfset obj = createObject( "component", "#replacemaplogicalpath(i)#")> --->
			<!--- get the meta data Structure on the Object --->
			<!--- <cfset stcStruct = getMetaData(obj) > --->
			<!--- pass the metaData to a method that will determine which Properties are missing from your Object and Add them --->
		<fieldset>
				<legend><label for="chkCFC#counter#"><input type="checkbox" id="chkCFC#counter#" name="path_#counter#" value="#i#" checked="true"/> <strong>#i#</strong></label> </legend>
			<table border="0" width="100%">
				<tr>
					<td>Origional Component Properties</td>
					<td>Modified Component Properties</td>
				</tr>
				<tr>
					<td valign="top" width="50%">
						
						<cfif structkeyexists(stcStruct,"PROPERTIES")>
							<cfloop from="1" to="#arraylen(stcStruct.PROPERTIES)#" index="x"><label for="lbl1_#counter#_#x#"><input disabled="true" id="lbl1_#counter#_#x#" type="checkbox" name="properties_#counter#" value="#stcStruct.PROPERTIES[x].name#"/> #stcStruct.PROPERTIES[x].name#</label><br /></cfloop>
						<cfelse>
							No Properties Defined
						</cfif>
										
					</td>
					
					<!--- Only if you want me to Overwrite existing Properties (all or nothing) --->
					 
					<cfset convertMissingProperties(stcStruct) >
					 
					
					<td valign="top"><!---<cfdump var="#stcStruct#">  --->
					
						<cfif structkeyexists(stcStruct,"PROPERTIES")>
							<cfloop from="1" to="#arraylen(stcStruct.PROPERTIES)#" index="x"><label for="lbl2_#counter#_#x#"><input id="lbl2_#counter#_#x#" type="checkbox" name="properties_#counter#" value="#stcStruct.PROPERTIES[x].name#" checked="true"/> #stcStruct.PROPERTIES[x].name#</label><br /></cfloop>
						</cfif>
					
					</td>
				</tr>
			</table>
			 	 
				<cfset counter = counter+1>
				
				</fieldset>
			</cfloop>
			
				<input type="submit" name="btnCommit" value="Submit"/> 
				<br />
			<!--- <a href="##top"><img align="left" src="http://www.webdetailer.com/images/svc_icons/house_ico.gif" alt="TOP" border="0"/></a> --->
				</fieldset>
				
		</cfoutput>
		<p>
		** Note: subsequent runs may have the same results as CF will Cache the meta data of the component, even if the metadata is not yet written to the file.
		</p>
		
		 
		<input type="hidden" name="step" value="4"/> 
		
	</cfif>