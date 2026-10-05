<%@ page language="java"
    contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page isELIgnored="false"%>
<!doctype html>
<html lang="en">

<head>

    <meta charset="utf-8">

    <meta name="viewport"
        content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <title>User Registration</title>

    <style>

        body {
            margin: 0;
            padding: 0;

            min-height: 100vh;

            display: flex;
            justify-content: center;
            align-items: center;

            /* Monochrome background image */
            background:
                linear-gradient(
                    rgba(0, 0, 0, 0.70),
                    rgba(0, 0, 0, 0.70)
                ),
                url("https://images.unsplash.com/photo-1516321318423-f06f85e504b3");

            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;

            font-family: Arial, sans-serif;
        }

        /* Registration Card */
        .register-card {

            width: 100%;
            max-width: 450px;

            background: rgba(255, 255, 255, 0.95);

            padding: 35px;

            border-radius: 15px;

            box-shadow:
                0 10px 30px rgba(0, 0, 0, 0.40);
        }

        /* Heading */
        .register-card h2 {

            text-align: center;

            margin-bottom: 30px;

            font-weight: bold;

            color: #222;
        }

        /* Labels */
        .form-label {

            font-weight: 600;

            color: #333;
        }

        /* Input fields */
        .form-control {

            height: 45px;

            border-radius: 8px;
        }

        .form-control:focus {

            box-shadow: none;

            border-color: #333;
        }

        /* Register Button */
        .register-btn {

            width: 100%;

            height: 45px;

            margin-top: 10px;

            background-color: #212529;

            border: none;

            border-radius: 8px;

            color: white;

            font-size: 16px;

            font-weight: 600;
        }

        .register-btn:hover {

            background-color: #000;

            color: white;
        }

        /* Small text */
        .form-text {

            color: #777;
        }

    </style>

</head>


<body>

    <div class="register-card">

       <h1 style="text-align: center">${pageheader }</h1>
       <p  style="text-align: center">${page }</p>

        <form action="printDetail" method="post">

            <!-- Email -->
            <div class="mb-3">

                <label for="email" class="form-label">
                    Email Address
                </label>

                <input
                    type="email"
                    class="form-control"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    required>

                <div class="form-text">
                    We will never share your email with anyone else.
                </div>

            </div>


            <!-- Username -->
            <div class="mb-3">

                <label for="username" class="form-label">
                    Username
                </label>

                <input
                    type="text"
                    class="form-control"
                    id="username"
                    name="username"
                    placeholder="Enter your username"
                    required>
                    
                    <div class="form-text">
                     Select some Unique name 
                </div>

            </div>


            <!-- Password -->
            <div class="mb-3">

                <label for="password" class="form-label">
                    Password
                </label>

                <input
                    type="password"
                    class="form-control"
                    id="password"
                    name="password"
                    placeholder="Enter your password"
                    required>
                    
                      <div class="form-text">
                     Select some Unique password with combination of multiple letters  
                </div>

            </div>


            <!-- Register Button -->
            <button
                type="submit"
                class="register-btn">

                Register

            </button>

        </form>

    </div>


    <!-- Bootstrap JavaScript -->
    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js">
    </script>

</body>

</html>
