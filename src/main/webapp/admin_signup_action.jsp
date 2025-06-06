<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String signupIdStr = request.getParameter("signupId");
    String username = request.getParameter("username");
    String pointsStr = request.getParameter("points");
    String action = request.getParameter("action");
    String message = "";

    if ("finish".equals(action) && signupIdStr != null && pointsStr != null) {
        try (Connection conn = JDBCUtil.getConnection()) {
            int signupId = Integer.parseInt(signupIdStr);
            int points = Integer.parseInt(pointsStr);

            // 1. 更新报名状态为已完成
            PreparedStatement ps1 = conn.prepareStatement("UPDATE signup SET status=1 WHERE id=?");
            ps1.setInt(1, signupId);
            int updated = ps1.executeUpdate();

            // 2. 给用户加积分
            if (updated > 0) {
                PreparedStatement ps2 = conn.prepareStatement("UPDATE user SET points = points + ? WHERE username=?");
                ps2.setInt(1, points);
                ps2.setString(2, username);
                ps2.executeUpdate();
                ps2.close();
                message = "操作成功，用户积分已增加！";
            } else {
                message = "操作失败，报名记录不存在。";
            }
            ps1.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "操作异常：" + e.getMessage();
        }
    } else {
        message = "参数错误。";
    }
    response.sendRedirect("admin_signup_manage.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>