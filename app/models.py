from db import db

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    completed = db.Column(db.Boolean, default=False)
    priority = db.Column(db.Integer, default=1)
    deadline = db.Column(db.Date, nullable=True)

    def __repr__(self):
        return f"<Task {self.title}>"
