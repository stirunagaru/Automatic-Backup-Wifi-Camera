var express = require('express');
var bodyParser = require('body-parser');
var apn = require('apn');
var app = express();
var fs = require('fs');
var request = require('request');
var gpio = require('rpi-gpio');
const cv = require('opencv4nodejs');

var token;
var clients = 0;
var interval;
var sensor_int;
var reverse = false;
var camera = new cv.VideoCapture(0);
camera.set(3,320);
camera.set(4,240);

gpio.setup(2,gpio.DIR_IN,looping);
gpio.setMode(gpio.MODE_BCM);

function get_frame()
{
        var jpeg;
        if(camera==null)
        {
          reInitCam();
        }
        var some = camera.read();
        var bytes = cv.imencode('.jpg',some).toString('base64');
        return bytes;
}

function checkToken()
{
  if(token!=null)
  {
    return true;
  }
  else
  {
    return false;
  }
}

function releaseCam()
{
  clearInterval(interval);
  if(camera!=null)
  {
    camera.release();
    camera = null;
  }
}

function reInitCam()
{
  releaseCam();
  camera = new cv.VideoCapture(0);
  camera.set(3,320);
  camera.set(4,240);
}

function initCam()
{
  if(camera!=null)
  {
    reInitCam();
  }
  else
  {
    camera = new cv.VideoCapture(0);
    camera.set(3,600);
    camera.set(4,400);
  }
}

function setToken(arg)
{
        token = arg;
        clients += 1;
        console.log(token);
}

function sendNotification(arg)
{
  base_url = "http://localhost:3000/notify";
  request.post(base_url,{json:{'flag':arg}},function(err,res,body)
  {
    if(!err)
    {
      console.log('Notification Sent!');
    }
  });
}

function looping()
{
  sensor_int = setInterval(()=>{
    gpio.read(2, function(err, value) {
        if (err) throw err;
        if(value==true)
        {
          if(reverse==true)
          {
            reverse = false;
            releaseCam();
            sendNotification(1);
            console.log('Driving');
          }
        }
        else
        {
          if(reverse!=true)
          {
            reverse = true;
            initCam();
            sendNotification(0);
            console.log('Reverse');
          }
        }
    });
  },1);
}

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(function(req,res,next){
        res.locals.errors = null;
        next();
});

app.get('/start', function(req,res){

        req.on("close", function() {
            res.end("Stopped");
            releaseCam();
        });

        if(camera==null)
        {
          initCam();
        }

        res.setHeader('Content-Type','multipart/x-mixed-replace; boundary=frame');
        res.setHeader('Connection', 'close');

        interval = setInterval(function(){
            res.write("\r\n--frame\r\n");
            res.write("Content-Type: image/jpeg\r\n\r\n");
            res.write(Buffer(get_frame(),'base64'));
        },33.33); //60 FPS ~ 16.66 //30fps ~ 33.33
})

app.get('/stop', function(req,res){
  res.setHeader('Content-type','text/plain');
  res.send('Stopped');
  releaseCam();
})



app.get('/checkToken', function(req,res){
  res.setHeader('Content-type','application/json');
  res.send(JSON.stringify({
          token: checkToken()
  }))
})

app.post('/connect', function(req,res){
        res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify({
                                response: "Token Registered!"
                }));
                setToken(req.body.token);
})

app.post('/notify', function(req,res){
	/*0 for start
	1 for stop
	{flag:0 or 1}
	*/
		var flag = req.body.flag;
		let service = new apn.Provider({
	    cert: "/home/pi/Desktop/Server/Certificate/cert.pem",
	    key: "/home/pi/Desktop/Server/Certificate/key.pem",
	  });

		var note = new apn.Notification();

	  //note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
		note.expiry = 0
		note.priority = 10
	  note.badge = 1;
	  note.sound = "ping.aiff";
	  if(flag != 1)
		{
			note.alert = "\u2709 Stream is starting";
		}
		else
		{
			note.alert = "\u2709 Stream ended!";
		}
		note.aps.category = flag
	  note.payload = {'messageFrom': 'Shivang Dave'};
	  note.topic = "sd.Automatic-Backup-WiFi-Camera";

	  service.send(note, token).then( (result) => {
			res.setHeader('Content-type','application/json');
			res.send(JSON.stringify({
				response: "Notification sent!",
				flag: flag,
        note: note
			}))
	  });
})

app.listen(3000, function(){
	console.log('Server started on port 3000');
})


module.exports = {app};
