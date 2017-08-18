<cfoutput>
	<fieldset>
		<legend>CF Mappings:</legend>
			<table>
				<tr>
					<td>Logical Path:	</td>
					<td><input type="text" name="maplogicalpath" value="#htmleditformat(form.maplogicalpath)#" maxlength="40" size="10"/> </td>
				</tr>
				<tr>
					<td>Directory Path:</td>
					<td><input type="text" name="mapdirpath" value="#htmleditformat(form.mapdirpath)#" maxlength="150" size="70" onchange=""/> </td>
				</tr>
				<tr>
					<td>	</td>
					<td><a href="##" onclick="clickTab(1)">Next</a></td>
				</tr>
			</table>
			<!--- <a href="##top"><img align="left" src="http://www.webdetailer.com/images/svc_icons/house_ico.gif" alt="TOP" border="0"/></a> --->
	</fieldset>
</cfoutput>