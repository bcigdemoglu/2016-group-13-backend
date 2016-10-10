#!/bin/bash

dbpath="./data/db"
dblog="./log/mongod.log"
dbport="27017"
apiport="5000"
apihost="127.0.0.1"
apiserver="http://$apihost:$apiport"
testscript="./run_server.py"

echo "Activate virtual environment"
sh ./venv/bin/activate

echo "Check requirements"
pip install -r requirements.txt

echo "Remove existing database files"
rm -r "$dbpath"

echo "Create clean database folder"
mkdir -p "$dbpath"

echo "Start mongo"
mongod --fork --logpath "$dblog" --port "$dbport" --dbpath "$dbpath"

echo "Run test server"
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
    "$apiserver"/

echo -e "\n\n"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/readings/

echo -e "\n\n"

curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$apiserver"/hello/broname

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

echo "Kill local test server"
ps ax | grep run_server.py | awk '{print $1}' | xargs kill

echo "Kill mongo database file"
pgrep mongod | xargs kill