window.onload = function()
{
	
	//III.22
	var main = document.getElementsByTagName("main")[0];
	function criptare(vect)
	{
		//console.log(vect)
		for(let i = 0; i < vect.length; i++)
		{
			let x = vect[i];
			
			if(main.contains(x))
			{
				text_x = x.innerHTML;
				//console.log(text_p);
				text_x_copy = "";
				for(let j = 0; j < text_x.length; j++)
				{
					//text_x[j] = String.fromCharCode(text_x[j].charCodeAt(0))
					if(text_x[j] != " ")
						text_x_copy = text_x_copy + String.fromCharCode(text_x[j].charCodeAt(0) + 3);
					else
						text_x_copy = text_x_copy + " ";
				}
				//console.log(text_x_copy);
				x.innerHTML = text_x_copy;
			}
		}
	}
	
	var isCripted = 1;
	var paragrafe = document.getElementsByTagName("p");
	var h2 = document.getElementsByTagName("h2");
	var h3 = document.getElementsByTagName("h3");
	
	criptare(paragrafe);
	criptare(h2);
	criptare(h3);
	
	function generate_pass()
	{
		let data_curr = new Date()
		//console.log(data_curr);
		let aa = data_curr.getFullYear()
		//console.log(aa);
		//console.log(aa % 100);
		let ll = data_curr.getMonth()
		if (ll < 10)
			ll = '0' + (ll + 1); // ll + 1 pentru ca lunile au indicii de la 0
		//console.log(ll);
		let zz = data_curr.getDate()
		//console.log(zz);
		let pass_corecta = aa%100 + "#" + zz + "#" + ll;
		//console.log(pass_corecta);
		return pass_corecta;
	}
	
	parola_corecta = generate_pass();
	console.log(parola_corecta);
	
	function decriptare(vect)
	{
		for(let i = 0; i < vect.length; i++)
		{
			let x = vect[i];
			
			if(main.contains(x))
			{
				text_x = x.innerHTML;
				//console.log(text_p);
				text_x_copy = "";
				for(let j = 0; j < text_x.length; j++)
				{
					//text_x[j] = String.fromCharCode(text_x[j].charCodeAt(0))
					if(text_x[j] != ' ')
						text_x_copy = text_x_copy + String.fromCharCode(text_x[j].charCodeAt(0) - 3);
					else
						text_x_copy = text_x_copy + " ";
				}
				//console.log(text_x_copy);
				while(text_x_copy.includes("#iq8"))
					text_x_copy = text_x_copy.replace("#iq8", "9");
				while(text_x_copy.includes("#dq8"))
					text_x_copy = text_x_copy.replace("#dq8", ";");
				while(text_x_copy.includes(""))
					text_x_copy = text_x_copy.replace("", "");
				x.innerHTML = text_x_copy;
			}
		}
	}
	
	var paragrafe = document.getElementsByTagName("p");
	var h2 = document.getElementsByTagName("h2");
	var h3 = document.getElementsByTagName("h3");
	
	
	var pg = document.getElementById("gresita");
	
	document.getElementById("buton_decriptare").onclick=function()
	{
		let your_pass = document.getElementById("parola_decriptare").value;
		//console.log(your_pass);
		//console.log(parola_corecta);
		if(your_pass == parola_corecta)
		{
			pg.innerHTML = "";
			if(isCripted)
			{
				decriptare(paragrafe);
				decriptare(h2);
				decriptare(h3);
				isCripted = 0;
			}
			
		}
		else
		{
			if(isCripted == 0)
			{
				criptare(paragrafe);
				criptare(h2);
				criptare(h3);
				isCripted = 1;
			}
			pg.innerHTML = "Parola gresita!"
		}
	}
	
	//II.8
	var ok = false;
	var se_poate_trimite = true;
	document.getElementById("raspuns_an").onclick=function()
	{
		if(se_poate_trimite)
		{
			setTimeout(function(){ 
					var element = document.getElementById('final_question');
					if(!ok)
					{
						se_poate_trimite = false;
						document.getElementById("raspuns_an").placeholder = "Nu mai poti trimite!";
						document.getElementById("buton_raspuns_an").innerHTML = "Nu mai poti trimite!";
						alert("Timpul a expirat!");
					}
				}, 3000);
		}
	}
	
	document.getElementById("buton_raspuns_an").onclick=function()
	{
		if(se_poate_trimite)
		{
			ok = true;
			var rasp = document.getElementById("raspuns_an");
			var div_final = document.getElementById("felicitari");
			if(rasp.value == 1968)
				div_final.innerHTML = "Felicitari!";
			else
				div_final.innerHTML = "Ai gresit!";
			var element = document.getElementById('final_question');
			element.remove();
		}
	}
}