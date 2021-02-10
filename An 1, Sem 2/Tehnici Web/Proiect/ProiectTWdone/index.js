var express = require('express');/*include modulul express
memorand in variabila express obiectul asociat modulului(exportat de modul)*/
var path = require('path');
var app = express();
var formidable = require('formidable');
var session = require('express-session');

var fs = require('fs');//file system
var crypto = require('crypto')

// pentru folosirea ejs-ului 
app.set('view engine', 'ejs');

app.use(session(
	{
		secret:"cheie_sesiune",
		resave: true,
		saveUninitialized:false
	}
)); // creeaza campul session in request: req.session(req.session e acelasi obiect pentru toate cererile)

app.use(express.static(path.join(__dirname, 'resources')));


// -------------------- cereri de tip post----------------
//<form method="post" action="/inreg"

app.post('/inreg',function(req,res) {
  var dateForm=new formidable.IncomingForm()
	dateForm.parse(req, function(err, fields, files){
		//<input type="file" name="fis1" /> ----> files.fis1
		//fields e pentru restul de inputuri <input name="ceva" ---> fields.ceva
		var textJson=fs.readFileSync("useri.json","utf8"); //cale relativa la fisierul index.js
		var obJson=JSON.parse(textJson);
		var parolaCriptata;
		var algoritmCriptare=crypto.createCipher("aes-128-cbc", "cheie_criptare")
		parolaCriptata=algoritmCriptare.update(fields.parola, "utf-8", "hex");
		parolaCriptata+=algoritmCriptare.final("hex");
    
		var userNou={
			id: obJson.lastId,
			username: fields.username,
			email: fields.email,
			parola: parolaCriptata,
			dataInreg: new Date(),
			rol: "user",
			phone: fields.phone,
			data_nastere: fields.data_nastere
		}
		obJson.useri.push(userNou);
		obJson.lastId+=1;
		//JSON.stringify opusul lui JSON.parse --->  din obiect imi face string
		var jsonNou=JSON.stringify(obJson);
		fs.writeFileSync("useri.json",jsonNou);
		res.redirect("/");
	})
})
/*
app.post('/login',function(req,res) {
	var dateForm=new formidable.IncomingForm()
	dateForm.parse(req, function(err, fields, files){
		//<input type="file" name="fis1" /> ----> files.fis1
		//fields e pentru restul de inputuri <input name="ceva" ---> fields.ceva
		var textJson=fs.readFileSync("useri.json","utf8"); //cale relativa la fisierul index.js
		var obJson=JSON.parse(textJson);
		var parolaCriptata;
		var algoritmCriptare=crypto.createCipher("aes-128-cbc", "cheie_criptare")
		parolaCriptata=algoritmCriptare.update(fields.parola, "utf-8","hex");
		parolaCriptata+=algoritmCriptare.final("hex");
		var user= obJson.useri.find(function(elem){
			return elem.username == fields.username &&  elem.parola==parolaCriptata
		})
		if(user){
			console.log("Exista utilizatorul")
			req.session.utilizator=user;
			res.render("html/index", {username: user.username})
		}
		else{
			res.send('Nume sau parola gresite!')
		}
    
	})
})
*/
// cand se face o cerere get catre pagina de index 
app.get('/', function(req, res) {
	/*afiseaza(render) pagina folosind ejs (deoarece este setat ca view engine) */
	
	//cond? val_if : val_else
	var usrn = req.session ? (req.session.utilizator? req.session.utilizator.username : null) : null;
    res.render('html/index', {username: usrn});
});

app.get('/logout', function(req, res) {
	req.session.destroy();
	res.redirect("/")
});

app.get('/bla', function(req, response) {
				console.log("bla bla")
        response.setHeader('Content-Type', 'text/html');
        
        response.write("<html><body>O pagina cu node</body></html>");
        response.end();
        
});

/*app.use(function(req, res) {
	res.status(404).render('html/404');
}
)*/

app.get('/*', function(req, res) {
	var usrn=req.session ? (req.session.utilizator? req.session.utilizator.username : null) : null;
	res.render('html/'+req.url, {username: usrn}, function(err, rezultatRender){
		if (err) {
			if (err.message.includes("Failed to lookup view"))
				res.status(404).render("html/404", {username: usrn});		
			else {
				throw err;
			}
		}
		else res.send(rezultatRender)
	});
});

app.post('/*', function(req, res) {
	var usrn=req.session ? (req.session.utilizator? req.session.utilizator.username : null) : null;
	res.render('html/'+req.url, {username: usrn}, function(err, rezultatRender){
		
		var dateForm=new formidable.IncomingForm()
		dateForm.parse(req, function(err, fields, files){
			//<input type="file" name="fis1" /> ----> files.fis1
			//fields e pentru restul de inputuri <input name="ceva" ---> fields.ceva
			var textJson=fs.readFileSync("useri.json","utf8"); //cale relativa la fisierul index.js
			var obJson=JSON.parse(textJson);
			var parolaCriptata;
			var algoritmCriptare=crypto.createCipher("aes-128-cbc", "cheie_criptare")
			parolaCriptata=algoritmCriptare.update(fields.parola, "utf-8","hex");
			parolaCriptata+=algoritmCriptare.final("hex");
			var user= obJson.useri.find(function(elem){
				return elem.username == fields.username &&  elem.parola==parolaCriptata
			})
			if(user){
				console.log("Exista utilizatorul")
				req.session.utilizator=user;
				res.render('html/'+req.url, {username: user.username})
			}
			else{
				res.render('html/'+req.url, {parola_gresita: true})
			}
		});
	});
});

app.listen(8080);
console.log('Aplicatia se va deschide pe portul 8080.');