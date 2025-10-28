#!/bin/bash
sudo apt install hping3

timeout 10s sudo hping3 --flood -1 127.0.0.1