# MY-CHAT

## 服务架构
包含三个核心服务：
- [**用户服务**](https://github.com/WH-5/user-service)  
- [**好友服务**](https://github.com/WH-5/friend-service)  
- [**聊天服务**](https://github.com/WH-5/chat-service)  

### 1. 用户服务
**功能：**
- 注册
- 用户登录与认证
- 生成唯一 ID 及后续修改
- 用户资料的设置与更新（包括显示唯一 ID）
- 获取用户资料
- 修改密码


**职责：**
管理用户的基本信息和认证，负责用户注册、登录以及资料变更。

### 2. 好友服务
**功能：**
- 按唯一 ID 搜索用户
- 发送添加好友请求
- 好友申请审批
- 修改好友备注
- 删除好友

**职责：**
管理用户之间的好友关系和互动，处理好友请求及后续管理。
CREATE TABLE users (
id SERIAL PRIMARY KEY,
unique_id VARCHAR(20) UNIQUE NOT NULL,
nickname VARCHAR(100) NOT NULL
);

CREATE TABLE friendships (
id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
friend_id INT NOT NULL,
status INT DEFAULT 0,  -- 0: 待审批, 1: 已添加, 2: 已拒绝
remark VARCHAR(100),   -- 好友备注
created_at TIMESTAMP DEFAULT NOW(),
updated_at TIMESTAMP DEFAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);

### 3. 聊天服务
**功能：**
- 一对一即时聊天
- 端到端加密确保消息私密性
- 管理消息状态（发送、接收、已读等）
- 消息通知（在线推送及离线补发）
- 消息的临时存储、去重、顺序保证与清理（服务器侧仅存储未送达或未确认的消息）

**职责：**
处理即时通讯的核心逻辑，确保消息传输的安全、可靠和实时性。


**职责：**
专门处理群聊场景，与一对一聊天逻辑有一定差异，功能更侧重于群组管理和权限控制。

### 5. 推送服务
**功能：**

- 记录用户在线状态
- 处理一对一和群聊消息的实时推送
- 维护消息的投递状态（发送、接收、已读）
- 处理离线消息的存储与同步
- 维持心跳检测，确保连接稳定
- 处理断线重连

**职责：**
WebSocket 服务负责维护用户的长连接，实现即时通讯功能，确保消息能够稳定、高效地传输。它会管理用户在线状态，处理消息的路由和推送，并保证离线消息的同步和投递。

## 设备本地存储
需要注意的是，设备本地存储信息主要由客户端负责：

- 用户发送消息时，先在本地存储，再发给服务器。
- 消息接收后，在线用户直接存储，离线用户上线后同步未读消息。
- 服务器负责的是消息的临时存储与推送，而消息的长期存储和管理在客户端完成。
