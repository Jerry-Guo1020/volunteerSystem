<%
    // 获取当前 session
    // HttpSession session = request.getSession(false); // false 表示如果 session 不存在则不创建
    // 直接使用隐式对象 session

    // 如果 session 存在，则移除管理员相关的属性
    if (session != null) {
        session.removeAttribute("adminUsername"); // 移除存储管理员用户名的 session 属性
        // 如果还有其他管理员相关的 session 属性，也在这里移除
        // session.removeAttribute("anotherAdminAttribute");

        // 可选：使整个 session 失效
        // session.invalidate();
    }

    // 重定向到网站首页
    response.sendRedirect("index.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>退出登录</title>
</head>
<body>
    <!-- 这个页面主要通过后端代码进行重定向，页面内容通常不会显示 -->
    <p>正在退出登录...</p>
</body>
</html>