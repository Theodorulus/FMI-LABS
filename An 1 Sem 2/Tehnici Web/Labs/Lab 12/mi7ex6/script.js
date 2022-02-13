//MI 7 e6

function format2Cifre(nr){
	return (nr<10)? "0"+nr : ""+nr
}

function sirOra(){
	d = new Date()
	hh=format2Cifre(d.getHours())
	mm=format2Cifre(d.getMinutes())
	ss=format2Cifre(d.getSeconds())
	ms=d.getMilliseconds()
	return `${hh}:${mm}:${ss} ${ms}`;// ${val} e inlocuit in sir de valoarea lui val dar numai pentru siruri definite intre ``
	
}

var idInterval=-1, idTimeout=-1, idTimeoutRec=-1

window.onload=function(){
	var butonInterval=document.querySelectorAll("#interval button")[0];
	var butonTimeout=document.querySelectorAll("#timeout button")[0];
	var butonTimeoutRec=document.querySelectorAll("#timeout_rec button")[0];

	var opresteInterval=document.querySelectorAll("#interval button")[1];
	var opresteTimeout=document.querySelectorAll("#timeout button")[1];
	var opresteTimeoutRec=document.querySelectorAll("#timeout_rec button")[1];	
	
	butonInterval.onclick=function(){
		//setInterval(referinta_functie, timp_ms, parametri_pt_functie)
		if(idInterval==-1){
			idInterval=setInterval(afisInDiv,1000, this.nextElementSibling.nextElementSibling )
		}
	}
	butonTimeout.onclick=function(){
		//setTimeout(referinta_functie, timp_ms, parametri_pt_functie)
    if(idTimeout==-1){
			idTimeout=setTimeout(function(w){
				afisInDiv(w);
				idTimeout = -1;// ca sa pot porni un timeout nou
				}
				,1000, this.nextElementSibling.nextElementSibling )
      
		}
	}	
	butonTimeoutRec.onclick=function(){
		if(idTimeoutRec==-1){
			idTimeoutRec=setTimeout(f,3000, this.nextElementSibling.nextElementSibling )
      
		}
	}	

	function f(w){
			afisInDiv(w);
			idTimeoutRec=setTimeout(f,3000, w)
		
	}

	opresteInterval.onclick=function(){
		clearInterval(idInterval)
		idInterval=-1;
	}
	opresteTimeout.onclick=function(){
		clearTimeout(idTimeout)
		idTimeout=-1;
	}
	
	opresteTimeoutRec.onclick=function(){
		clearTimeout(idTimeoutRec)
		idTimeoutRec=-1;
	}	
}

function afisInDiv(dv){
	dv.innerHTML+=sirOra() +"<br/>"
	dv.scrollTop=dv.scrollHeight; //ca sa fie mereu "scrollat" in jos

}
/*


sry mon

*/