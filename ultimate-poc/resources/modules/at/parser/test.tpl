
{Template {
	$classpath: "Main"
}}

	{macro main()}

		<div>/*Comment*/</d//iv>
		{CDATA}
			{Template}
			<div>
			{/Template}
		{/CDATA}

	{/macro}

{/Template}
