var cssmenuids=["cssmenu1"] //Enter id(s) of CSS Horizontal UL menus, separated by commas
var csssubmenuoffset=-1 //Offset of submenus from main menu. Default is 0 pixels.

function createcssmenu2(){
for (var i=0; i<cssmenuids.length; i++)
{
	var ultags=document.getElementById(cssmenuids[i]).getElementsByTagName("ul")
  for (var t=0; t<ultags.length; t++){
			ultags[t].style.top=ultags[t].parentNode.offsetHeight+csssubmenuoffset+"px";

						ultags[t].parentNode.onmouseover=function(){
    	this.getElementsByTagName("ul")[0].style.visibility="visible"
    	}
    	ultags[t].parentNode.onmouseout=function(){
			this.getElementsByTagName("ul")[0].style.visibility="hidden"
    }
    }
  }
}

if (window.addEventListener)
window.addEventListener("load", createcssmenu2, false)
else if (window.attachEvent)
window.attachEvent("onload", createcssmenu2)