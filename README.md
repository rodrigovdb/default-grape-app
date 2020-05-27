# default-grape-app
Default Ruby Grape APP with some authentication

# Access

## Check an URL
```
$ curl -i \
-H Accept-Version:v1 \
-H Content-Type:application/json \
-H XAuthToken:2dac882bd38a1a588ea2c9f2630f5c1c \
http://localhost:8080/api/health; echo
```

## Obtaining a Token
```
$ curl -i \
-H Accept-Version:v1 \
-X POST \
-d 'public_key=my_public_key&password=my_password' \
http://localhost:8080/api/auth; echo
```

This will return something like
```
HTTP/1.1 201 Created
Date: Fri, 20 Mar 2015 18:44:16 GMT
Status: 201 Created
Connection: close
Content-Type: application/json
Content-Length: 44

{"token":"d07cc74a32c17003cff82d3cfa5a49c9"}
```

## Acessing with token
```
$ curl -i \
-H Accept-Version:v1 \
-H Content-Type:application/json \
-H XAuthToken:2dac882bd38a1a588ea2c9f2630f5c1c \
http://localhost:8080/api/foo/bar; echo
```

The will returns something like
```
HTTP/1.1 200 OK
Date: Fri, 20 Mar 2015 18:46:29 GMT
Status: 200 OK
Connection: close
Content-Type: application/json
Content-Length: 23

{"namespace":"foo_bar"}
```

# Developing

* Change `.env` with your db
* Change `docker-compose.yml` with right volumes

```
$ docker-compose build
$ docker-compose run --rm api bundle exec rake db:create db:migrate db:seed
$ docker-compose up
```

and then access `http://localhost:3000/docs` to have access to all endpoints.
