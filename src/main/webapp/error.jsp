<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>错误页面</title>
    <link rel="icon" href="image/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<jsp:include page="common/navbar.jsp" />
<div class="container mt-5">
    <div class="alert alert-danger">
        <h4>发生错误</h4>
        <p>抱歉，系统遇到了一个问题。</p>
        <% if(exception != null) { %>
        <p>错误信息: <%= exception.getMessage() %></p>
        <% } %>
        <a href="index.jsp" class="btn btn-primary mt-3">返回首页</a>
    </div>
</div>
</body>
</html>