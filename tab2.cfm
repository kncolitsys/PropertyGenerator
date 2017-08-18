<cfoutput>
<fieldset>
		<legend>Settings:</legend>
	<table>
		<tr>
			<td>Exclude Methods Named:	</td>
			<td><input type="text" name="exclude" value="#form.exclude#" size="70"/> </td>
		</tr>
			
		<tr>
			<td>Directory to CFC's:</td>
			<td><input type="text" name="dir" value="#htmleditformat(form.dir)#" maxlength="150" size="70" onchange=""/> </td>
		</tr>
		<tr>
			<td></td>
			<td><label for="lblSubdir">Search Sub Directories?</label> <input type="checkbox" id="lblSubdir" name="subdir" value="1"<cfif structkeyexists(form,"subdir") and form.subdir> checked="true"</cfif>/> </td>
		</tr>
		<tr>
			<td><label for="lblalphasort">Alphabetically Sort Properties?</label></td>
			<td><input type="checkbox" id="lblalphasort" name="alphasort" value="1"<cfif structkeyexists(form,"alphasort") and form.alphasort> checked="true"</cfif>/> </td>
		</tr>
		<tr>
			<td><label for="lblOverwrite">Overwrite Existing Properties?</label>	</td>
			<td><input type="checkbox" id="lblOverwrite" name="overwrite" value="1"<cfif structkeyexists(form,"overwrite") and form.overwrite> checked="true"</cfif>/> </td>
		</tr>
		<tr>
			<td><label for="lblLcase">Lower Case Properties?</label>	</td>
			<td><input type="checkbox" id="lblLcase" name="lcase" value="1"<cfif structkeyexists(form,"lcase") and form.lcase> checked="true"</cfif>/> </td>
		</tr>
		<tr> 
			<td></td>
			<td><input type="submit" name="btnSubmit" value="Submit"/> 	</td>
		</tr>
		<!--- <tr>
			<td>	</td>
			<td><a href="##" onclick="clickTab(2)">Next<!--- <img align="left" src="http://www.webdetailer.com/images/svc_icons/house_ico.gif" alt="TOP" border="0"/> ---></a>
		</td>
		</tr> --->
	</table>
				<input type="hidden" name="step" value="2"/> 
	
			 </fieldset>

</cfoutput>