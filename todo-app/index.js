
const { createClient } = require('redis');
const express = require('express');

if(!process.env.REDIS_URL){
  throw new Error('Please provide a REDIS_URL');
}

const getRandomTodo = () => {
  const todos = [
    {
      id: 1,
      title: 'Go to gym!'
    },
    {
      id: 2,
      title: 'Learn Redis!'
    },
    {
      id: 3,
      title: 'Learn Docker!'
    },
    {
      id: 4,
      title: 'Learn ECS!'
    }
  ];

  const randomIndex = Math.floor(Math.random() * todos.length);

  return todos[randomIndex];
}

const db = {
  todos: []
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
    res.send('Hello From Moussel App!');
  });

  app.get('/todos/create', (req, res) => {
    const todo = getRandomTodo();

    db.todos.push(todo);

    redisClient.del('todos');

    res.json(todo);
  });

  app.get('/todos', async (req, res) => {
    let todos;

    const todosFromCache = await redisClient.get('todos');

    if (todosFromCache) {
      todos = JSON.parse(todosFromCache);
    } else {
      todos = db.todos;

      redisClient.set('todos', JSON.stringify(todos), { EX: 5});
    }

    res.send({source: todosFromCache ? 'cache': 'database', todos});
  });

  
  app.listen(3000, () => {
    console.log('Server listening on port 3000');
  });
}); 
