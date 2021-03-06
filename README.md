# API docs

The Teacher Management Subsystem provides an API, so that the other subsystems 
can access some functionality. This document lists the endpoints, and the necessary
parameters of the queries, as well as the format of the expected result.

Every request must have an ```api_key``` field in the main object. Missing or incorrect
api_keys result in ``401 Unauthorized``

A working copy of the Subsystem can be found at [teachersystem.herokuapp.com](teachersystem.herokuapps.com).

## Sign up to Course
The Student Management Subsystem allows students to register to courses. The SMS must send a 
POST request:


```POST /courses/signup```

containing:
```
{
    "signup": {
        "course_id":3,
        "snum":333222333,
        "first":"John",
        "last":"Smith"
	},
    "api_key":"asd"
}
```
where *snum* is the student number.

Upon success, the response has status code ``201 Created``, and its body contains the created signup object.
The signup can fail if the student is already signed up, or if the course is full. These result in
``422 Unprocessable Entity`` with a descriptive error in the body. Missing or invalid fields also cause this error.

## Drop a Course
The Student Management Subsystem allows students to drop courses. The SMS must send a 
POST request:


```POST /courses/drop```

containing:
```
{
    "drop": {
        "course_id":3,
        "snum":333222333
	},
    "api_key":"asd"
}
```
where *snum* is the student number.

Upon success, the response has status code ``200 OK``, and its body contains ``{"drop":"Course dropped"}``.
If the student-course pair cannot be found, you get ``422 Unprocessable Entity``


## View Courses of a Student

You can get a list of ``course_id``s of a given student using a GET request.  


```GET /student_signups?snum=123456&api_key=asd```

where *snum* is the student number. The response is a (possibly empty) list of numbers, with a status
code ``200 OK``.

## Check if a teacher id is valid
Given a teacher id, check if a teacher with such an id really exists. If it does, return their basic info (and
status code `302 Found`. If not, respond
with `{not_found: "Teacher with given number not found."}`, and code `404 Not Found`.

``GET /check_teacher?api_key=asd&tnum=123456``

## Log in teacher using JSON
Check if an email address and password are correct. Send a request:

``POST /teachers/login_teacher``

with request body:

```
{
    "api_key":"asd",
    "email":"",
    "password":""
}
```

If the email/password combination is correct, returns the code `200 OK` and the teacher 
object in the body. If incorrect, it returns `403 Forbidden` with an error message in the body. 

## Courses
Courses can be accessed in JSON format on  `/courses.json` and `/courses/1.json` 
# Notes

* If your Subsystem requires access to any other information, please contact me, and I'll add an endpoint.
* The API key is not actually `asd`. Please contact me to get your key.
* The project is under intensive development, any features may change without notice. This document may be outdated.
Feel free to leave a message if you find any inconsistencies.