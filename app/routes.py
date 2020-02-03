from app import app


@app.route('/')
@app.route('/index')
def index():
    """ Send back the home page """
    return app.send_static_file('index.html')
