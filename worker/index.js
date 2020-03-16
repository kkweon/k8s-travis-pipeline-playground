const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});
const sub = redisClient.duplicate();

const cache = new Map();

function fib(index) {
  if (index < 2) return 1;
  if (cache.has(index)) return cache.get(index);

  const result = fib(index - 2) + fib(index - 1);
  cache.set(index, result);
  return result;
}

sub.on('message', (_channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});
sub.subscribe('insert');
