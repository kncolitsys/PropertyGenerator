<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
                    "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	
<cfinclude template="inc_functions.cfm"/>
	
  <script src="http://code.jquery.com/jquery-latest.js"></script> 
  <script type="text/javascript" src="http://ui.jquery.com/latest/ui/ui.core.js"></script>
  <script type="text/javascript" src="http://ui.jquery.com/latest/ui/ui.tabs.js"></script>
<link rel="stylesheet" href="http://ui.jquery.com/latest/themes/flora/flora.all.css" type="text/css" media="screen" title="Flora (Default)">
  
<cfparam name="form.step" default="1"/>

  <script>
  $(document).ready(function(){
    $("#example > ul").tabs();
    
    //  tab disabling
	<cfif form.step does not contain 2>
		disableTab(1);
		disableTab(2);
	</cfif>
	<cfif form.step does not contain 3>
		disableTab(3);
	</cfif>
	<cfif form.step does not contain 4>
		disableTab(4);
	</cfif>
	
	// tab clicking  
	<cfif form.step contains 4>
		clickTab(4);
	<cfelseif form.step contains 3>
	clickTab(3);
	<cfelseif form.step contains 2>
	clickTab(2)
	</cfif>
  });
  
  	function clickTab(tabNumber)
	{ 
		
	 	var $tabs = $('#example').tabs(); // first tab selected
	
	
		$tabs.tabs('enable', tabNumber); // in case the tab is not enabled
	    $tabs.tabs('select', tabNumber); // switch to third tab
	    return false;
		 
		
	}
	
	function disableTab(tabNumber)
	{
		var $tabs = $('#example').tabs(); // first tab selected
		 
	 	$tabs.tabs( "disable", tabNumber );
	  	 return false;
		 
	}
	
	function enableTab(tabNumber)
	{
		var $tabs = $('#example').tabs(); // first tab selected
		 
		
	 	$tabs.tabs( "enable", tabNumber );
	  	 return false;
		 
	}
	
	function selectAllResults()
	{
	 var i = 1;
	 var defaultValue = document.getElementById('chkAllResults').checked;
	 
			while(document.getElementById('chkCFC' +i) != null)
			  {	
				  document.getElementById('chkCFC' + i).checked=defaultValue;
				  i = i+1;
			  }
		   	  
		 return true;
	}
	
  
  </script>
  
</head>
<body>


	
<div class="main">
	
	<cfinclude template="inc_HTMLView.cfm"/>
	
</div>



</body>
</html>
