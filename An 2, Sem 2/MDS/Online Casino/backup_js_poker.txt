window.onload=function()
{
	document.getElementById("show_rooms").onclick = function() {
		document.getElementById("rooms").classList.remove("hidden")
	};
	
	document.getElementById("go").onclick = function() {
		document.getElementById("lobbyList").classList.add("hidden")
		document.getElementById("poker_table").classList.remove("hidden")
	};
	
	document.getElementById("bet_amount").innerHTML=document.getElementById("slider_input").value.concat(" RP");
	
	document.getElementById("slider_input").oninput = function() {
		document.getElementById("bet_amount").innerHTML = this.value.concat(" RP");
	}
	
	document.getElementById("bet").onclick = function() {
		console.log("Salut robi");
		document.getElementById("slider").classList.remove("hidden");
		document.getElementById("bet_amount").classList.remove("hidden");
	}
	
	
}