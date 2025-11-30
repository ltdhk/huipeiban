-- =====================================================
-- 统一用户认证体系 - 数据库迁移脚本 (PostgreSQL 版本)
-- 版本: 1.0
-- 创建日期: 2025-11-30
-- 说明: 实现陪诊师和机构通过统一的 User 表进行认证
-- =====================================================

-- 开启事务
BEGIN;

-- =====================================================
-- 第一步: 添加新字段
-- =====================================================

-- 1.1 为 User 表添加 user_type 字段
ALTER TABLE users
ADD COLUMN user_type VARCHAR(20) DEFAULT 'patient';

-- 添加字段注释
COMMENT ON COLUMN users.user_type IS '用户类型: patient/companion/institution';

-- 创建索引以提升查询性能
CREATE INDEX idx_users_user_type ON users(user_type);

-- 1.2 为 Companion 表添加 user_id 字段
ALTER TABLE companions
ADD COLUMN user_id BIGINT NULL;

-- 添加字段注释
COMMENT ON COLUMN companions.user_id IS '关联用户ID';

-- 1.3 为 Institution 表添加 user_id 字段
ALTER TABLE institutions
ADD COLUMN user_id BIGINT NULL;

-- 添加字段注释
COMMENT ON COLUMN institutions.user_id IS '关联用户ID';

-- =====================================================
-- 第二步: 数据迁移
-- =====================================================

-- 2.1 为现有陪诊师创建关联的 User 记录
-- 注意: 这里假设 companions 表有 phone 和 password_hash 字段
-- 如果您的表结构不同,请根据实际情况调整
INSERT INTO users (
    id,
    phone,
    password_hash,
    nickname,
    avatar_url,
    user_type,
    status,
    created_at,
    updated_at,
    is_deleted
)
SELECT
    c.id + 1000000000 as id,  -- 为陪诊师生成不重复的用户ID (避免与现有用户ID冲突)
    c.phone,
    c.password_hash,
    c.name as nickname,
    c.avatar_url,
    'companion' as user_type,
    CASE
        WHEN c.status = 'approved' THEN 'active'
        WHEN c.status = 'disabled' THEN 'disabled'
        ELSE 'active'
    END as status,
    c.created_at,
    c.updated_at,
    c.is_deleted
FROM companions c
WHERE c.phone IS NOT NULL
AND c.password_hash IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM users u WHERE u.phone = c.phone
);

-- 2.2 更新 companions 表的 user_id (PostgreSQL 语法)
UPDATE companions
SET user_id = u.id
FROM users u
WHERE u.phone = companions.phone
AND u.user_type = 'companion'
AND companions.user_id IS NULL;

-- 2.3 为机构创建关联的 User 记录 (如果机构表有独立的认证信息)
-- 注意: 如果 institutions 表没有 phone/password_hash,可能需要手动创建
-- 这里提供一个模板,请根据实际情况调整或跳过

-- INSERT INTO users (
--     id,
--     phone,
--     password_hash,
--     nickname,
--     user_type,
--     status,
--     created_at,
--     updated_at,
--     is_deleted
-- )
-- SELECT
--     i.id + 2000000000 as id,
--     i.phone,
--     i.password_hash,  -- 如果没有此字段,需要先添加
--     i.name as nickname,
--     'institution' as user_type,
--     CASE
--         WHEN i.status = 'approved' THEN 'active'
--         WHEN i.status = 'disabled' THEN 'disabled'
--         ELSE 'active'
--     END as status,
--     i.created_at,
--     i.updated_at,
--     i.is_deleted
-- FROM institutions i
-- WHERE i.phone IS NOT NULL;

-- 2.4 更新 institutions 表的 user_id (PostgreSQL 语法)
-- UPDATE institutions
-- SET user_id = u.id
-- FROM users u
-- WHERE u.phone = institutions.phone
-- AND u.user_type = 'institution'
-- AND institutions.user_id IS NULL;

-- =====================================================
-- 第三步: 添加约束和索引
-- =====================================================

-- 3.1 将 user_id 设为 NOT NULL
-- 注意: 只有在所有记录都已正确迁移后才执行此步骤
-- 请先验证所有 companions 和 institutions 都有 user_id

-- ALTER TABLE companions ALTER COLUMN user_id SET NOT NULL;
-- ALTER TABLE institutions ALTER COLUMN user_id SET NOT NULL;

-- 3.2 添加外键约束
ALTER TABLE companions
ADD CONSTRAINT fk_companions_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE institutions
ADD CONSTRAINT fk_institutions_user_id
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

-- 3.3 添加唯一索引
CREATE UNIQUE INDEX idx_companions_user_id ON companions(user_id);
CREATE UNIQUE INDEX idx_institutions_user_id ON institutions(user_id);

-- =====================================================
-- 第四步: 清理冗余字段 (可选,谨慎执行)
-- =====================================================

-- 注意: 只有在确认数据迁移成功且应用已更新后才执行
-- 建议先备份数据

-- 移除 Companion 表的冗余字段
-- ALTER TABLE companions DROP COLUMN phone;
-- ALTER TABLE companions DROP COLUMN password_hash;

-- 如果需要,也可以移除 avatar_url (使用 User 表的字段)
-- ALTER TABLE companions DROP COLUMN avatar_url;

-- =====================================================
-- 第五步: 验证数据完整性
-- =====================================================

-- 验证所有陪诊师都有关联的用户
SELECT COUNT(*) as companions_without_user
FROM companions
WHERE user_id IS NULL;

-- 验证所有机构都有关联的用户
SELECT COUNT(*) as institutions_without_user
FROM institutions
WHERE user_id IS NULL;

-- 验证用户类型分布
SELECT user_type, COUNT(*) as count
FROM users
GROUP BY user_type;

-- 如果上述查询结果都符合预期,则提交事务
-- COMMIT;

-- 如果发现问题,可以回滚
-- ROLLBACK;

-- =====================================================
-- 注意事项
-- =====================================================

/*
1. 请在测试环境先执行此脚本,验证无误后再在生产环境执行
2. 执行前请务必备份数据库
3. 建议分步骤执行,每步都验证结果
4. 如果 institutions 表没有独立的认证字段,需要另行处理
5. NOT NULL 约束和 DROP COLUMN 操作已注释,请谨慎解除注释
6. 执行完成后记得更新应用代码和重启服务
*/

-- 显示执行完成提示
SELECT '数据库迁移脚本执行完成,请检查验证结果' AS status;
