#!/usr/bin/python3

import requests
import sys
from random import randint
from time import sleep

if len(sys.argv) < 2:
    print("[INFO] Usage: python3 %s feed.txt" % sys.argv[0])
    sys.exit()

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def npmVerify(feed):
    url = "https://www.npmjs.com/package/"

    with open(feed, "r") as f:
        for i in f:
            url = "https://www.npmjs.com/package/" + i.rstrip()
            print("[INFO] Checking: %s" % i.rstrip())
            r = requests.get(url)
            status = r.status_code
            response = r.text
            #print(status)
            #print(response)

            if status != 200:
                print(bcolors.WARNING + "[+] Package %s might be Vulnerable!" % i.rstrip() + bcolors.ENDC)
            else:
                sleep(randint(1,3))
                continue

if __name__ == '__main__':
    feed = sys.argv[1]

    npmVerify(feed)
