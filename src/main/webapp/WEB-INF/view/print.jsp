```jsp
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="ISO-8859-1">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Registration Successful</title>

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	padding: 0;
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	font-family: Arial, Helvetica, sans-serif;
	/*
             * Monochrome background image
             * Dark overlay is added for better readability.
             */
	background: linear-gradient(rgba(0, 0, 0, 0.75), rgba(0, 0, 0, 0.75)),
		url("https://images.unsplash.com/photo-1516321318423-f06f85e504b3");
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
}

/* Main Result Card */
.result-card {
	width: 90%;
	max-width: 550px;
	background: rgba(255, 255, 255, 0.96);
	padding: 40px;
	border-radius: 18px;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.45);
}

/* Success Icon */
.success-icon {
	width: 70px;
	height: 70px;
	margin: 0 auto 20px;
	display: flex;
	justify-content: center;
	align-items: center;
	border-radius: 50%;
	background-color: #212529;
	color: white;
	font-size: 35px;
	font-weight: bold;
}

/* Heading */
h1 {
	text-align: center;
	margin-bottom: 8px;
	color: #212529;
	font-size: 28px;
}

.subtitle {
	text-align: center;
	color: #777;
	margin-bottom: 30px;
}

/* User Details */
.details-box {
	border: 1px solid #ddd;
	border-radius: 12px;
	overflow: hidden;
	margin-bottom: 25px;
}

.detail-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px 18px;
	border-bottom: 1px solid #eee;
}

.detail-row:last-child {
	border-bottom: none;
}

.detail-label {
	font-weight: bold;
	color: #555;
}

.detail-value {
	color: #212529;
	font-weight: 500;
	word-break: break-word;
}

/* Button */
.btn {
	display: block;
	width: 100%;
	padding: 13px;
	background-color: #212529;
	color: white;
	text-decoration: none;
	text-align: center;
	border-radius: 8px;
	font-size: 16px;
	font-weight: bold;
	transition: 0.3s;
}

.btn:hover {
	background-color: #000;
	color: white;
}

/* Footer */
.footer-text {
	text-align: center;
	margin-top: 20px;
	font-size: 13px;
	color: #888;
}

/* Responsive Design */
@media ( max-width : 500px) {
	.result-card {
		padding: 25px;
	}
	h1 {
		font-size: 24px;
	}
	.detail-row {
		flex-direction: column;
		align-items: flex-start;
		gap: 5px;
	}
}
</style>

</head>


<body>


	<div class="result-card">


		<!-- Success Icon -->

		<div class="success-icon">&#10003;</div>


		<h1 style="text-align: center">${pageheader}</h1>

		<p style="text-align: center">${page}</p>


		<!-- Heading -->

		<h1>Registration Successful</h1>

		<p class="subtitle">Your registration details have been received
			successfully.</p>


		<!-- User Details -->

		<div class="details-box">


			<!--

                detail is the List stored in the Model.

                registration represents one object from that List.
            -->

			<c:forEach var="registration" items="${data}">


				<!-- Email -->

				<div class="detail-row">

					<span class="detail-label"> Email </span> <span
						class="detail-value"> ${registration.email} </span>

				</div>


				<!-- Username -->

				<div class="detail-row">

					<span class="detail-label"> Username </span> <span
						class="detail-value"> ${registration.username} </span>

				</div>


				<!-- Password -->

				<div class="detail-row">

					<span class="detail-label"> Password </span> <span
						class="detail-value"> ${registration.password} </span>

				</div>


			</c:forEach>


		</div>


		<!-- Back / Continue Button -->

		<a href="#" class="btn"> Continue </a>


		<div class="footer-text">Thank you for registering with us.</div>


	</div>


</body>

</html>
```
