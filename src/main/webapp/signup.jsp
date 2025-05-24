<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户注册</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">用户注册</h2>

    <%-- 显示来自 Servlet 的消息 --%>
    <%
        String message = (String) request.getAttribute("message");
        if (message != null && !message.isEmpty()) {
    %>
        <div class="alert alert-danger" role="alert">
            <%= message %>
        </div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/signup-servlet" method="post" class="bg-white p-4 rounded shadow-sm">
        <div class="mb-3">
            <label for="username" class="form-label">用户名</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">密码</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
         <div class="mb-3">
            <label for="confirm_password" class="form-label">确认密码</label>
            <input type="password" class="form-control" id="confirm_password" name="confirm_password" required>
        </div>
        <button type="submit" class="btn btn-primary">注册</button>
        <a href="login.jsp" class="btn btn-secondary ms-2">已有账号？去登录</a>
    </form>
</div>
</body>
</html>