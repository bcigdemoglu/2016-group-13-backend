# 2016-group-13-backend

## This is the Python-Flask backend repo for 2016-group-13.

Setting up the environment:
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

Always run the virtual environment when working locally:
```bash
. venv/bin/activate
```

To test RESTful API locally (must have mongo installed):
```bash
. restful_test.sh
```

Remote database shell access:
```bash
mongo ds053126.mlab.com:53126/heroku_wxn3r3t7 -u heroku_wxn3r3t7 -p jnhrj28k1m0o323n5s6eftl9il
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
