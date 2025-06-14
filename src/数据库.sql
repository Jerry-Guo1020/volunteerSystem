#
# USE volunteer_platform;
#
# -- 创建用户表 user
# -- 存储用户信息，包括用户名、密码和积分
# CREATE TABLE IF NOT EXISTS user (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     username VARCHAR(50) NOT NULL UNIQUE,
#     password VARCHAR(255) NOT NULL,
#     email VARCHAR(100) NOT NULL,
#     reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
#     points INT DEFAULT 0
# );
#
#
# -- 创建志愿项目表 (project)
# -- 存储志愿项目的详细信息
# CREATE TABLE IF NOT EXISTS project (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     name VARCHAR(255) NOT NULL,
#     description TEXT,
#     points INT DEFAULT 0,
#     -- 完成项目获得的积分
#     publisher VARCHAR(100),
#     -- 发布组织或个人
#     start_time DATETIME,
#     -- 项目开始时间
#     end_time DATETIME,
#     -- 项目结束时间
#     category VARCHAR(50) -- 项目类别 (例如：环保, 教育, 社区服务)
#
# );
#
#
# -- 创建报名记录表 (signup)
# -- 存储用户报名参加项目的记录，以及完成状态
# CREATE TABLE IF NOT EXISTS signup (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     user_id INT,
#     -- 报名用户ID，外键关联user表
#     project_id INT,
#     -- 报名项目ID，外键关联project表
#     signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
#     -- 报名时间
#     completed BOOLEAN DEFAULT FALSE,
#     -- 项目是否完成
#     -- 添加外键约束
#     FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
#     FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
#     -- 确保同一个用户不会重复报名同一个项目
#     UNIQUE (user_id, project_id)
# );
# -- 创建积分商城商品表 (mall_items)
# -- 存储积分商城中可兑换的商品信息
# CREATE TABLE IF NOT EXISTS mall_items (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     name VARCHAR(255) NOT NULL,
#     description TEXT,
#     points_cost INT NOT NULL,
#     -- 兑换所需积分
#     image_url VARCHAR(255),
#     -- 商品图片URL
#     is_featured BOOLEAN DEFAULT FALSE -- 是否是精选商品
# );
# -- 创建积分兑换记录表 (redemption_records)
# -- 存储用户兑换商品的记录 (可选，但推荐用于追踪)
# CREATE TABLE IF NOT EXISTS redemption_records (
#     id INT AUTO_INCREMENT PRIMARY KEY,
#     user_id INT,
#     -- 兑换用户ID，外键关联user表
#     item_id INT,
#     -- 兑换商品ID，外键关联mall_items表
#     points_used INT NOT NULL,
#     -- 兑换使用的积分
#     redemption_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
#     -- 兑换时间
#     -- 添加外键约束
#     FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
#     FOREIGN KEY (item_id) REFERENCES mall_items(id) ON DELETE CASCADE
# );
#
# CREATE TABLE messages (
#                           id INT AUTO_INCREMENT PRIMARY KEY,
#                           sender VARCHAR(255) NOT NULL,
#                           recipient VARCHAR(255) NOT NULL,
#                           content TEXT NOT NULL,
#                           send_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
# );
#
# -- 添加更多生活用品示例数据
# INSERT INTO mall_items (
#         name,
#         description,
#         points_cost,
#         image_url,
#         is_featured
#     )
# VALUES (
#         '精美笔记本',
#         '记录生活点滴，学习工作好帮手。',
#         180,
#         'https://via.placeholder.com/150x150?text=Notebook',
#         FALSE
#     ),
#     (
#         '便携水杯',
#         '健康饮水，随身携带。',
#         220,
#         'https://via.placeholder.com/150x150?text=Water+Bottle',
#         FALSE
#     ),
#     (
#         '创意书签',
#         '让阅读更有趣。',
#         80,
#         'https://via.placeholder.com/150x150?text=Bookmark',
#         FALSE
#     ),
#     (
#         '多功能笔',
#         '一支笔满足多种书写需求。',
#         120,
#         'https://via.placeholder.com/150x150?text=Pen',
#         FALSE
#     ),
#     (
#         '迷你手电筒',
#         '小巧实用，应急照明。',
#         150,
#         'https://via.placeholder.com/150x150?text=Flashlight',
#         FALSE
#     ),
#     (
#         '卡通钥匙扣',
#         '可爱造型，装饰你的钥匙。',
#         50,
#         'https://via.placeholder.com/150x150?text=Keychain',
#         FALSE
#     ),
#     (
#         '手机支架',
#         '解放双手，追剧更轻松。',
#         100,
#         'https://via.placeholder.com/150x150?text=Phone+Stand',
#         FALSE
#     ),
#     (
#         '数据线收纳器',
#         '告别杂乱，保持桌面整洁。',
#         70,
#         'https://via.placeholder.com/150x150?text=Cable+Organizer',
#         FALSE
#     );
#
#     INSERT INTO project (id, name, description, points, publisher, start_time, end_time) VALUES
#     (1, '社区清洁活动', '参与社区清洁，提升环境卫生。', 50, '社区中心', '2023-11-01 09:00:00', '2023-11-01 12:00:00'),
#     (2, '图书馆志愿者', '协助图书馆整理书籍和管理借阅。', 30, '市图书馆', '2023-11-05 10:00:00', '2023-11-05 16:00:00'),
#     (3, '老人院探访', '陪伴老人，提供关怀和帮助。', 40, '志愿者协会', '2023-11-10 14:00:00', '2023-11-10 17:00:00'),
#     (4, '植树活动', '参与植树活动，绿化环境。', 60, '环保组织', '2023-11-15 08:00:00', '2023-11-15 11:00:00'),
#     (5, '动物收容所志愿者', '帮助照顾动物，维护收容所环境。', 45, '动物保护协会', '2023-11-20 09:00:00', '2023-11-20 13:00:00');
#
# INSERT INTO messages (sender, recipient, content) VALUES
# ('admin', 'user1', '欢迎来到志愿者服务平台！'),
# ('user2', 'admin', '感谢您的帮助！'),
# ('admin', 'user3', '新的活动已经发布，欢迎参与！');
#
# CREATE TABLE admin (
#     id INT PRIMARY KEY AUTO_INCREMENT,
#     username VARCHAR(50) NOT NULL UNIQUE,
#     password VARCHAR(100) NOT NULL,
#     realname VARCHAR(50) NOT NULL
# );
#


-- 删除数据库（如果存在）
DROP DATABASE IF EXISTS volunteer_platform;

-- 创建数据库
CREATE DATABASE volunteer_platform;

-- 使用数据库
USE volunteer_platform;

-- 创建用户表 user
-- 存储用户信息，包括用户名、密码、真实姓名、角色、状态和积分
CREATE TABLE IF NOT EXISTS user (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    username VARCHAR(50) NOT NULL UNIQUE,
                                    password VARCHAR(255) NOT NULL,
                                    realname VARCHAR(50), -- 添加真实姓名列
                                    email VARCHAR(100) NOT NULL,
                                    reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    points INT DEFAULT 0,
                                    role VARCHAR(20) DEFAULT 'user', -- 添加角色列, 默认为普通用户
                                    status INT DEFAULT 1 -- 添加状态列, 默认为1 (启用)
);


-- 创建志愿项目表 (project)
-- 存储志愿项目的详细信息
CREATE TABLE IF NOT EXISTS project (
                                       id INT AUTO_INCREMENT PRIMARY KEY,
                                       name VARCHAR(255) NOT NULL,
                                       description TEXT,
                                       points INT DEFAULT 0,
    -- 完成项目获得的积分
                                       publisher VARCHAR(100),
    -- 发布组织或个人
                                       start_time DATETIME,
    -- 项目开始时间
                                       end_time DATETIME,
                                       category VARCHAR(50), -- 项目类别 (例如：环保, 教育, 社区服务)
                                       status INT DEFAULT 0, -- 项目状态 (例如：0-待审批, 1-已审批)
                                       duration_hours DOUBLE DEFAULT 0 -- 新增：活动时长（小时）
);


-- 创建报名记录表 (signup)
-- 存储用户报名参加项目的记录，以及完成状态和贡献小时数
CREATE TABLE IF NOT EXISTS signup (
                                      id INT AUTO_INCREMENT PRIMARY KEY,
                                      user_id INT,
    -- 报名用户ID，外键关联user表
                                      project_id INT,
    -- 报名项目ID，外键关联project表
                                      signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 报名时间
                                      completed BOOLEAN DEFAULT FALSE,
    -- 项目是否完成
    {{ edit_1 }}
    -- 添加外键约束
                                      FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
    -- 确保同一个用户不会重复报名同一个项目
    UNIQUE (user_id, project_id)
    );
-- 创建积分商城商品表 (mall_items)
-- 存储积分商城中可兑换的商品信息
CREATE TABLE IF NOT EXISTS mall_items (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(255) NOT NULL,
                                          description TEXT,
                                          points_cost INT NOT NULL,
    -- 兑换所需积分
                                          image_url VARCHAR(255),
    -- 商品图片URL
                                          is_featured BOOLEAN DEFAULT FALSE -- 是否是精选商品
);
-- 创建积分兑换记录表 (redemption_records)
-- 存储用户兑换商品的记录 (可选，但推荐用于追踪)
CREATE TABLE IF NOT EXISTS redemption_records (
                                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                                  user_id INT,
    -- 兑换用户ID，外键关联user表
                                                  item_id INT,
    -- 兑换商品ID，外键关联mall_items表
                                                  points_used INT NOT NULL,
    -- 兑换使用的积分
                                                  redemption_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 兑换时间
    -- 添加外键约束
                                                  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                                                  FOREIGN KEY (item_id) REFERENCES mall_items(id) ON DELETE CASCADE
);

CREATE TABLE messages (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          sender VARCHAR(255) NOT NULL,
                          recipient VARCHAR(255) NOT NULL,
                          content TEXT NOT NULL,
                          send_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建管理员表
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL,
                       realname VARCHAR(50) NOT NULL
);


-- 添加更多生活用品示例数据
INSERT INTO mall_items (
    name,
    description,
    points_cost,
    image_url,
    is_featured
)
VALUES (
           '精美笔记本',
           '记录生活点滴，学习工作好帮手。',
           180,
           '/image/notebook.jpg/',
           FALSE
       ),
       (
           '便携水杯',
           '健康饮水，随身携带。',
           220,
           '/image/water.jpg/',
           FALSE
       ),
       (
           '创意书签',
           '让阅读更有趣。',
           80,
           '/image/bookmark.jpg/',
           FALSE
       ),
       (
           '多功能笔',
           '一支笔满足多种书写需求。',
           120,
           '/image/pen.jpg/',
           FALSE
       ),
       (
           '迷你手电筒',
           '小巧实用，应急照明。',
           150,
           '/image/Flashlight.jpg/',
           FALSE
       ),
       (
           '卡通钥匙扣',
           '可爱造型，装饰你的钥匙。',
           50,
           '/image/Keychain.jpg/',
           FALSE
       ),
       (
           '手机支架',
           '解放双手，追剧更轻松。',
           100,
           '/image/111.jpg/',
           FALSE
       ),
       (
           '数据线收纳器',
           '告别杂乱，保持桌面整洁。',
           70,
           '/image/222.jpg/',
           FALSE
       );

INSERT INTO project (id, name, description, points, publisher, start_time, end_time, status) VALUES
                                                                                                 (1, '社区清洁活动', '参与社区清洁，提升环境卫生。', 50, '社区中心', '2023-11-01 09:00:00', '2023-11-01 12:00:00', 1),
                                                                                                 (2, '图书馆志愿者', '协助图书馆整理书籍和管理借阅。', 30, '市图书馆', '2023-11-05 10:00:00', '2023-11-05 16:00:00', 1),
                                                                                                 (3, '老人院探访', '陪伴老人，提供关怀和帮助。', 40, '志愿者协会', '2023-11-10 14:00:00', '2023-11-10 17:00:00', 1),
                                                                                                 (4, '植树活动', '参与植树活动，绿化环境。', 60, '环保组织', '2023-11-15 08:00:00', '2023-11-15 11:00:00', 0), -- 示例待审批项目
                                                                                                 (5, '动物收容所志愿者', '帮助照顾动物，维护收容所环境。', 45, '动物保护协会', '2023-11-20 09:00:00', '2023-11-20 13:00:00', 1);

INSERT INTO messages (sender, recipient, content) VALUES
                                                      ('admin', 'user1', '欢迎来到志愿者服务平台！'),
                                                      ('user2', 'admin', '感谢您的帮助！'),
                                                      ('admin', 'user3', '新的活动已经发布，欢迎参与！');

INSERT INTO admin (username, password, realname) VALUES
    ('admin', 'admin123', '系统管理员');



-- 删除数据库（如果存在）
DROP DATABASE IF EXISTS volunteer_platform;

-- 创建数据库
CREATE DATABASE volunteer_platform;

-- 使用数据库
USE volunteer_platform;

-- 创建用户表 user
-- 存储用户信息，包括用户名、密码、真实姓名、角色、状态和积分
CREATE TABLE IF NOT EXISTS user (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    username VARCHAR(50) NOT NULL UNIQUE,
                                    password VARCHAR(255) NOT NULL,
                                    realname VARCHAR(50), -- 添加真实姓名列
                                    email VARCHAR(100) NOT NULL,
                                    reg_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    points INT DEFAULT 0,
                                    role VARCHAR(20) DEFAULT 'user', -- 添加角色列, 默认为普通用户
                                    status INT DEFAULT 1 -- 添加状态列, 默认为1 (启用)
);


-- 创建志愿项目表 (project)
-- 存储志愿项目的详细信息
CREATE TABLE IF NOT EXISTS project (
                                       id INT AUTO_INCREMENT PRIMARY KEY,
                                       name VARCHAR(255) NOT NULL,
                                       description TEXT,
                                       points INT DEFAULT 0,
    -- 完成项目获得的积分
                                       publisher VARCHAR(100),
    -- 发布组织或个人
                                       start_time DATETIME,
    -- 项目开始时间
                                       end_time DATETIME,
                                       category VARCHAR(50), -- 项目类别 (例如：环保, 教育, 社区服务)
                                       status INT DEFAULT 0 -- 项目状态 (例如：0-待审批, 1-已审批)
);


-- 创建报名记录表 (signup)
-- 存储用户报名参加项目的记录，以及完成状态和贡献小时数
CREATE TABLE IF NOT EXISTS signup (
                                      id INT AUTO_INCREMENT PRIMARY KEY,
                                      user_id INT,
    -- 报名用户ID，外键关联user表
                                      project_id INT,
    -- 报名项目ID，外键关联project表
                                      signup_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 报名时间
                                      completed BOOLEAN DEFAULT FALSE,
    -- 项目是否完成
                                      hours INT DEFAULT 0, -- 添加贡献小时数列
    -- 添加外键约束
                                      FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                                      FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
    -- 确保同一个用户不会重复报名同一个项目
                                      UNIQUE (user_id, project_id)
);
-- 创建积分商城商品表 (mall_items)
-- 存储积分商城中可兑换的商品信息
CREATE TABLE IF NOT EXISTS mall_items (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(255) NOT NULL,
                                          description TEXT,
                                          points_cost INT NOT NULL,
    -- 兑换所需积分
                                          image_url VARCHAR(255),
    -- 商品图片URL
                                          is_featured BOOLEAN DEFAULT FALSE -- 是否是精选商品
);
-- 创建积分兑换记录表 (redemption_records)
-- 存储用户兑换商品的记录 (可选，但推荐用于追踪)
CREATE TABLE IF NOT EXISTS redemption_records (
                                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                                  user_id INT,
    -- 兑换用户ID，外键关联user表
                                                  item_id INT,
    -- 兑换商品ID，外键关联mall_items表
                                                  points_used INT NOT NULL,
    -- 兑换使用的积分
                                                  redemption_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- 兑换时间
    -- 添加外键约束
                                                  FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                                                  FOREIGN KEY (item_id) REFERENCES mall_items(id) ON DELETE CASCADE
);

CREATE TABLE messages (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          sender VARCHAR(255) NOT NULL,
                          recipient VARCHAR(255) NOT NULL,
                          content TEXT NOT NULL,
                          send_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建管理员表
CREATE TABLE admin (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL,
                       realname VARCHAR(50) NOT NULL
);


-- 添加更多生活用品示例数据
INSERT INTO mall_items (
    name,
    description,
    points_cost,
    image_url,
    is_featured
)
VALUES (
           '精美笔记本',
           '记录生活点滴，学习工作好帮手。',
           180,
           'https://via.placeholder.com/150x150?text=Notebook',
           FALSE
       ),
       (
           '便携水杯',
           '健康饮水，随身携带。',
           220,
           'https://via.placeholder.com/150x150?text=Water+Bottle',
           FALSE
       ),
       (
           '创意书签',
           '让阅读更有趣。',
           80,
           'https://via.placeholder.com/150x150?text=Bookmark',
           FALSE
       ),
       (
           '多功能笔',
           '一支笔满足多种书写需求。',
           120,
           'https://via.placeholder.com/150x150?text=Pen',
           FALSE
       ),
       (
           '迷你手电筒',
           '小巧实用，应急照明。',
           150,
           'https://via.placeholder.com/150x150?text=Flashlight',
           FALSE
       ),
       (
           '卡通钥匙扣',
           '可爱造型，装饰你的钥匙。',
           50,
           'https://via.placeholder.com/150x150?text=Keychain',
           FALSE
       ),
       (
           '手机支架',
           '解放双手，追剧更轻松。',
           100,
           'https://via.placeholder.com/150x150?text=Phone+Stand',
           FALSE
       ),
       (
           '数据线收纳器',
           '告别杂乱，保持桌面整洁。',
           70,
           'https://via.placeholder.com/150x150?text=Cable+Organizer',
           FALSE
       );

INSERT INTO project (id, name, description, points, publisher, start_time, end_time, status) VALUES
                                                                                                 (1, '社区清洁活动', '参与社区清洁，提升环境卫生。', 50, '社区中心', '2023-11-01 09:00:00', '2023-11-01 12:00:00', 1),
                                                                                                 (2, '图书馆志愿者', '协助图书馆整理书籍和管理借阅。', 30, '市图书馆', '2023-11-05 10:00:00', '2023-11-05 16:00:00', 1),
                                                                                                 (3, '老人院探访', '陪伴老人，提供关怀和帮助。', 40, '志愿者协会', '2023-11-10 14:00:00', '2023-11-10 17:00:00', 1),
                                                                                                 (4, '植树活动', '参与植树活动，绿化环境。', 60, '环保组织', '2023-11-15 08:00:00', '2023-11-15 11:00:00', 0), -- 示例待审批项目
                                                                                                 (5, '动物收容所志愿者', '帮助照顾动物，维护收容所环境。', 45, '动物保护协会', '2023-11-20 09:00:00', '2023-11-20 13:00:00', 1);

INSERT INTO messages (sender, recipient, content) VALUES
                                                      ('admin', 'user1', '欢迎来到志愿者服务平台！'),
                                                      ('user2', 'admin', '感谢您的帮助！'),
                                                      ('admin', 'user3', '新的活动已经发布，欢迎参与！');

INSERT INTO admin (username, password, realname) VALUES
    ('admin', 'admin123', '系统管理员');

-- 示例用户数据 (可选，根据需要添加)
-- INSERT INTO user (username, password, realname, email, points, role, status) VALUES
-- ('testuser1', 'password123', '测试用户一', 'test1@example.com', 100, 'user', 1),
-- ('testuser2', 'securepass', '测试用户二', 'test2@example.com', 50, 'user', 1);

-- 示例报名数据 (可选，根据需要添加)
-- INSERT INTO signup (user_id, project_id, completed, hours) VALUES
-- (1, 1, TRUE, 3), -- testuser1 报名并完成了 项目1, 贡献3小时
-- (1, 2, FALSE, 0), -- testuser1 报名了 项目2 但未完成
-- (2, 1, TRUE, 3); -- testuser2 报名并完成了 项目1, 贡献3小时

-- 示例兑换记录数据 (可选，根据需要添加)
-- INSERT INTO redemption_records (user_id, item_id, points_used) VALUES
-- (1, 1, 180); -- testuser1 兑换了 商品1 (笔记本)