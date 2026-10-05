```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Data Inserted Successfully</title>

    <!-- Bootstrap CSS -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

    <!-- Background -->
    <div class="min-vh-100 d-flex justify-content-center align-items-center"
         style="
            background-image:
            linear-gradient(rgba(0,0,0,0.65), rgba(0,0,0,0.65)),
            url('https://images.unsplash.com/photo-1558494949-ef010cbdcc31');
            background-size: cover;
            background-position: center;
         ">

        <!-- Success Card -->
        <div class="card shadow-lg text-center"
             style="width: 500px;">

            <div class="card-body p-5">

                <!-- Success Icon -->
                <div class="bg-success text-white rounded-circle
                            d-flex justify-content-center align-items-center
                            mx-auto mb-4"
                     style="width: 80px; height: 80px;">

                    <span class="fs-1">✓</span>

                </div>

                <!-- Heading -->
                <h1 class="text-success fw-bold mb-3">
                    Data Inserted Successfully!
                </h1>

                <!-- Main Message -->
                <p class="fs-5 text-dark">
                    Your data has been successfully inserted
                    into the database.
                </p>

                <!-- Configuration Message -->
                <p class="text-secondary mb-4">
                    Database configuration and connection
                    are working correctly.
                </p>

                <!-- Back Button -->
                <a href="registration"
                   class="btn btn-primary px-4 py-2">

                    Back

                </a>

            </div>

        </div>

    </div>

    <!-- Bootstrap JavaScript -->
    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>

</body>
</html>
```