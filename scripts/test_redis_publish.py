import redis
import time

if __name__ == "__main__":
    redis_client = redis.StrictRedis(host="localhost", port=5000, password="redis")
    channel_name = "realtime_account_info"
    while True:
        redis_client.publish(channel_name, "hello redis")
        print("finish publish message to channel")
        time.sleep(2)
