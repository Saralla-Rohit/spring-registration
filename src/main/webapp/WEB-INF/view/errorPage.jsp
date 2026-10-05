<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Failed</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding-top: 100px;
        }

        .error-box {
            width: 500px;
            margin: auto;
            padding: 30px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }

        h1 {
            color: #d32f2f;
        }

        p {
            font-size: 18px;
            color: #555;
        }

        .message {
            margin-top: 20px;
            padding: 15px;
            background-color: #ffebee;
            color: #c62828;
            border-radius: 5px;
        }
    </style>
</head>

<body>

    <div class="error-box">

         <h1 style="text-align: center">${msg }</h1>
        <h1>Registration Failed</h1>
         

        <p>
            We regret to inform you that your registration could not be completed.
        </p>

        <div class="message">
            Please check the entered details and try again.
        </div>

    </div>

</body>
</html>
```