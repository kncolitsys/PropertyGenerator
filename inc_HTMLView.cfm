<style>
A{
text-align:right;
color:red;
font-family:'Courier';
}
LABEL
{ 
font-family:'MS Sans Serif';
}
TD,LEGEND,H1{
font-family: 'Verdana';
} 

#main{
padding-left: 200px;
width: 800px;
}

</style>

<div id="main">
	
	<p>This Utility is designed to introspect components and auto-create CFPROPERTY tags based on the function meta data.  Specify the mapping to your components below, and choose which cfc's you want to have CFPROPERTY Tags defined on them.</p>
	<!--- <img align="right" src="http://beatingdebt.files.wordpress.com/2008/04/10481.jpg?w=370&h=298" border="0"> --->
	<h1>CFPROPERTY Inspector</h1>
 
	
	<a name="top"></a>
	
	<div id="example" class="flora">
            <ul>

                <li><a href="#fragment-1"><span>Tab 1</span></a></li>
                <li><a href="#fragment-2"><span>Tab 2</span></a></li>
                <li><a href="#fragment-3"><span>Tab 3</span></a></li>
                <li><a href="#fragment-4"><span>Tab 4</span></a></li>				
                <li><a href="#fragment-5"><span>Complete</span></a></li>
            </ul>

	
				<form action="" method="post">
					
					<div id="fragment-1">
				
					<cfinclude template="tab1.cfm"/>
					
					</div>
					
					<div id="fragment-2">
				
					<cfinclude template="tab2.cfm"/>
					
					</div>
				
					<div id="fragment-3">
					
					 <cfinclude template="tab3.cfm"/>
					
					</div>
				
					<div id="fragment-4">
				
					 <cfinclude template="tab4.cfm"/> 

					</div>
					
					<div id="fragment-5">
				
					 <cfinclude template="tab5.cfm"/> 

					</div>
				
				
		</form>
		
	</div>
	
</div>