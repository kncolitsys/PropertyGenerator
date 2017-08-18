 
	<cfif structkeyexists(form,"btnSubmit") or structkeyexists(form,"btnProcess") or structkeyexists(form,"btnCommit")>
		 
	 
			<cfset recurse = "false">
			<cfif structkeyexists(form,"subdir")>
				<cfset recurse = "true">
			</cfif>
			<cfdirectory directory="#form.dir#" action="list" filter="*.cfc" recurse="#recurse#" name="qryDir"  />
		
			<fieldset id="fieldCFCFound">
					<legend>Components Found <cfif qryDir.recordcount><label for="chkAll"><input id="chkAll" type="checkbox" onclick="selectAll()"/> Check All</cfif></legend>
			<!--- let the user choose chich cfc's they want to introspect and add property tags to all the components --->
				
			 	<cfoutput query="qryDir">
					<label for="chk#qryDir.currentrow#"><input class="inCFCFound" type="checkbox" name="path" value="#qryDir.directory#/#qryDir.name#" <cfif listfind(form.path,"#qryDir.directory#/#qryDir.name#")> checked="true"</cfif> id="chk#qryDir.currentrow#"/> #qryDir.directory#/#qryDir.name#</label><br />
				</cfoutput>
			 
			 	<input type="submit" name="btnProcess" value="Submit"/> 
			 	<br />
				<!--- <a href="##top"><img align="left" src="http://www.webdetailer.com/images/svc_icons/house_ico.gif" alt="TOP" border="0"/></a> --->
			 </fieldset>
			  
			  <script language="javascript" type="text/javascript">
			  <!--
			  	function selectAll()
				  {
				  var i = 1;
				  var defaultValue = 	document.getElementById('chkAll').checked;
					
					  while(document.getElementById('chk' +i) != null)
					  {	
						  document.getElementById('chk' + i).checked=defaultValue;
						  i = i+1;
					  }
				   	 
				  	 return true;
				  }
			  //-->
			  </script>
			  
			  <input type="hidden" name="step" value="3"/> 
	</cfif>

 