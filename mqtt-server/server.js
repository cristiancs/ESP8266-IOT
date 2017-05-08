var mosca = require('mosca')
var TelegramBot = require('node-telegram-bot-api');
var settings = {
  port: 1883
};
//Telegram

 // replace the value below with the Telegram token you receive from @BotFather
var token = '';

// Create a bot that uses 'polling' to fetch new updates
var bot = new TelegramBot(token, { polling: false });
var telegramChat = "";


//here we start mosca
var server = new mosca.Server(settings);
server.on('ready', setup);
 
// fired when the mqtt server is ready
function setup() {
  console.log(new Date(),'Mosca server is up and running')
}
 
// fired whena  client is connected
server.on('clientConnected', function(client) {
	bot.sendMessage(telegramChat, "Se ha conectado "+ client.id);
  	console.log(new Date(),'client connected', client.id);
});

// fired when a message is received
server.on('published', function(packet, client) {
 // console.log(new Date(),'Published : ', packet.payload);
});

// fired when a client subscribes to a topic
server.on('subscribed', function(topic, client) {
  console.log(new Date(),'subscribed : ', topic, client.id);
  bot.sendMessage(telegramChat, client.id+ "Se ha subscrito a "+topic);
});
 
// fired when a client unsubscribes to a topic
server.on('unsubscribed', function(topic, client) {
  console.log(new Date(),'unsubscribed : ', topic);
  bot.sendMessage(telegramChat, client.id+ "Se ha desubscrito a "+topic);
});
 
// fired when a client is disconnecting
server.on('clientDisconnecting', function(client) {
  console.log(new Date(),'clientDisconnecting : ', client.id);
  
});
 
// fired when a client is disconnected
server.on('clientDisconnected', function(client) {
  console.log(new Date(),'clientDisconnected : ', client.id);
  bot.sendMessage(telegramChat, "Se ha desconectado "+ client.id);
});