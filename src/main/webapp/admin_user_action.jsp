<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String userIdStr = request.getParameter("userId");
    String action = request.getParameter("action");
    int userId = -1;
    boolean success = false;
    String message = "";

    if (userIdStr != null && !userIdStr.isEmpty() && action != null) {
        try {
            userId = Integer.parseInt(userIdStr);
            try (Connection conn = JDBCUtil.getConnection()) {
                PreparedStatement ps = null;
                if ("enable".equals(action)) {
                    // 启用用户
                    ps = conn.prepareStatement("UPDATE user SET status = 1 WHERE id = ?");
                    ps.setInt(1, userId);
                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        success = true;
                        message = "用户启用成功！";
                    } else {
                        message = "用户启用失败，用户ID不存在。";
                    }
                } else if ("disable".equals(action)) {
                    // 禁用用户
                    ps = conn.prepareStatement("UPDATE user SET status = 0 WHERE id = ?");
                    ps.setInt(1, userId);
                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        success = true;
                        message = "用户禁用成功！";
                    } else {
                        message = "用户禁用失败，用户ID不存在。";
                    }
                } else if ("role".equals(action)) {
                    // 修改权限 (这里只是一个示例，实际修改权限可能需要更复杂的逻辑，比如弹出模态框选择角色)
                    // 假设这里只是一个占位符，实际应用中需要根据需求实现
                    message = "修改权限功能待实现。用户ID: " + userId;
                    // 实际修改权限的SQL语句可能类似: UPDATE user SET role = ? WHERE id = ?
                    // ps = conn.prepareStatement("UPDATE user SET role = ? WHERE id = ?");
                    // ps.setString(1, "新的角色"); // 例如 "admin", "user"
                    // ps.setInt(2, userId);
                    // int rowsAffected = ps.executeUpdate();
                    // if (rowsAffected > 0) {
                    //     success = true;
                    //     message = "用户权限修改成功！";
                    // } else {
                    //     message = "用户权限修改失败。";
                    // }
                } else {
                    message = "未知操作。";
                }

                if (ps != null) {
                    ps.close();
                }

            } catch (SQLException e) {
                e.printStackTrace();
                message = "数据库操作失败：" + e.getMessage();
            }
        } catch (NumberFormatException e) {
            message = "无效的用户ID。";
        }
    } else {
        message = "缺少用户ID或操作参数。";
    }

    // 操作完成后重定向回用户管理页面，并可以带上操作结果消息
    // 为了简单，这里直接重定向，实际可以考虑将消息存入session或request attribute并在目标页面显示
    response.sendRedirect("admin_user_manage.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>