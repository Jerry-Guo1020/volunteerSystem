package com.example.volunteersystem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // 导入 SQLException 类
import java.util.ArrayList; // 导入 ArrayList 类
import java.util.List; // 导入 List 类

@WebServlet("/admin_project_action") // 将 JSP 中的 action 改为这个 URL
public class AdminProjectActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        String projectIdStr = request.getParameter("projectId");
        int projectId = -1;

        if (projectIdStr != null && !projectIdStr.isEmpty()) {
            try {
                projectId = Integer.parseInt(projectIdStr);
            } catch (NumberFormatException e) {
                // Handle error: invalid project ID
                response.sendRedirect("admin_project_manage.jsp?error=Invalid project ID");
                return;
            }
        } else {
            // Handle error: project ID is missing
            response.sendRedirect("admin_project_manage.jsp?error=Project ID missing");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = JDBCUtil.getConnection();
            conn.setAutoCommit(false); // 开始事务

            if ("approve".equals(action)) {
                // 审批项目
                ps = conn.prepareStatement("UPDATE project SET status = 1 WHERE id = ?");
                ps.setInt(1, projectId);
                ps.executeUpdate();
                conn.commit(); // 提交事务
                response.sendRedirect("admin_project_manage.jsp?message=Project approved successfully");

            } else if ("delete".equals(action)) {
                // 删除项目 (由于signup表有外键关联，删除project会自动删除相关signup记录)
                ps = conn.prepareStatement("DELETE FROM project WHERE id = ?");
                ps.setInt(1, projectId);
                ps.executeUpdate();
                conn.commit(); // 提交事务
                response.sendRedirect("admin_project_manage.jsp?message=Project deleted successfully");

            } else if ("complete".equals(action)) {
                // 完结活动并添加积分
                // 1. 获取项目积分
                int points = 0;
                ps = conn.prepareStatement("SELECT points FROM project WHERE id = ?");
                ps.setInt(1, projectId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    points = rs.getInt("points");
                }
                JDBCUtil.close(null, ps, rs); // 关闭之前的ps和rs

                if (points > 0) {
                    // 2. 更新报名记录为已完成，并获取所有参与用户的ID
                    // 注意：这里假设所有报名的用户都完成了活动并获得积分。
                    // 如果需要更精细的控制（例如只有部分用户完成），则需要更复杂的逻辑，
                    // 可能需要在signup表中添加一个字段来标记用户是否实际完成。
                    // 当前实现是：只要报名了且项目被管理员标记为完结，就认为完成并给积分。
                    ps = conn.prepareStatement("UPDATE signup SET completed = TRUE WHERE project_id = ?");
                    ps.setInt(1, projectId);
                    ps.executeUpdate();
                    JDBCUtil.close(null, ps, null); // 关闭ps

                    // 3. 获取所有报名该项目的用户ID
                    List<Integer> userIds = new ArrayList<>();
                    ps = conn.prepareStatement("SELECT user_id FROM signup WHERE project_id = ?");
                    ps.setInt(1, projectId);
                    rs = ps.executeQuery();
                    while(rs.next()) {
                        userIds.add(rs.getInt("user_id"));
                    }
                    JDBCUtil.close(null, ps, rs); // 关闭ps和rs

                    // 4. 为每个用户增加积分
                    if (!userIds.isEmpty()) {
                         // 使用批量更新提高效率
                        ps = conn.prepareStatement("UPDATE user SET points = points + ? WHERE id = ?");
                        for (Integer userId : userIds) {
                            ps.setInt(1, points);
                            ps.setInt(2, userId);
                            ps.addBatch(); // 添加到批量处理
                        }
                        ps.executeBatch(); // 执行批量更新
                    }
                    JDBCUtil.close(null, ps, null); // 关闭ps
                }

                // 5. 更新项目状态为已完结 (例如状态 2)
                ps = conn.prepareStatement("UPDATE project SET status = 2 WHERE id = ?");
                ps.setInt(1, projectId);
                ps.executeUpdate();

                conn.commit(); // 提交事务
                response.sendRedirect("admin_project_manage.jsp?message=Project completed and points awarded");

            } else {
                // Handle error: unknown action
                response.sendRedirect("admin_project_manage.jsp?error=Unknown action");
            }

        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback(); // 回滚事务
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace(); // Log the error
            response.sendRedirect("admin_project_manage.jsp?error=Database error: " + e.getMessage());

        } finally {
            JDBCUtil.close(conn, ps, rs);
        }
    }
}