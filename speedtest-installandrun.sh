# speed_cli.py has been depricated
# wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py
# replaced by new version

#get
wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py

#set
chmod a+rx speedtest.py
mv speedtest.py /usr/local/bin/speedtest
chown root:root /usr/local/bin/speedtest

#run
speedtest
speedtest --server 3386
