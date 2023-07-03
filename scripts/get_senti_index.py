"""
A股新闻情绪指数数据获取
"""

import requests
import json
import csv
import os
from requests_toolbelt import MultipartEncoder

# 飞书应用的id和密码
app_id = 'cli_a4cc9b86a4eb100e'
app_secret = 'p3p6J6Ugph9cr1UV04GjAgXuAFtw7La7'

senti_url = "https://www.chinascope.com/inews/senti/index?period=YEAR"
csv_file_name = "senti_data.csv"

def get_token(app_id,app_secret):
    url = 'https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal'
    data = {
        "Content-Type":"application/json; charset=utf-8",
        "app_id": app_id,
        "app_secret": app_secret
    }
    response = requests.request("POST", url, data=data)
    return json.loads(response.text)['tenant_access_token']

def get_chat_ids(app_id,app_secret):
    """
        一个应用可能关联到多个会话群,获取所有这些会话群的chat_id信息
        返回dict:
            key: chat_id
            value: 群名称或会话名称
    """
    url = "https://open.feishu.cn/open-apis/im/v1/chats?page_size=20"
    payload = ''
    tenant_access_token = get_token(app_id,app_secret)
    Authorization = 'Bearer ' + tenant_access_token
    headers = {
        'Authorization': Authorization
    }
    response = requests.request("GET", url, headers=headers, data=payload)
    chat_ids = {}

    for item in json.loads(response.text)['data']['items']:
        if 'chat_id' in item:
            chat_ids[item['chat_id']] = item['name']

    return chat_ids

def upload_file(file_dir: str, file_name: str, content_type: str, token: str):
    file_path = os.path.join(file_dir, file_name)
    url = "https://open.feishu.cn/open-apis/im/v1/files"
    form = {
        'file_type': 'stream',
        'file_name': file_name,
        'file':  (file_name, open(file_path, 'rb'), content_type)}
  
    multi_form = MultipartEncoder(form)
    headers = {
        'Authorization': f'Bearer {token}'
    }

    headers['Content-Type'] = multi_form.content_type
    response = requests.request("POST", url, headers=headers, data=multi_form)
    content_dict = json.loads(response.content.decode('utf-8'))
    return content_dict['data']['file_key']

def send_file(token, chat_id, file_key):
    url = "https://open.feishu.cn/open-apis/im/v1/messages"
    params = {"receive_id_type":"chat_id"}
    msg = "file"
    msgContent = {
        "file": msg,
    }

    file_key = json.dumps({"file_key":file_key})
    req = {
        "receive_id": chat_id, 
        "msg_type": "file",
        "content":file_key
    }

    payload = json.dumps(req)
    Authorization = 'Bearer ' + token
    headers = {
        'Authorization': Authorization,
        'Content-Type': 'application/json'
    }
    requests.request("POST", url, params=params, headers=headers, data=payload)

if __name__ == "__main__":
    response = requests.get(senti_url)
    if response.status_code == 200:
        csv_data = []
        csv_data.append(['tradeDate', 'maIndex1'])
        data_list = json.loads(response.text)
        for elem in data_list:
            csv_data.append([elem['tradeDate'], elem['maIndex1']])
        with open(csv_file_name, "w") as f:
            writer = csv.writer(f)
            writer.writerows(csv_data)

        token = get_token(app_id, app_secret)
        chat_ids = get_chat_ids(app_id, app_secret)
        csv_file_key = upload_file(".", csv_file_name, 'text/csv', token)
        for chat_id, name in chat_ids.items():
            if name == 'option_check':
                send_file(token, chat_id, csv_file_key)
                print(f"Send file {csv_file_name} to {name} success!")

