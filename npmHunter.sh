### Colors
red=`tput setaf 1`;
green=`tput setaf 2`;
yellow=`tput setaf 3`;
blue=`tput setaf 4`;
magenta=`tput setaf 5`;
cyan=`tput setaf 6`;
bold=`tput bold`;
clear=`tput sgr0`;

repoLastPage=$1
repoName=$2

# Scrapping the Repos
echo "${yellow}[INFO] Collecting $repoName Repo (1 to $repoLastPage)${clear}" &&
for i in {1..$repoLastPage}; do curl -s -k https://github.com/$repoName?page=$i | grep $repoName | grep mr-3 | awk '{print $2}' 2>/dev/null  >> tmp; done && cat tmp | cut -d "/" -f 3 | sort -u > github-repo.txt && rm tmp &&

# Creating rules.json
echo "${yellow}[INFO] Creating rules.json file...${clear}" &&
echo '{
"package.json": "dependencies"
}' > rules.json &&

# Trufflehog
mkdir -p npm &&
echo "${yellow}[INFO] TruffleHog is running...(This may take a looong time)${clear}"
while read i; do echo "[INFO] TruffleHog Running: $i" && trufflehog --max_depth 1 --regex --rules rules.json --entropy=False https://github.com/$repoName/$i 2>/dev/null > npm/$i; done < github-repo.txt &&
echo "${yellow}[INFO] Done!${clear}"

# Deleting files with 0 size & save the file name
find npm/ -type f -empty -delete && ls npm/ > npm/file.txt &&

# Listing files with only containing "package.json"
echo "${yellow}[INFO] Sorting package.json files...${clear}" &&
while read i; do echo "[INFO] Repo: "$i && cat npm/$i 2>/dev/null | grep Filepath | grep -v lock | grep 'package.json' | sort -u; done < npm/file.txt >> tmp &&

# Sorting files with "package.json"
cat tmp | grep -B1 Filepath | grep INFO | cut -d " " -f 3 > npm/file_package.txt && 
rm tmp &&

# Downloading all the package.json
echo "${yellow}[INFO] Downloading package.json files...${clear}" &&
mkdir -p npm/package && 
while read i; do wget https://raw.githubusercontent.com/$repoName/$i/master/package.json -O npm/package/$i 2>/dev/null; done < npm/file_package.txt &&

# Deleting files with 0 size & save the file name
find npm/package -type f -empty -delete && 
ls npm/package > npm/package/file.txt &&

# Collecting npm packages
echo "${yellow}[INFO] Parsing package.json...${clear}"
while read i; do cat npm/package/$i | jq -r '.dependencies' 2>/dev/null >> npm/package/dependencies.txt && cat npm/package/$i | jq -r '.devDependencies' 2>/dev/null >> npm/package/dependencies.txt; done < npm/package/file.txt &&

# Creating feed.txt file
echo "${yellow}[INFO] Creating feed.txt File...${clear}" &&
cat npm/package/dependencies.txt | grep '"' | cut -d '"' -f 2 | sort -u > feed.txt
echo "${yellow}[INFO] Done!${clear}"
