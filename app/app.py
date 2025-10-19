from flask import Flask, render_template, request, redirect, url_for
from datetime import datetime
from db import db
from models import Task

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tasks.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# Import models
from models import Task

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        title = request.form.get("title")
        priority = request.form.get("priority")
        deadline = request.form.get("deadline")
        if title:
            task = Task(title=title, priority=int(priority), deadline=datetime.strptime(deadline, "%Y-%m-%d"))
            db.session.add(task)
            db.session.commit()
        return redirect(url_for("index"))
    
    tasks = Task.query.order_by(Task.priority.desc(), Task.deadline).all()
    return render_template("index.html", tasks=tasks)

@app.route("/complete/<int:task_id>")
def complete(task_id):
    task = Task.query.get_or_404(task_id)
    task.completed = True
    db.session.commit()
    return redirect(url_for("index"))

@app.route("/delete/<int:task_id>")
def delete(task_id):
    task = Task.query.get_or_404(task_id)
    db.session.delete(task)
    db.session.commit()
    return redirect(url_for("index"))

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=8080)