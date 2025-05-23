<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 清除会话
    session.invalidate();
    // 重定向到首页
    response.sendRedirect("index.jsp");
%>