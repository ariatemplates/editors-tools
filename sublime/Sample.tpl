// Some line comment
/**
 * Block Comment !
 */

{Template {
	$classpath : "Sample",
	$dependencies: [],
	$hasScript: true,
	$width: {min: 974},
	$res: {
		res: 'at.CustomisationManager.resources.CustoMgrRes'
	}
}}
	//Comment !
	{macro main()}
		<div 
			id="id_${someMethod()}"                  // Expression in attribute
			{on click "onClickCallback"/}            // Event handler
		>
			{call myMacro()/}                        // Call statement in HTML
		</div>
		<div><span>${getSpanContent()}</span></div>
		<style>
			.someClass {
				position : relative;					 // CSS in style tags
			}
		</style>
		<script type="text/javascript">
			(function () {
				doStuff();							 // JS in script tags
			})();
		</script>
	{/macro}

	{macro widgets()}
		{@lib:Widget {                               // Container widget 
			name : "container widget"
		}}
			{call nestedMacro(1)/}                   // Statement nested in widget
			<a href="${getLink()}">click</a>
		{/@lib:Widget}

		{@lib:Widget {name : "container"}}
			{@lib:ShortWidget {myArg : "value"}/}    // Nested widget
		{/@lib:Widget}

		{@lib:ShortWidget {myArg : "value"}/}        // Widget short notation
		{@lib:ShortWidgetBigOptions {                // Widget short notation
			myArg : "value",                         //    with multiline opt  
			otherArg : "test",
			bind : {
				inside : data,
				to : "some_property"
			}
		}/}
	{/macro}

	{macro nestedMacro(count)}
		<div>
			{if count > 1}
				<span>More than one ! ${count} actually</span>
			{elseif count == 0/}
				<span>None</span>
			{else/}
				<span>Just one</span>
			{/if}
		</div>
	{/macro}

	{macro macroWithSeveralArgs(arg1, arg2, arg3)}
		${(function (){return "some string"}})()}    // expression containing closing curly brace }
		\\${Is not an expression}                   // How should $ be escaped ?
		${several()} expressions ${"on a line"}     // Self explanatory

	{/macro}
{/Template}