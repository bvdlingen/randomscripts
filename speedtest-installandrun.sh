# notes: 
# 1. speed_cli.py has been depricated, replaced by new version
# 2. Please not that most Linux distributions have speedtest included in their package repository
#    Solus Linux example: eopkg install speedtest-cli

#get
wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py

#set
chmod a+rx speedtest.py
mv speedtest.py /usr/local/bin/speedtest
chown root:root /usr/local/bin/speedtest

#run
speedtest
speedtest --server 3386
