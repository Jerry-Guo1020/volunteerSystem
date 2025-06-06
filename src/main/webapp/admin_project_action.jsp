<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    String projectIdStr = request.getParameter("projectId");
    String action = request.getParameter("action");
    int projectId = -1;
    boolean success = false;
    String message = "";

    if (projectIdStr != null && !projectIdStr.isEmpty() && action != null) {
        try {
            projectId = Integer.parseInt(projectIdStr);
            try (Connection conn = JDBCUtil.getConnection()) {
                PreparedStatement ps = null;
                int rowsAffected = 0;

                if ("approve".equals(action)) {
                    // 审批活动
                    ps = conn.prepareStatement("UPDATE project SET status = 1 WHERE id = ?");
                    ps.setInt(1, projectId);
                    rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        success = true;
                        message = "活动审批成功！";
                    } else {
                        message = "活动审批失败，活动ID不存在或已审批。";
                    }
                } else if ("edit".equals(action)) {
                    // 修改活动 (这里只是一个示例，实际修改需要获取更多参数并构建UPDATE语句)
                    // 你可能需要跳转到一个编辑页面，或者使用模态框进行编辑
                    message = "修改活动功能待实现。活动ID: " + projectId;
                    // 实际修改活动的SQL语句类似: UPDATE project SET name=?, description=?, ... WHERE id = ?
                    // ps = conn.prepareStatement("UPDATE project SET name=?, description=?, points=? WHERE id = ?");
                    // ps.setString(1, request.getParameter("newName"));
                    // ps.setString(2, request.getParameter("newDescription"));
                    // ps.setInt(3, Integer.parseInt(request.getParameter("newPoints")));
                    // ps.setInt(4, projectId);
                    // rowsAffected = ps.executeUpdate();
                    // if (rowsAffected > 0) {
                    //     success = true;
                    //     message = "活动修改成功！";
                    // } else {
                    //     message = "活动修改失败。";
                    // }

                } else if ("delete".equals(action)) {
                    // 删除活动
                    ps = conn.prepareStatement("DELETE FROM project WHERE id = ?");
                    ps.setInt(1, projectId);
                    rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
                        success = true;
                        message = "活动删除成功！";
                    } else {
                        message = "活动删除失败，活动ID不存在。";
                    }
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
            message = "无效的活动ID。";
        }
    } else {
        message = "缺少活动ID或操作参数。";
    }

    // 操作完成后重定向回活动管理页面
    response.sendRedirect("admin_project_manage.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>