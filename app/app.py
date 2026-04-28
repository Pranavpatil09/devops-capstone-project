from flask import Flask
app = Flask(__name__)
@app.route("/")
def home():
   return "Hi Sir, My DevOps Capstone Project Successfully Deployed on EC2 server!"
@app.route("/health")
def health():
   return {"status": "UP"}
if __name__ == "__main__":
   app.run(host="0.0.0.0", port=5000)
