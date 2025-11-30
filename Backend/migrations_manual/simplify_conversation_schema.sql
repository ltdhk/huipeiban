-- ============================================
-- 会话表简化迁移脚本
--
-- 变更说明：
-- 1. 删除 user_id, companion_id, institution_id 字段
-- 2. 添加 user1_id, user2_id 字段（统一使用 users 表的 ID）
-- 3. 删除 unread_count，改为 user1_unread, user2_unread
-- 4. 删除 title 字段（不再需要）
-- 5. 添加 last_message_at 字段
--
-- 注意：此脚本需要在 Supabase SQL Editor 中执行
-- ============================================

-- 1. 备份现有数据（可选，建议执行）
-- CREATE TABLE conversations_backup AS SELECT * FROM conversations;
-- CREATE TABLE messages_backup AS SELECT * FROM messages;

-- 2. 检查 conversations 表是否存在，如果不存在则创建
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'conversations') THEN
        -- 创建新的 conversations 表
        CREATE TABLE conversations (
            id BIGINT PRIMARY KEY,
            user1_id BIGINT NOT NULL REFERENCES users(id),
            user2_id BIGINT NOT NULL REFERENCES users(id),
            last_message TEXT,
            last_message_at TIMESTAMP WITH TIME ZONE,
            user1_unread INTEGER DEFAULT 0,
            user2_unread INTEGER DEFAULT 0,
            status VARCHAR(20) DEFAULT 'active',
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
        );

        -- 创建索引
        CREATE INDEX idx_conversations_user1_id ON conversations(user1_id);
        CREATE INDEX idx_conversations_user2_id ON conversations(user2_id);
        CREATE INDEX idx_conversations_status ON conversations(status);
        CREATE INDEX idx_conversations_updated_at ON conversations(updated_at DESC);

        RAISE NOTICE '创建了新的 conversations 表';
    ELSE
        RAISE NOTICE 'conversations 表已存在，需要迁移数据';
    END IF;
END $$;

-- 3. 如果 conversations 表已存在且使用旧结构，执行迁移
DO $$
BEGIN
    -- 检查是否存在旧字段
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'conversations' AND column_name = 'user_id'
    ) THEN
        RAISE NOTICE '检测到旧版表结构，开始迁移...';

        -- 添加新字段（如果不存在）
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_name = 'conversations' AND column_name = 'user1_id'
        ) THEN
            ALTER TABLE conversations ADD COLUMN user1_id BIGINT;
            ALTER TABLE conversations ADD COLUMN user2_id BIGINT;
            ALTER TABLE conversations ADD COLUMN user1_unread INTEGER DEFAULT 0;
            ALTER TABLE conversations ADD COLUMN user2_unread INTEGER DEFAULT 0;
            ALTER TABLE conversations ADD COLUMN last_message_at TIMESTAMP WITH TIME ZONE;
        END IF;

        -- 迁移数据：将旧字段数据转换到新字段
        UPDATE conversations SET
            user1_id = COALESCE(user_id, 0),
            user2_id = COALESCE(companion_id, institution_id, 0),
            user1_unread = COALESCE(unread_count, 0),
            user2_unread = 0,
            last_message_at = updated_at
        WHERE user1_id IS NULL OR user2_id IS NULL;

        -- 删除旧字段
        ALTER TABLE conversations DROP COLUMN IF EXISTS user_id;
        ALTER TABLE conversations DROP COLUMN IF EXISTS companion_id;
        ALTER TABLE conversations DROP COLUMN IF EXISTS institution_id;
        ALTER TABLE conversations DROP COLUMN IF EXISTS title;
        ALTER TABLE conversations DROP COLUMN IF EXISTS unread_count;

        -- 添加非空约束
        ALTER TABLE conversations ALTER COLUMN user1_id SET NOT NULL;
        ALTER TABLE conversations ALTER COLUMN user2_id SET NOT NULL;

        -- 添加外键约束
        ALTER TABLE conversations
            ADD CONSTRAINT fk_conversations_user1
            FOREIGN KEY (user1_id) REFERENCES users(id);
        ALTER TABLE conversations
            ADD CONSTRAINT fk_conversations_user2
            FOREIGN KEY (user2_id) REFERENCES users(id);

        -- 创建索引
        CREATE INDEX IF NOT EXISTS idx_conversations_user1_id ON conversations(user1_id);
        CREATE INDEX IF NOT EXISTS idx_conversations_user2_id ON conversations(user2_id);

        RAISE NOTICE '会话表迁移完成';
    ELSE
        RAISE NOTICE '会话表已经是新版结构，无需迁移';
    END IF;
END $$;

-- 4. 检查 messages 表是否存在，如果不存在则创建
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE tablename = 'messages') THEN
        -- 创建新的 messages 表
        CREATE TABLE messages (
            id BIGINT PRIMARY KEY,
            conversation_id BIGINT NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
            sender_id BIGINT NOT NULL REFERENCES users(id),
            receiver_id BIGINT NOT NULL REFERENCES users(id),
            content_type VARCHAR(20) DEFAULT 'text',
            content TEXT NOT NULL,
            is_read BOOLEAN DEFAULT FALSE,
            is_deleted BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
        );

        -- 创建索引
        CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
        CREATE INDEX idx_messages_sender_id ON messages(sender_id);
        CREATE INDEX idx_messages_receiver_id ON messages(receiver_id);
        CREATE INDEX idx_messages_is_read ON messages(is_read);
        CREATE INDEX idx_messages_created_at ON messages(created_at DESC);

        RAISE NOTICE '创建了新的 messages 表';
    ELSE
        RAISE NOTICE 'messages 表已存在';
    END IF;
END $$;

-- 5. 如果 messages 表使用旧结构，执行迁移
DO $$
BEGIN
    -- 检查是否存在旧字段 sender_type
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'messages' AND column_name = 'sender_type'
    ) THEN
        RAISE NOTICE '检测到 messages 表旧版结构，开始迁移...';

        -- 删除旧字段
        ALTER TABLE messages DROP COLUMN IF EXISTS sender_type;
        ALTER TABLE messages DROP COLUMN IF EXISTS receiver_type;

        RAISE NOTICE 'messages 表迁移完成';
    ELSE
        RAISE NOTICE 'messages 表已经是新版结构，无需迁移';
    END IF;

    -- 确保 is_deleted 字段存在
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'messages' AND column_name = 'is_deleted'
    ) THEN
        ALTER TABLE messages ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
        RAISE NOTICE '添加了 is_deleted 字段';
    END IF;
END $$;

-- 6. 删除无效数据（user1_id 或 user2_id 为 0 的记录）
DELETE FROM messages WHERE conversation_id IN (
    SELECT id FROM conversations WHERE user1_id = 0 OR user2_id = 0
);
DELETE FROM conversations WHERE user1_id = 0 OR user2_id = 0;

-- 7. 打印迁移完成信息
DO $$
BEGIN
    RAISE NOTICE '======================================';
    RAISE NOTICE '会话表简化迁移完成！';
    RAISE NOTICE '新的表结构：';
    RAISE NOTICE '  conversations: id, user1_id, user2_id, last_message, last_message_at, user1_unread, user2_unread, status, created_at, updated_at';
    RAISE NOTICE '  messages: id, conversation_id, sender_id, receiver_id, content_type, content, is_read, is_deleted, created_at';
    RAISE NOTICE '======================================';
END $$;
