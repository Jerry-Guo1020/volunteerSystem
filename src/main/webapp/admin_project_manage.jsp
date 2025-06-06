<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.example.volunteersystem.JDBCUtil" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");
    if (adminUsername == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    List<Map<String, Object>> projects = new ArrayList<>();
    try (Connection conn = JDBCUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT id, name, description, points, publisher, status FROM project ORDER BY id DESC")) {
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> project = new HashMap<>();
                project.put("id", rs.getInt("id"));
                project.put("name", rs.getString("name"));
                project.put("description", rs.getString("description"));
                project.put("points", rs.getInt("points"));
                project.put("publisher", rs.getString("publisher"));
                project.put("status", rs.getInt("status"));
                projects.add(project);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>活动管理 - 管理员后台</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            padding: 35px 30px;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 25px;
            text-align: center;
        }
        .table thead {
            background: linear-gradient(45deg, #fffde4 0%, #ffe9c7 100%);
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        .action-btn {
            border-radius: 20px;
            padding: 3px 18px;
            font-size: 0.95rem;
        }
        .action-btn.approve {
            background: linear-gradient(45deg, #4caf50, #43a047);
            color: #fff;
            border: none;
        }
        .action-btn.edit {
            background: linear-gradient(45deg, #ff9800, #ffc107);
            color: #fff;
            border: none;
        }
        .action-btn.delete {
            background: linear-gradient(45deg, #f44336, #e53935);
            color: #fff;
            border: none;
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="section-title">
        <i class="fas fa-tasks me-2"></i>活动管理
    </div>
    <div class="mb-3 text-end">
        <!-- 创建活动按钮，点击弹窗 -->
        <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#createProjectModal">
            <i class="fas fa-plus me-1"></i>创建活动
        </button>
    </div>
    <!-- 创建活动弹窗 -->
    <div class="modal fade" id="createProjectModal" tabindex="-1" aria-labelledby="createProjectModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form class="modal-content" action="admin_project_create.jsp" method="post">
          <div class="modal-header">
            <h5 class="modal-title" id="createProjectModalLabel">创建新活动</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">活动主题</label>
              <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
              <label class="form-label">活动描述</label>
              <textarea class="form-control" name="description" rows="3" required></textarea>
            </div>
            <div class="mb-3">
              <label class="form-label">活动积分</label>
              <input type="number" class="form-control" name="points" min="0" required>
            </div>
            <div class="mb-3">
              <label class="form-label">活动组织</label>
              <input type="text" class="form-control" name="publisher" required>
            </div>
            <div class="mb-3">
              <label class="form-label">开始时间</label>
              <input type="datetime-local" class="form-control" name="start_time" required>
            </div>
            <div class="mb-3">
              <label class="form-label">结束时间</label>
              <input type="datetime-local" class="form-control" name="end_time" required>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            <button type="submit" class="btn btn-warning">创建</button>
          </div>
        </form>
      </div>
    </div>
    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>ID</th>
                <th>名称</th>
                <th>描述</th>
                <th>积分</th>
                <th>发布者</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
        <% for (Map<String, Object> project : projects) { %>
            <tr>
                <td><%= project.get("id") %></td>
                <td><%= project.get("name") %></td>
                <td><%= project.get("description") %></td>
                <td><%= project.get("points") %></td>
                <td><%= project.get("publisher") %></td>
                <td>
                    <% if ((int)project.get("status") == 1) { %>
                        <span class="badge bg-success">已审批</span>
                    <% } else { %>
                        <span class="badge bg-warning text-dark">待审批</span>
                    <% } %>
                </td>
                <td>
                    <form action="admin_project_action.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="projectId" value="<%= project.get("id") %>">
                        <% if ((int)project.get("status") == 0) { %>
                            <button name="action" value="approve" class="action-btn approve" type="submit">审批</button>
                        <% } %>
                        <button name="action" value="edit" class="action-btn edit" type="submit">修改</button>
                        <button name="action" value="delete" class="action-btn delete" type="submit" onclick="return confirm('确定要删除该活动吗？')">删除</button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <div class="text-center mt-4">
        <a href="admin_dashboard.jsp" class="btn btn-outline-warning"><i class="fas fa-arrow-left me-1"></i>返回后台首页</a>
    </div>
</div>
</body>
</html>