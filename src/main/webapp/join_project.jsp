<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int projectId = Integer.parseInt(request.getParameter("project_id"));
    String joinMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = JDBCUtil.getConnection();

        ps = conn.prepareStatement("INSERT INTO signup (user_id, project_id, signup_time, completed) VALUES ((SELECT id FROM user WHERE username=?), ?, NOW(), FALSE)");
        ps.setString(1, username);
        ps.setInt(2, projectId);
        ps.executeUpdate();
        joinMsg = "成功加入活动！";
    } catch (SQLException e) {
        e.printStackTrace();
        joinMsg = "加入活动失败：" + e.getMessage();
    } finally {
        try {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    response.sendRedirect("project_list.jsp?joinMsg=" + java.net.URLEncoder.encode(joinMsg, "UTF-8"));
%>