## How to run Docker containers? (Intel Only, doesn't work on Mac)
```
docker run -d --name flask-red -p 15000:8000 rsiddapp/flask-red:latest
docker run -d --name flask-green -p 15001:8000 rsiddapp/flask-green:latest
```

