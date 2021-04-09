# npmHunter

## Description
A simple tool to scrap the Github repo for the target organization and search for package.json files. Then, it will sort out all the `npm` packages and save it to `feed.txt` file. Use `npmChecker.py` tool for any profits. 

## Install
```
pip3 install truffleHog
apt-get install jq

git clone https://github.com/bigb0sss/npmHunter.git
```

## Usage
```
# npmHunter.sh
./npmHunter.sh <Last Page of the Github Repo> <Name of the Comapny>

Example:
./npmHunter.sh 1 company
[INFO] Collecting company Repo (1 to 1)
[INFO] Creating rules.json file...
[INFO] TruffleHog is running...(This may take a looong time)
[INFO] TruffleHog Running: anvil
[INFO] TruffleHog Running: Blueprint
[INFO] TruffleHog Running: cocoapods-generate
[INFO] TruffleHog Running: connect-api-examples
...snip...
[INFO] TruffleHog Running: workflow-kotlin
[INFO] TruffleHog Running: workflow-swift
[INFO] Sorting package.json files...
[INFO] Downloading package.json files...
[INFO] Parsing package.json...
[INFO] Creating feed.txt File...
[INFO] Done!

# npmChecker.py
python3 npmChecker.py feed.txt
[INFO] Checking: exist
[INFO] Checking: notexist
[+] Package notexist might be Vulnerable!
```

## Credit 
* truffleHog - https://github.com/dxa4481/truffleHog