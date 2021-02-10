window.onload=function(){
	
	if (regizor=localStorage.getItem("regizor"))//daca nu returneaza null (null se converteste automat la false in expresie booleana)
		regizor=regizor;//in localStorage valorile sunt doar stringuri
	else
		regizor="";
	
	set_regizor();
	//creez un obiect de tip XMLHttpRequest cu care pot transmite cereri catre server
	var ajaxRequest = new XMLHttpRequest();

	//la schimbarea starii obiectului XMLHttpRequest (la schimbarea proprietatii readyState)
	/* stari posibile:
	0 - netrimis
	1 - conexiune deschisa
	2 - s-au transmis headerele
	3 - se downleadeaza datele (datele sunt impartite in pachete si el primeste cate un astfel de pachet)
	4 - a terminat
	*/
	ajaxRequest.onreadystatechange = function() {
			//daca am primit raspunsul (readyState==4) cu succes (codul status este 200)
			if (this.readyState == 4 && this.status == 200) {
					//in proprietatea responseText am contintul fiserului JSON
					//document.getElementById("afisFilme").innerHTML=this.responseText;
					obJson = JSON.parse(this.responseText);
					afiseazaJsonTemplate(obJson);
			}
	};
	//deschid o conexiune cu o cerere de tip get catre server
	//json e pus in folderul static "resurse" deci calea e relativa la acel folder (fisierul e la calea absoluta /resurse/json/studenti.json)
	ajaxRequest.open("GET", "/json/filme.json", true);
	//trimit catre server cererea
	ajaxRequest.send();
	function afiseazaJsonTemplate(obJson) { 
			//in acets div voi afisa template-urile   
			let container=document.getElementById("afisFilme");

			//in textTemplate creez continutul (ce va deveni innerHTML-ul) divului "afisTemplate"
			let textTemplate ="";
			//parcurg vetorul de filme din obJson
			for(let i=0;i<obJson.filme.length;i++){
				//creez un template ejs (primul parametru al lui ejs.render)
				//acesta va primi ca parametru un film din vectorul de filme din json {film: obJson.filme[i]}
				//practic obJson.filme[i] e redenumit ca "film" in template si putem sa ii accesam proprietatile: film.id etc
				treid = obJson.filme[i].treid;
				textTemplate+=ejs.render("<figure>\
				<img src='/images/<%= film.imagine%>'>\
				<figcaption> <%= film.nume%> </figcaption>\
				<p><%= film.regizor%>, <% if(treid == true){ %>3D<% } else { %>2D<% } %>, <%= film.runtime%> min, <%= film.data_lansare%></p>\
				<p>Stars: <%= film.stars%></p>\
				</figure>", 
				{film: obJson.filme[i]});
			} 
			//adaug textul cu afisarea studentilor in container
			container.innerHTML=textTemplate;
	}
	
	function e3d(figure)
	{
		//console.log(figure.children[2].innerHTML)
		continut = figure.children[2].innerHTML
		valori = continut.split(", ")
		console.log(valori[1])
		if(valori[1] == "3D")
			return 1;
		else
			return 0;
	}
	
	document.getElementById("buton_3d").onclick=function()
	{
		afiseazaJsonTemplate(obJson)
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		for(let i=0;i<figures.length;i++)
		{
			if(!e3d(figures[i]))
			{
				figures[i].remove();
				i-=1;
			}
		}
	}
	
	document.getElementById("buton_2d").onclick=function()
	{
		afiseazaJsonTemplate(obJson)
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		for(let i=0;i<figures.length;i++)
		{
			if(e3d(figures[i]))
			{
				figures[i].remove();
				i-=1;
			}
		}
	}
	
	document.getElementById("sort_cresc").onclick=function()
	{
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		var vfigures = Array.prototype.slice.call(figures);
		/*for (let i=0;i<vfigures.length;i++)
		{
			continut = vfigures[i].children[2].innerHTML
			valori = continut.split(", ")
			let runtime = parseInt(valori[2])
			console.log(runtime)
		}*/
		vfigures.sort(function(a,b){
			continuta = a.children[2].innerHTML
			continutb = b.children[2].innerHTML
			valoria = continuta.split(", ")
			valorib = continutb.split(", ")
			let runtimea = parseInt(valoria[2])
			let runtimeb = parseInt(valorib[2])
			return runtimea - runtimeb;
		});
		for(let figure of vfigures){
			container.appendChild(figure);
		}
	}
	
	document.getElementById("sort_desc").onclick=function()
	{
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		var vfigures = Array.prototype.slice.call(figures);
		/*for (let i=0;i<vfigures.length;i++)
		{
			continut = vfigures[i].children[2].innerHTML
			valori = continut.split(", ")
			let runtime = parseInt(valori[2])
			console.log(runtime)
		}*/
		vfigures.sort(function(a,b){
			continuta = a.children[2].innerHTML
			continutb = b.children[2].innerHTML
			valoria = continuta.split(", ")
			valorib = continutb.split(", ")
			let runtimea = parseInt(valoria[2])
			let runtimeb = parseInt(valorib[2])
			return runtimeb - runtimea;
		});
		for(let figure of vfigures){
			container.appendChild(figure);
		}
	}
	
	document.getElementById("varsta").onclick=function()
	{
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		var vfigures = Array.prototype.slice.call(figures);
		console.log(vfigures[0].children.length);
		if(vfigures[0].children.length == 4)
		{
			for(let i=0;i<vfigures.length;i++)
			{
				continut = vfigures[i].children[2].innerHTML;
				valori = continut.split(", ");
				let data = valori[3];
				//console.log(data);
				var date1 = new Date(data);
				var date2 = new Date();
				var diffTime = Math.abs(date2 - date1);
				var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
				var diffYears = parseInt(diffDays/365.25);
				//console.log(parseInt(diffYears));
				if(diffYears == 0)
					varsta = "< 1 an";
				else 
					if (diffYears == 1)
						varsta = "1 an";
					else
						varsta = diffYears + " ani";
				console.log(vfigures[i]);
				var parag = document.createElement("p");  
				parag.innerHTML = varsta;
				//paragraf = ejs.render("<p><%=varsta%></p>")
				vfigures[i].appendChild(parag);
			}
		}
	}
	
	document.getElementById("filtru_regizor").onclick=function()
	{
		afiseazaJsonTemplate(obJson)
		regizor = document.getElementById("regizor").value;
		localStorage.setItem("regizor", regizor);
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		console.log(figures);
		for(let i=0;i<figures.length;i++)
		{
			continut = figures[i].children[2].innerHTML
			valori = continut.split(", ")
			//console.log(valori[0])
			
			if(!valori[0].includes(regizor))
			{
				figures[i].remove();
				i-=1;
			}
		}
	}
	
	
	
	/*window.onkeypress = function(e)
	{
		afiseazaJsonTemplate(obJson)
		var gr=e.key.toUpperCase()
		let container=document.getElementById("afisFilme");
		var figures = document.getElementById("afisFilme").children;
		for(let i=0;i<figures.length;i++)
		{
			titlu = figures[i].children[1].innerHTML;
			//console.log(titlu[1], gr);
			if(titlu[1] != gr)
			{
				figures[i].remove();
				i-=1;
			}
		}
	}*/
	
	window.onkeypress = function(e)
	{
		//afiseazaJsonTemplate(obJson)
		var gr=e.key.toUpperCase()
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		var ok = 0;
		for(let i=0;i<figures.length;i++)
		{
			titlu = figures[i].children[1].innerHTML;
			//console.log(titlu[1], gr);
			if(titlu[1] == gr)
			{
				figures[i].classList.toggle("rosu");
				figures[i].style.fontStyle = "italic";
				ok = 1;
			}
		}
		if(ok)
			setTimeout(function(){ 
				var elements = document.getElementsByClassName('rosu');
				elements[0].classList.remove("rosu");
				for (let i = 0; i < elements.length;i++)
				{
					elements[i].style.fontStyle = "normal";
					elements[i].classList.remove("rosu");
				}
			}, 5000); // dupa 5 sec de la apasarea unei taste se sterge clasa "rosu" daca s-a adus vreo modificare
	}
	
	var idInterval = -1;
	
	document.getElementById("start_interval").onclick=function()
	{
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		console.log(figures);
		if(idInterval==-1){
			idInterval=setInterval(function(){figures[0].remove(); i-=1;},3000)
		}
		
	}
	
	document.getElementById("stop_interval").onclick=function()
	{
		clearInterval(idInterval);
		idInterval=-1;
	}
	
	function set_regizor()
	{
		var reg = document.getElementById("regizor");
		reg.value = regizor;
		
		//afiseazaJsonTemplate(obJson)
		
		let container=document.getElementById("afisFilme");
		var figures = container.children;
		//console.log(figures);
		for(let i=0;i<figures.length;i++)
		{
			continut = figures[i].children[2].innerHTML
			valori = continut.split(", ")
			//console.log(valori[0])
			
			if(!valori[0].includes(regizor))
			{
				figures[i].remove();
				i-=1;
			}
		}
	}
	
	document.getElementById("clear").onclick=function()
	{
		clear();
	}
	
	function clear() {
		afiseazaJsonTemplate(obJson);
		localStorage.clear();
		var reg = document.getElementById("regizor");
		reg.value = "";
		clearInterval(idInterval);
		idInterval=-1;
	}
	
	
	
	
	
	//TASK-URI
	
	//I.7
	function randInt(a,b){ 
		return Math.trunc(a+(b-a)*Math.random());
	}
	
	var vect_regizori = ["Quentin Tarantino", "Christopher Nolan", "Stanley Kubrick", "Martin Scorsese", "Steven Spielberg", "Woody Allen", "David Fincher", "Wes Anderson", "Francis Ford Coppola"];
	var vect_filme = ["The Godfather", "The Shawshank Redemption", "Inglorious Basterds", "2001: A Space Oddysey", "Pulp Fiction", "The Dark Knight", "12 Angry Men", "Schindler's List", "Forrest Gump", "Inception", "Matrix", "Interstellar", "Gladiator", "Taxi Driver"];
	
	
	function filmRandom()
	{
		return vect_filme[randInt(0,vect_filme.length)];
	}
	
	function regizorRandom()
	{
		return vect_regizori[randInt(0,vect_regizori.length)];
	}
	
	function generareRavas()
	{
		let rav_film = document.getElementById("ravase_film");
		let rav_regizor = document.getElementById("ravase_regizor");
		rav_regizor.innerHTML = "Cel mai talentat regizor care a trait vreodata este " + regizorRandom() + ".";
		rav_film.innerHTML = "Cel mai bun film din istoria cinematografiei este &quot" + filmRandom() + "&quot.";	
	}
	
	generareRavas();
	
	//II.2
	
	function aparitie_treptata()
	{
		let text_film = document.getElementById("ravase_film");
		let text_regizor = document.getElementById("ravase_regizor");
		let cuvinte_film = text_film.innerHTML.split(" ");
		let cuvinte_regizor = text_regizor.innerHTML.split(" ");
		text_film.innerHTML = "";
		text_regizor.innerHTML = "";
		//console.log(cuvinte);
		let text_final_film= "";
		let i = 0;
		let ravas_interval_film = -1;
		setTimeout(function(){ 
				clearInterval(ravas_interval_film);
			}, 333 *( cuvinte_film.length + 1));
		ravas_interval_film = setInterval(function(){
			if(i < cuvinte_film.length)
			{
				text_final_film += cuvinte_film[i] + " ";
				i += 1;
				//console.log(text_final_film);
				text_film.innerHTML = text_final_film;
			}
			else
				console.log("still going");
		},333)
		
		let text_final_regizor = "";
		let j = 0;
		let ravas_interval_regizor = -1;
		setTimeout(function(){ 
				clearInterval(ravas_interval_regizor);
			}, 333 *( cuvinte_regizor.length + 1));
		ravas_interval_regizor = setInterval(function(){
			if(j < cuvinte_regizor.length)
			{
				text_final_regizor += cuvinte_regizor[j] + " ";
				j += 1;
				//console.log(text_final_regizor);
				text_regizor.innerHTML = text_final_regizor;
			}
			else
				console.log("still going");
		},333)
	}
	
	aparitie_treptata();
	
	//III.2
	
	var intrebari = 
	[
		{
			text_intrebare: "Cine a regizat filmul &quotInterstellar&quot?",
			raspunsuri: [["Wes Anderson", false], ["Christopher Nolan", true], ["Quentin Tarantino", false], ["Steven Spielberg", false]]
		},
		
		{
			text_intrebare: "Cate filme sunt in seria &quotFast and Furious&quot pana in iunie 2020?",
			raspunsuri: [["9", false], ["8", true], ["7", false], ["10", false]]
		},
		
		{
			text_intrebare: "Ce film are cel mai mare rating pe IMDb?",
			raspunsuri: [["The Good, the Bad and the Ugly ", false], ["Fight Club", false], ["The Dark Knight", false], ["The Shawshank Redemption ", true]]
		},
		
		{
			text_intrebare: "In ce an a fost lansat filmul &quotForrest Gump&quot?",
			raspunsuri: [["2001", false], ["1994", true], ["1989", false], ["1998", false]]
		},
		
		{
			text_intrebare: "Care dintre urmatorii actori au jucat in filmul &quotThe Hateful Eight&quot?",
			raspunsuri: [[" Samuel L. Jackson", true], ["Kurt Russell", true], ["Leonardo DiCaprio", false], ["Jennifer Jason Leigh", true]]
		},
		
		{
			text_intrebare: "Cate filme exista in universul cinematografic MARVEL(MCU) pana in iunie 2020?",
			raspunsuri: [["23", true], ["18", false], ["22", false], ["19", false]]
		},
		
		{
			text_intrebare: "Cine a regizat filmul &quotAvengers: Endgame&quot?",
			raspunsuri: [["Ryan Coogler", false], ["Taika Waititi", false], ["Joe Russo", true], ["Anthony Russo", true]]
		},
		
		{
			text_intrebare: "Care dintre urmatorii actori au jucat in filmul &quotThe Prestige&quot?",
			raspunsuri: [["Scarlett Johansson", true], ["Christian Bale", true], ["Michael Caine", true], ["Hugh Jackman", true]]
		}
	]
	
	function generareQuiz()
	{
		var formular = document.getElementById("quiz");
		for(let i = 0; i < intrebari.length; i++)
		{
			var intr = document.createElement("li");
			intr.classList.add("intrebare");
			var text_intr = document.createElement("p");
			text_intr.innerHTML = (i+1) + ". " + intrebari[i].text_intrebare;
			intr.appendChild(text_intr);
			var rasp = intrebari[i].raspunsuri;
			var variante = document.createElement("div");
			//variante.classList.add("variante");
			for(let j = 0; j < rasp.length; j++)
			{
				let r = rasp[j];
				var inp = document.createElement("input");
				inp.type = "checkbox";
				inp.id = r[0] + i;
				
				var lab = document.createElement("label");
				lab.innerHTML = r[0];
				
				variante.appendChild(inp);
				variante.appendChild(lab);
			}
			intr.appendChild(variante);
			formular.appendChild(intr);
		}
		var buton = document.createElement("button");
		buton.id = "send_quiz";
		buton.type = "button";
		buton.innerHTML = "Trimite raspunsurile";
		formular.appendChild(buton);
	}
	
	generareQuiz();
	
	document.getElementById("send_quiz").onclick=function()
	{
		var formular = document.getElementById("quiz");
		var divuri = formular.children;
		var punctaj = 0;
		//console.log(divuri.length);
		for(let i = 0; i < divuri.length - 1; i++) // divuri.length - 1 pentru ca ultimul child este butonul
		{
			let div_curent = divuri[i];
			//console.log(div_curent);
			let parag = div_curent.children[0].innerHTML;
			//console.log(parag);
			let nr_intr = parseInt(parag.split(".")[0])-1
			//console.log(nr_intr);
			let raspunsuri = intrebari[nr_intr].raspunsuri;
			//console.log(raspunsuri);
			let rasp_user = div_curent.children[1].children
			let ok = true;
			for(let j = 0; j < rasp_user.length; j+=2) // sar din 2 in 2 pentru a sari peste label-uri
			{
				//console.log(rasp_user[j].checked);
				//console.log(raspunsuri[j/2][1]);
				if(rasp_user[j].checked != raspunsuri[j/2][1])
					ok = false;
				rasp_user[j].checked = false;
			}
			if(ok)
				punctaj += 1;
			//let intr = parseInt(parag[0]);
		}
		
		console.log(punctaj);
		var pct = document.getElementById("puncte");
		if(punctaj == intrebari.length )
			pct.innerHTML = "Ai obtinut " + punctaj + " puncte. Felicitari, ai facut totul perfect!";
		else 
			if(punctaj == 1)
				pct.innerHTML = "Ai obtinut un punct.";
			else
				pct.innerHTML = "Ai obtinut " + punctaj + " puncte.";
	}
}



	



	