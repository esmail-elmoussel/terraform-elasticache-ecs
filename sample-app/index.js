
const { createClient } = require('redis');
const express = require('express');

if(!process.env.REDIS_URL){
  throw new Error('Please provide a REDIS_URL');
}

const fruits = [
  {id: 1, name: 'Apple'},
  {id: 2, name: 'Banana'},
  {id: 3, name: 'Orange'},
  {id: 4, name: 'Mango'},
  {id: 5, name: 'Pineapple'},
  {id: 6, name: 'Peach'},
  {id: 7, name: 'Pear'},
  {id: 8, name: 'Grape'},
  {id: 9, name: 'Cherry'},
  {id: 10, name: 'Strawberry'},
];

const getRandomFruit = () => {
  const randomIndex = Math.floor(Math.random() * fruits.length);
  
  return fruits[randomIndex];
}

const db = {
  fruits: []
};

const redisClient = createClient({
  url: process.env.REDIS_URL
});

redisClient.on('error', err => console.log('Redis Client Error', err));

redisClient.connect().then(() => {
  console.log('Connected to Redis!');

  const app = express();

  app.get('/health', (req, res) => {
    res.sendStatus(200);
  });
    
  app.get('/', (req, res) => {    
    res.send('Hello From Sample App!');
  });

  app.get('/fruits/create', (req, res) => {
    const fruit = getRandomFruit();

    db.fruits.push(fruit);

    redisClient.del('fruits');

    res.json(fruit);
  });

  app.get('/fruits', async (req, res) => {
    let fruits;

    const fruitsFromCache = await redisClient.get('fruits');

    if (fruitsFromCache) {
      fruits = JSON.parse(fruitsFromCache);
    } else {
      fruits = db.fruits;

      redisClient.set('fruits', JSON.stringify(fruits), { EX: 15});
    }

    res.send({source: fruitsFromCache ? 'cache': 'database', fruits});
  });

  
  app.listen(3000, () => {
    console.log('Server listening on port 3000');
  });
}); 
