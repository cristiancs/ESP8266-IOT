var TelegramBot = require('node-telegram-bot-api');

var mqtt = require('mqtt')
var client  = mqtt.connect('mqtt://127.0.0.1')
 
 function updateTemperatura(){
 	console.log("Starting Updates");
 	client.publish('/exterior/temperatura_piscina', 'READ');
 	setTimeout(function(){
		client.publish('/exterior/temperatura_tinaja', 'READ');
		setTimeout(function(){	
			client.publish('/exterior/temperatura_exterior', 'READ');
	 	},500)
 	},500)
 }
client.on('connect', function () {
	console.log("Connected");
	updateTemperatura();
	client.subscribe('/exterior/timbre');
	client.subscribe('/exterior/temperatura_tinaja');
	setInterval(updateTemperatura, 60000)

})
 

 // replace the value below with the Telegram token you receive from @BotFather
var token = '';

// Create a bot that uses 'polling' to fetch new updates
var bot = new TelegramBot(token, { polling: false });

 console.log(new Date(), "Started")

 var d1 = new Date();
 var d2 = new Date()
client.on('message', function (topic, message) {
	if(topic == '/exterior/timbre'){
		if ((new Date()).getTime() > d1.getTime()+15000){
			d1 = new Date();
			console.log(new Date(), "Mensaje Enviado");
			bot.sendMessage("", "Tocan el Timbre");
		} 
	}
	if(topic == '/exterior/temperatura_tinaja'){

		if((new Date()).getTime() > d2.getTime()+600000 && message != "READ" && parseInt(message,10) >= 37){
			bot.sendMessage("", "La Temperatura tinaja es de "+ message);
			d2 = new Date();
		}
	}
})


