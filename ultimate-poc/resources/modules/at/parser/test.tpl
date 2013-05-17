
{Template {
	$other: "Main\}"
	$classpath: "Main\{"
}}

	{macro main()}
		<div>

		{call a() /}
		/*<div>/*Comment*///</d//iv>
		${exp|arg:value}
		{CDATA}
			{Template}
			<div>
			{/Template}
		{/CDATA}
		</div>
	{/macro}

{/Template}
