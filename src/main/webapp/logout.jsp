<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 清除会话
    session.invalidate();
    // 不再直接重定向，而是显示一个页面
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>退出登录</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden; /* Prevent scrollbar during transition */
        }

        .logout-popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black overlay */
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050; /* Above Bootstrap modals */
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .logout-popup-overlay.show {
            opacity: 1;
            visibility: visible;
        }

        .logout-popup-content {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            transform: scale(0.9);
            transition: transform 0.3s ease;
        }

         .logout-popup-overlay.show .logout-popup-content {
             transform: scale(1);
         }

        .logout-popup-content i {
            font-size: 3rem;
            color: #28a745; /* Bootstrap success color */
            margin-bottom: 15px;
        }

        .logout-popup-content h2 {
            font-size: 1.8rem;
            margin-bottom: 10px;
            color: #343a40;
        }

        .logout-popup-content p {
            font-size: 1.1rem;
            color: #6c757d;
            margin-bottom: 20px;
        }

        .timer {
            font-size: 1rem;
            color: #0d6efd; /* Bootstrap primary color */
            font-weight: bold;
        }
    </style>
</head>
<body>

<div id="logoutPopupOverlay" class="logout-popup-overlay">
    <div class="logout-popup-content">
        <i class="fas fa-check-circle"></i>
        <h2>您已成功退出登录</h2>
        <p>感谢您的使用！</p>
        <div class="timer">页面将在 <span id="countdown">3</span> 秒后自动跳转...</div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const overlay = document.getElementById('logoutPopupOverlay');
        const countdownSpan = document.getElementById('countdown');
        let countdown = 3;

        // Show the popup
        overlay.classList.add('show');

        // Update the timer
        const timerInterval = setInterval(function() {
            countdown--;
            countdownSpan.textContent = countdown;

            if (countdown <= 0) {
                clearInterval(timerInterval);
                // Redirect to the homepage after the timer
                window.location.href = 'index.jsp';
            }
        }, 1000); // Update every 1 second
    });
</script>

</body>
</html>