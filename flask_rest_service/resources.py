from flask import request, abort, json
import flask_restful as restful
from flask_restful import reqparse
from flask_rest_service import app, api, mongo
from bson.objectid import ObjectId

class Inserter(restful.Resource):
    def get(self):
        testing_id = mongo.db.testing.insert({"trial_key" : "trial_val"})
        return mongo.db.testing.find_one({"_id": testing_id})

@app.route('/rem', methods=['GET'])
def remove_from_database():
    testing_id = mongo.db.testing.remove({"trial_key": "trial_val"})
    return testing_id

class Finder(restful.Resource):
    def get(self):
        return [x for x in mongo.db.testing.find({"trial_key": "trial_val"})]

class Root(restful.Resource):
    def get(self):
        return {
            'status': 'OK',
            'mongo': str(mongo.db),
        }

class ReadingList(restful.Resource):
    def __init__(self, *args, **kwargs):
        self.parser = reqparse.RequestParser()
        self.parser.add_argument('reading', type=str)
        super(ReadingList, self).__init__()

    def get(self):
        return [x for x in mongo.db.readings.find()]

    def post(self):
        args = self.parser.parse_args()
        if not args['reading']:
            abort(400)
        with open('pylog.txt', 'w') as file_:
            file_.write(args['reading'])
        jo = json.loads(args['reading'])
        reading_id =  mongo.db.readings.insert(jo)
        return mongo.db.readings.find_one({"_id": reading_id})


class Reading(restful.Resource):
    def get(self, reading_id):
        return mongo.db.readings.find_one_or_404({"_id": reading_id})

    def delete(self, reading_id):
        mongo.db.readings.find_one_or_404({"_id": reading_id})
        mongo.db.readings.remove({"_id": reading_id})
        return '', 204

api.add_resource(Root, '/')
api.add_resource(ReadingList, '/readings/')
api.add_resource(Reading, '/readings/<ObjectId:reading_id>')

api.add_resource(Finder, '/find')
api.add_resource(Inserter, '/ins')
