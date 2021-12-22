# source / discuss https://gist.github.com/gnremy/c546c7911d5f876f263309d7161a7217 
# source file is a comma seperated file by greynoise.io 

# just give me the IP list - bvdl 12-2021

curl -s https://gist.githubusercontent.com/gnremy/c546c7911d5f876f263309d7161a7217/raw | cut -d, -f1 | sed '1d'
