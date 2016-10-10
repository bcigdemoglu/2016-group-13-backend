# 2016-group-13-backend

This is the Python-Flask backend repo for 2016-group-13.

<!-- TOC START min:2 max:5 link:true update:true -->
  - [Setting up the environment](#setting-up-the-environment)
  - [Making an API call](#making-an-api-call)

<!-- TOC END -->

## Setting up the environment
```bash
# Clone the repo
git clone https://github.com/mbugrahanc/2016-group-13-backend.git
cd 2016-group-13-backend

# Install mongodb
brew install mongodb

# Install virtual environment
sudo pip install virtualenv
virtualenv venv

# Login to heroku
heroku login

# Activate virtual environment (must be run every time the folder is accessed)
. venv/bin/activate

# Update dependencies
pip install -r requirements.txt

# Run tests
. restful_test.sh

# Deactivate virtual environment once done
deactivate
```

Always run the virtual environment when working locally
```bash
. venv/bin/activate
```

To test RESTful API locally (must have mongo installed)
```bash
. restful_test.sh
```

Remote database shell access:
```bash
uri=$(heroku config | grep MONGODB_URI) &&
[[ $uri =~ \/\/(.*):(.*)@(.*)$ ]] &&
mongo "${BASH_REMATCH[3]}" -u "${BASH_REMATCH[1]}" -p "${BASH_REMATCH[2]}"
```

Database web access:
```bash
heroku addons:open mongolab
```

Useful aliases for ~/.bash_profile (Mac OSX):
```bash
alias herokurun='heroku ps:scale web=1'
alias herokustop='heroku ps:scale web=0'
alias herokupush='git push heroku master'
```

Flask reference:
http://flask.pocoo.org/docs/0.10/.latex/Flask.pdf
https://flask-pymongo.readthedocs.io/en/latest/

## Making an API call
We can make API calls by directing them to https://oose-2016-group-13.herokuapp.com/
```bash
curl -v -X GET \
    -H "Content-Type: application/json" \
    -d '{}' \
    https://oose-2016-group-13.herokuapp.com/

 # Returns
{
  "status": "OK",
  "mongo": "Database(MongoClient(host=['ds053126.mlab.com:53126'], document_class=dict, tz_aware=True, connect=True, replicaset=None), u'heroku_wxn3r3t7')"
}
```

This can be coded in flask_rest_service/resources.py using flask as:
```python
@app.route('/')
def hello():
    return {
            'status': 'OK',
            'mongo': str(mongo.db),
        }
```
Or using flask_restful library:
```python
class Root(restful.Resource):
    def get(self):
        return {
            'status': 'OK',
            'mongo': str(mongo.db),
        }
api.add_resource(Root, '/')
```
See here for additional resources: http://flask.pocoo.org/docs/0.11/quickstart/
