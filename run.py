
import os
from app import app

# Pull options from environment
DEBUG = (os.getenv('DEBUG', 'False') == 'True')


######################################################################
#   M A I N
######################################################################
if __name__ == "__main__":
    print("************************************************************")
    print("        T E S T   F L A S K   A P I   S E R V I C E ")
    print("************************************************************")
    app.run(host='0.0.0.0', debug=DEBUG)