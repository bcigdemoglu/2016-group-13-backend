#!/bin/bash

dbpath="./data/db"
dblog="./log/mongod.log"
dbport="27017"
apiport="5000"
apihost="127.0.0.1"
apiserver="http://$apihost:$apiport"
testscript="./run_server.py"

echo "Killing local test server"
ps ax | grep run_server.py | awk '{print $1}' | xargs kill

echo "Killing mongo database file"
pgrep mongod | xargs kill

echo "Activating virtual environment"
. ./venv/bin/activate

echo "Updating dependencies"
pip install -r requirements.txt

echo "Removing existing database files"
rm -r "$dbpath"

echo "Creating clean database folder"
mkdir -p "$dbpath"

echo "Starting mongo"
mongod --fork --logpath "$dblog" --port "$dbport" --dbpath "$dbpath"

echo "Waiting for mongod to run"
while ! nc -vz "$apihost" "$dbport"; do sleep 1; done
echo "Mongod successfully up"

echo "Running test server"
python "$testscript" &

echo "Waiting for the test server to run"
while ! nc -vz "$apihost" "$apiport"; do sleep 1; done
echo "Test server successfully up"

echo -e "\n\n"

echo "----------------------------------------------------------------"
echo "Testing restful commands"
echo "----------------------------------------------------------------"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/find

echo -e "\n\n"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/ins

echo -e "\n\n"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/find

echo -e "\n\n"

# curl -v -X GET \
#     -H "Content-Type: application/json" \
#     -d '{}' \
#     http://localhost:5000/readings/

# echo "\n\n"

# curl -v -X POST \
#     -H "Content-Type: application/json" \
#     -d '{"reading": "bookname1"}' \
#     http://localhost:5000/readings/

# echo "\n\n"

echo "Killing local test server"
ps ax | grep run_server.py | awk '{print $1}' | xargs kill

echo "Killing mongo database file"
pgrep mongod | xargs kill

echo "Exiting virtual environment"
deactivate