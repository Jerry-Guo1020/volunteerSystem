<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,com.example.volunteersystem.JDBCUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int itemId = Integer.parseInt(request.getParameter("item_id"));
    int pointsCost = Integer.parseInt(request.getParameter("points_cost"));
    String redeemMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = JDBCUtil.getConnection();

        ps = conn.prepareStatement("SELECT points FROM user WHERE username=?");
        ps.setString(1, username);
        rs = ps.executeQuery();
        if (rs.next()) {
            int userPoints = rs.getInt("points");
            if (userPoints >= pointsCost) {
                ps.close();
                ps = conn.prepareStatement("UPDATE user SET points=points-? WHERE username=?");
                ps.setInt(1, pointsCost);
                ps.setString(2, username);
                ps.executeUpdate();
                redeemMsg = "兑换成功！";
            } else {
                redeemMsg = "积分不足，无法兑换。";
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        redeemMsg = "兑换失败：" + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    response.sendRedirect("points_mall.jsp?redeemMsg=" + java.net.URLEncoder.encode(redeemMsg, "UTF-8"));
%>