package com.example.volunteersystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement; // 导入 PreparedStatement
import java.sql.ResultSet; // 导入 ResultSet
import java.sql.SQLException; // 导入 SQLException

public class JDBCUtil {
    // 请根据你的实际数据库配置修改以下信息
    private static final String URL = "jdbc:mysql://localhost:3306/volunteer_platform?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai"; // 数据库URL
    private static final String USER = "root"; // 您的实际数据库用户名
    private static final String PASSWORD = "jerryguo1020@@"; // 您的实际数据库密码

    static {
        try {
            // 加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("数据库驱动加载失败！请检查是否已添加MySQL Connector/J依赖。");
        }
    }

    /**
     * 获取数据库连接
     * @return 数据库连接对象
     * @throws SQLException 如果获取连接失败
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * 关闭数据库连接、Statement和ResultSet
     * @param conn Connection对象
     * @param ps PreparedStatement对象
     * @param rs ResultSet对象
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 关闭数据库连接和Statement
     * @param conn Connection对象
     * @param ps PreparedStatement对象
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null); // 调用上面的重载方法
    }

    /**
     * 关闭数据库连接
     * @param conn Connection对象
     */
    public static void close(Connection conn) {
        close(conn, null, null); // 调用上面的重载方法
    }
}
