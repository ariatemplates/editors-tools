{Template {
  $classpath : "some.classpath.Template",
  $css : ["some.classpath.MainCss"]
}}

    {macro listControl(type)}
    
        /*
        Some comment
        */
		{@aria:TextField {
			label:'First name',
			bind: {
				'value':{to:"firstName", inside: data}
			}
		} /}
    
        {section {
          id: type,
          type: "div",
          attributes: {
             classList: ["todo-"+type]
          },
             bindRefreshTo: [ {to:"tasks", inside: data } ]
          }}
             {if (data.tasks.length == 0)}
               {var t=this.moduleCtrl.tasksLeft()/}
                  {if (type=="markall")}
                     <label>
                        Mark all as completed
                     </label>
                  {elseif (type=="status")/}
                     <strong> ${t} </strong> ${t>1 ? 'tasks':'task'} left.
                     {var c=data.tasks.length-t /}
                     {if (c>0)}
                       <a class="todo-clear">
                          Clear ${c} completed ${c>1 ? 'tasks':'task'}
                       </a>
                     {/if}
                  {/if}
             {/if}
        {/section}
    {/macro}
    
    {macro main()}
       <div {id "mainDiv"} class="foo">
            <p><a {id "headerLink" /} href="foo.htm">
                Some link
            </a></p>
            
            <h1> Todos </h1>
         
            {call listControl("markall") /}
            {repeater {
                 id: "tasklist",
                 content: data.tasks,
                 type: "ul",
                 childSections: {
                    id: "task",
                    macro: "taskline",
                    type: "li",
                    bindRefreshTo: function(el) { return [ {inside:el.item} ] }
                 }
            }/}
            {call listControl("status") /}
       </div>
       
       {call bar() /}
    {/macro}

    {macro bar()}
 
        <p {id "para" /} class="para">A paragraph.</p>
        
        <div {id "interestingDiv" /} class="interestingDiv">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus convallis
            mollis nisi, id vestibulum est tincidunt id. Donec imperdiet libero eu est
            accumsan egestas. Mauris tempor justo id elit porta bibendum.<br/>
        </div>
        
        <div {id "otherDiv" /}>
            Suspendisse adipiscing dui nec risus bibendum id fermentum dolor malesuada.
            Sed est tortor, elementum ac laoreet in, adipiscing nec lectus. Fusce venenatis
            mauris eget orci porttitor vestibulum. Integer lacus urna, dignissim ullamcorper
            iaculis et, porttitor a velit.
        </div>
        
        <div class="usingCssPath">
            Sed fermentum mollis lobortis. Vivamus viverra tortor vel ante interdum vestibulum.
            Nunc nisi est, sagittis et hendrerit vitae, eleifend sodales sapien.
            Nulla eleifend euismod metus sed dapibus.
        </div>
            
    {/macro}

{/Template}
