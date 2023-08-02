from redis_subscriber import get_redis_manager
import multiprocessing
import redis
import json
import time

stg_template = {
    "Datetime" : "2023-08-02 09:54:18",
    "Account" : "test_account",
    "Strategies" : {
        "jx1_Vol_0": {
            "positions": {
                "ps": {
                    "name": "ps",
                    "id": "SpreadTakerAlgo_jx1_Vol_0_000001",
                    "symbols": [
                        "IO2307-P-3750",
                        "IO2308-P-3700"
                    ],
                    "ratio": [
                        -1,
                        1
                    ],
                    "label": [
                        "near_put",
                        "far_put"
                    ],
                    "position_ratio": 1.0,
                    "risk_point": 3735.3333333333335,
                    "position_volume": 24.0,
                    "hedge_volume": 0.0,
                    "ini_hedge": False,
                    "status": 2
                }
            }
        }
    },
    "msg_type" : 107
}

acct_template = {
    "Datetime": "2023-08-02 09:54:18",
    "Account": "test_account",
    "Liability": 8965000,
    "Product": "IF",
    "Equity": 9123305.08,
    "PnL": 158305.08,
    "Available": 4227002.36,
    "Total_Delta": 25.21,
    "Margin_PCT": 0.54,
    "Option_Gamma": -12.85,
    "Option_Vega": -590.18,
    "Option_Theta": 6595.24,
    "Option_Open_Volume_ByExp": [],
    "Option_Open_Volume": 0,
    "Positions": [
        {
            "Symbol": "IF2307",
            "Product": "FUTURES",
            "Volume": 3,
            "Frozen": 1248307.2,
            "Delta": 900,
            "Gamma": 0,
            "Vega": 0,
            "Theta": 0,
            "Average_price": 3936.47,
            "Mark_price": 3855.4,
            "Pnl": -116040.0
        }
    ],
    "Greeks": [
        {
            "Account": "prod1-jx1-159900382",
            "Product": "CSI300",
            "Delta": -47.59,
            "Gamma": -10.7,
            "Vega": -1325.88,
            "Theta": 4062.02,
            "Margin": 0.35
        },
        {
            "Account": "prod1-jx1-159900382",
            "Product": "CSI1000",
            "Delta": 72.6,
            "Gamma": -2.18,
            "Vega": 736.55,
            "Theta": 2525.03,
            "Margin": 0.24
        }
    ],
    "Spreads": []
}

redis_config = {
    "host": "localhost",
    "port": 5000,
    "password": "redis",
    "channel": ["realtime_account_info"]
}

def send_process():
    redis_client = redis.Redis(host=redis_config["host"],
                                     port=redis_config["port"],
                                     password=redis_config["password"])
    n = 0
    while True:
        if n % 2 == 0:
            stg_str = json.dumps(stg_template)
            redis_client.publish("realtime_account_info", stg_str)
        else:
            acct_str = json.dumps(acct_template)
            redis_client.publish("realtime_account_info", acct_str)
        time.sleep(5)
        n = n + 1

def recv_process():
    redis_manager = get_redis_manager()
    while True:
        accounts = redis_manager.get_accounts()
        print("---------------------------------------------------")
        print(json.dumps(accounts, indent=4))
        print("---------------------------------------------------")
        time.sleep(2)
        

if __name__ == "__main__":
    p_send = multiprocessing.Process(target=send_process)
    p_recv = multiprocessing.Process(target=recv_process)
    p_send.start()
    p_recv.start()
    p_send.join()
    p_recv.join()

