#!/bin/bash
sudo apt install hping3

timeout 10s sudo hping3 -p 22 --flood -1 172.18.0.5