const expect = require('expect');
const request = require('supertest');

const {app} = require('./../index.js');

describe('POST: /connect ',()=>{
  it('Should Test the POST request of \'/connect\' response details', (done)=>
  {
    var expected = JSON.stringify({response: 'Token Registered!'});

    request(app)
    .post('/connect')
     .set("Content-Type", "application/json")
    .send({
    token : 'Automatic Backup WiFi Camera'
    })
    .expect(200)
    .expect("Content-Type", "application/json; charset=utf-8")
    .expect((res)=>{
      expect(res.body.response).toBe('Token Registered!');
    })
    .end(done);
  }); //it
}); //describe

describe('GET: /checkToken : token - null',()=>{
  beforeEach((done)=>{
    request(app)
    .post('/connect')
     .set("Content-Type", "application/json")
    .send({
    token : null
  }).end(done);
  });

  it('Should Test response is FALSE when Token : NULL ', (done)=>
  {
    request(app)
    .get('/checkToken')
    .expect(200)
    .expect("Content-Type", "application/json; charset=utf-8")
    .expect((res)=>{
      expect(res.body.token).toBe(false);
    })
    .end(done);;
  }); //it
}); //describe

describe('GET: /checkToken : token - Not null',()=>{
  beforeEach((done)=>{
    request(app)
    .post('/connect')
     .set("Content-Type", "application/json")
    .send({
    token : 'Automatic Backup WiFi Camera'
  }).end(done);
  });

  it('Should Test response is TRUE when Token : NOT NULL', (done)=>
  {
    request(app)
    .get('/checkToken')
    .expect(200)
    .expect("Content-Type", "application/json; charset=utf-8")
    .expect((res)=>{
      expect(res.body.token).toBe(true);
    })
    .end(done);;
  }); //it
}); //describe

describe('POST: /notify',()=>{
  it('should test: flag value = 1 => Stream Ended',(done)=>{

    request(app)
    .post('/notify')
    .set("Content-Type", "application/json")
    .send({
    flag : 1
    })
    .expect(200)
    .expect("Content-Type", "application/json; charset=utf-8")
    .expect((res)=>{
        expect(res.body.response).toBe('Notification sent!');
        expect(res.body.flag).toBe(1);
        expect(res.body.note.aps.alert).toBe('✉ Stream ended!');
        }).end(done);
  }); //it

  it('should test: flag value != 1 => Stream starts',(done)=>{

    request(app)
    .post('/notify')
    .set("Content-Type", "application/json")
    .send({
    flag : 0
    })
    .expect(200)
    .expect("Content-Type", "application/json; charset=utf-8")
    .expect((res)=>{
        expect(res.body.response).toBe('Notification sent!');
        expect(res.body.flag).toBe(0);
        expect(res.body.note.aps.alert).toBe('✉ Stream is starting');
        }).end(done);
  }); //it

});//describe
