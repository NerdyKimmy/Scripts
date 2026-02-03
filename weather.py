#!/usr/bin/env python3
import requests
import sys
import os
import json
import time

API_KEY = ""
CITY_ID = "703448" #Kyiv
UNITS = "metric"

CACHE_FILE = os.path.expanduser("/home/allie/.cache/weather_cache.json")
CACHE_EXPIRY = 600

ICONS = {
    "01d": "󰖙",
    "01n": "󰖔",
    "02d": "󰖕",
    "02n": "󰼱",
    "03d": "󰖐",
    "03n": "󰖐",
    "04d": "󰖐",
    "04n": "󰖐",
    "09d": "󰖗",
    "09n": "󰖗",
    "10d": "󰖖",
    "10n": "󰖖",
    "11d": "󰖓",
    "11n": "󰖓",
    "13d": "󰖘",
    "13n": "󰖘",
    "50d": "󰖑",
    "50n": "󰖑",
}

def get_weather():
    if os.path.exists(CACHE_FILE) and os.path.getsize(CACHE_FILE) > 0:
        file_age = time.time() - os.path.getmtime(CACHE_FILE)
        if file_age < CACHE_EXPIRY:
            try:
                with open(CACHE_FILE, "r") as f:
                    return json.load(f)
            except: pass

    try:
        url = f"https://api.openweathermap.org/data/2.5/weather?id={CITY_ID}&appid={API_KEY}&units=metric"
        res = requests.get(url, timeout=5)
        if res.status_code == 200:
            data = res.json()
            os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
            with open(CACHE_FILE, "w") as f:
                f.write(json.dumps(data))
            return data
    except: pass

    if os.path.exists(CACHE_FILE) and os.path.getsize(CACHE_FILE) > 0:
        try:
            with open(CACHE_FILE, "r") as f:
                return json.load(f)
        except: return None
    return None

data = get_weather()
if data and 'main' in data:
    temp = int(round(data['main']['temp']))
    icon = ICONS.get(data['weather'][0]['icon'], "󰖐")
    print(icon, " ",str(temp)+'°')

else:
    print("󰖐   --°")
