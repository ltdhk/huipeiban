# -*- coding: utf-8 -*-
"""
AI Agent 服务 - 使用 Function Calling 和 OpenRouter
"""
import os
import json
import uuid
import re
from datetime import datetime
from typing import List, Dict, Optional, Tuple, Any

import requests
from flask import current_app

from app.extensions import db
from app.models.ai import AIChatHistory
from app.models.companion import Companion, Institution
from app.services.recommendation import recommendation_service


class AIAgent:
    """AI助手服务类"""

    def __init__(self):
        """初始化 AI Agent"""
        self._initialized = False
        self.api_key = None
        self.model = None
        self.base_url = None
        self.chat_endpoint = None
        self.session: Optional[requests.Session] = None
        self.site_url: Optional[str] = None
        self.site_title: Optional[str] = None
        self.tools = None

    def _ensure_initialized(self):
        """确保 AI Agent 已初始化（延迟初始化）"""
        if self._initialized:
            return

        self.api_key = current_app.config.get('OPENROUTER_API_KEY')
        self.model = current_app.config.get('OPENROUTER_MODEL')
        self.base_url = (current_app.config.get('OPENROUTER_BASE_URL') or '').rstrip('/')
        self.site_url = current_app.config.get('OPENROUTER_SITE_URL') or os.getenv('OPENROUTER_SITE_URL')
        self.site_title = current_app.config.get('OPENROUTER_SITE_TITLE') or \
            os.getenv('OPENROUTER_SITE_TITLE', 'CareLink AI Assistant')
        
        current_app.logger.info(f"OpenRouter key prefix: {self.api_key[:8]}***")

        if not self.api_key:
            raise RuntimeError('OpenRouter API key 未配置')
        if not self.model:
            raise RuntimeError('OpenRouter 模型未配置')
        if not self.base_url:
            raise RuntimeError('OpenRouter Base URL 未配置')

        self.chat_endpoint = f'{self.base_url}/chat/completions'

        # 初始化 HTTP 会话，避免底层 OpenAI 客户端触发 proxies 参数错误
        self.session = requests.Session()
        headers = {
            'Authorization': f'Bearer {self.api_key}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'CareLinkBackend/1.0',
            'X-Title': self.site_title
        }
        if self.site_url:
            headers['HTTP-Referer'] = self.site_url
            headers['Referer'] = self.site_url
        else:
            current_app.logger.warning('OpenRouter Referer 未配置，建议在 .env 中设置 OPENROUTER_SITE_URL')
        self.session.headers.update(headers)

        # 定义可用的工具（Function Calling）
        self.tools = self._define_tools()
        self._initialized = True

    def _define_tools(self) -> List[Dict]:
        """
        定义 AI Agent 可使用的工具（函数）

        Returns:
            工具定义列表
        """
        return [
            {
                "type": "function",
                "function": {
                    "name": "search_companions",
                    "description": "搜索陪诊师。根据用户提供的条件（城市、医院、是否有车、最低评分等）搜索合适的陪诊师",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "city": {
                                "type": "string",
                                "description": "城市名称，如：北京、上海"
                            },
                            "hospital": {
                                "type": "string",
                                "description": "医院名称，如：协和医院、北京大学第三医院"
                            },
                            "has_car": {
                                "type": "boolean",
                                "description": "是否需要有车的陪诊师"
                            },
                            "min_rating": {
                                "type": "number",
                                "description": "最低评分要求（0-5），默认4.0"
                            },
                            "limit": {
                                "type": "integer",
                                "description": "返回数量，默认5"
                            }
                        }
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "search_institutions",
                    "description": "搜索陪诊机构。根据用户提供的条件（城市、最低评分等）搜索合适的陪诊机构",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "city": {
                                "type": "string",
                                "description": "城市名称，如：北京、上海"
                            },
                            "min_rating": {
                                "type": "number",
                                "description": "最低评分要求（0-5），默认4.0"
                            },
                            "limit": {
                                "type": "integer",
                                "description": "返回数量，默认5"
                            }
                        }
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "get_companion_detail",
                    "description": "获取指定陪诊师的详细信息",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "companion_id": {
                                "type": "integer",
                                "description": "陪诊师ID"
                            }
                        },
                        "required": ["companion_id"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "get_institution_detail",
                    "description": "获取指定陪诊机构的详细信息",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "institution_id": {
                                "type": "integer",
                                "description": "机构ID"
                            }
                        },
                        "required": ["institution_id"]
                    }
                }
            }
        ]

    def _create_completion(
        self,
        messages: List[Dict],
        tools: Optional[List[Dict]] = None,
        tool_choice: Optional[str] = None,
        temperature: float = 0.7,
        max_tokens: int = 2000
    ) -> Dict:
        """调用 OpenRouter Chat Completions 接口"""
        payload: Dict[str, Any] = {
            'model': self.model,
            'messages': messages,
            'temperature': temperature,
            'max_tokens': max_tokens
        }

        if tools:
            payload['tools'] = tools
            if tool_choice:
                payload['tool_choice'] = tool_choice

        return self._post_to_openrouter(payload)

    def _post_to_openrouter(self, payload: Dict[str, Any]) -> Dict:
        """发送请求到 OpenRouter"""
        if not self.session or not self.chat_endpoint:
            raise RuntimeError('AI Agent 尚未初始化')

        try:
            response = self.session.post(self.chat_endpoint, json=payload, timeout=60)
            response.raise_for_status()
            return response.json()
        except requests.HTTPError as exc:
            resp = exc.response
            status = resp.status_code if resp is not None else 'unknown'
            body = ''
            if resp is not None:
                try:
                    body = resp.text
                except Exception:
                    body = '<body 读取失败>'
            current_app.logger.error(
                f'调用 OpenRouter 失败，状态码 {status}，响应: {body}'
            )
            raise RuntimeError(f'OpenRouter API 调用失败: HTTP {status}')
        except requests.RequestException as exc:
            current_app.logger.error(f'调用 OpenRouter 失败: {exc}')
            raise RuntimeError('OpenRouter API 请求异常，请检查网络连接')

    def _extract_message_content(self, message: Dict) -> str:
        """兼容不同响应格式的内容解析"""
        if not message:
            return ""

        content = message.get('content')
        if isinstance(content, str):
            return content
        if isinstance(content, list):
            parts = []
            for item in content:
                if isinstance(item, dict):
                    parts.append(item.get('text') or item.get('content') or '')
                else:
                    parts.append(str(item))
            return ''.join(parts)
        return content or ""

    def _parse_tool_arguments(self, arguments: Any) -> Dict:
        """解析工具调用参数"""
        if isinstance(arguments, dict):
            return arguments
        if isinstance(arguments, str) and arguments.strip():
            try:
                return json.loads(arguments)
            except json.JSONDecodeError:
                current_app.logger.warning(f'解析工具参数失败: {arguments}')
        return {}

    def chat(self, user_id: int, message: str, session_id: Optional[str] = None) -> Dict:
        """
        处理用户消息并返回AI响应

        Args:
            user_id: 用户ID
            message: 用户消息内容
            session_id: 会话ID（可选，如果不提供则创建新会话）

        Returns:
            包含响应内容的字典
        """
        # 确保已初始化
        self._ensure_initialized()

        try:
            # 如果没有提供 session_id，创建新会话
            if not session_id:
                session_id = f"session_{user_id}_{uuid.uuid4().hex[:8]}"

            # 保存用户消息到数据库
            user_message = AIChatHistory(
                user_id=user_id,
                session_id=session_id,
                role='user',
                content=message,
                model_name=self.model
            )
            db.session.add(user_message)
            db.session.flush()

            # 获取对话历史
            history = self._get_conversation_history(user_id, session_id)

            # 构建消息列表
            messages = self._build_messages(history, message)

            # 记录即将发送给 AI 的信息
            current_app.logger.info('=' * 60)
            current_app.logger.info('准备调用 AI API')
            current_app.logger.info(f'模型: {self.model}')
            current_app.logger.info(f'消息数量: {len(messages)}')
            current_app.logger.info(f'工具数量: {len(self.tools)}')
            current_app.logger.info(f'工具列表: {[tool["function"]["name"] for tool in self.tools]}')
            current_app.logger.info('=' * 60)

            # 调用 OpenRouter API（支持 Function Calling）
            response = self._create_completion(
                messages=messages,
                tools=self.tools,
                tool_choice="auto",  # 让模型自动决定是否调用工具
                temperature=0.7,
                max_tokens=2000
            )

            choices = response.get('choices', [])
            if not choices:
                raise RuntimeError('OpenRouter 未返回任何响应')

            # 处理响应
            assistant_message_obj = choices[0].get('message', {})
            assistant_content = self._extract_message_content(assistant_message_obj)
            usage = response.get('usage') or {}
            tokens_used = usage.get('total_tokens', 0)

            # 记录 AI 响应详情
            current_app.logger.info('=' * 60)
            current_app.logger.info('收到 AI 响应')
            current_app.logger.info(f'响应内容: {assistant_content[:100]}...')
            current_app.logger.info(f'响应对象类型: {type(assistant_message_obj)}')
            if isinstance(assistant_message_obj, dict):
                current_app.logger.info(f'响应对象字段: {list(assistant_message_obj.keys())}')
            else:
                current_app.logger.info(f'响应对象数据: {assistant_message_obj}')

            # 初始化意图、实体和推荐
            intent = None
            entities = {}
            recommendations = []

            # 检查是否有工具调用
            tool_calls = assistant_message_obj.get('tool_calls') or []
            current_app.logger.info(f'工具调用 (tool_calls): {tool_calls}')
            current_app.logger.info(f'工具调用类型: {type(tool_calls)}')
            current_app.logger.info('=' * 60)

            if tool_calls:
                current_app.logger.info(f'检测到 {len(tool_calls)} 个工具调用')
                # 处理工具调用
                for tool_call in tool_calls:
                    function_name = tool_call.get('function', {}).get('name')
                    function_args = self._parse_tool_arguments(
                        tool_call.get('function', {}).get('arguments')
                    )

                    # 执行工具并获取结果
                    tool_result = self._execute_tool(function_name, function_args)

                    # 根据工具调用更新意图和推荐
                    if function_name == 'search_companions':
                        intent = 'find_companion'
                        entities = function_args
                        # 保存完整的陪诊师数据用于前端展示
                        companions_data = recommendation_service.recommend_companions(
                            city=function_args.get('city'),
                            hospital=function_args.get('hospital'),
                            has_car=function_args.get('has_car'),
                            min_rating=function_args.get('min_rating', 4.0),
                            limit=function_args.get('limit', 5)
                        )
                        recommendations = companions_data
                    elif function_name == 'search_institutions':
                        intent = 'find_institution'
                        entities = function_args
                        # 保存完整的机构数据用于前端展示
                        institutions_data = recommendation_service.recommend_institutions(
                            city=function_args.get('city'),
                            min_rating=function_args.get('min_rating', 4.0),
                            limit=function_args.get('limit', 5)
                        )
                        recommendations = institutions_data
                    elif function_name == 'get_companion_detail':
                        intent = 'inquiry'
                        entities = function_args
                        recommendations = [tool_result] if tool_result else []
                    elif function_name == 'get_institution_detail':
                        intent = 'inquiry'
                        entities = function_args
                        recommendations = [tool_result] if tool_result else []

                # 如果有工具调用，需要再次调用 API 生成包含工具结果的最终回复
                # 将工具调用结果添加到消息中
                messages.append({
                    "role": "assistant",
                    "content": assistant_content,
                    "tool_calls": [
                        {
                            "id": tc.get('id'),
                            "type": "function",
                            "function": {
                                "name": tc.get('function', {}).get('name'),
                                "arguments": tc.get('function', {}).get('arguments')
                            }
                        }
                        for tc in tool_calls
                    ]
                })

                # 添加工具响应
                for tool_call in tool_calls:
                    function_name = tool_call.get('function', {}).get('name')
                    function_args = self._parse_tool_arguments(
                        tool_call.get('function', {}).get('arguments')
                    )
                    tool_result = self._execute_tool(function_name, function_args)

                    messages.append({
                        "role": "tool",
                        "tool_call_id": tool_call.get('id'),
                        "content": json.dumps(tool_result, ensure_ascii=False)
                    })

                # 再次调用 API 生成最终回复
                final_response = self._create_completion(
                    messages=messages,
                    temperature=0.7,
                    max_tokens=2000
                )

                final_choices = final_response.get('choices', [])
                if not final_choices:
                    raise RuntimeError('OpenRouter 未返回最终回复')

                assistant_content = self._extract_message_content(final_choices[0].get('message', {}))
                final_usage = final_response.get('usage') or {}
                tokens_used += final_usage.get('total_tokens', 0)
            else:
                # 没有工具调用，使用原有的意图识别方法
                intent, entities = self._extract_intent_and_entities(assistant_content, message)

            # 从对话历史中提取收集到的信息
            collected_info = self._extract_collected_info(history, message)

            # 保存AI响应到数据库
            assistant_message = AIChatHistory(
                user_id=user_id,
                session_id=session_id,
                role='assistant',
                content=assistant_content,
                intent=intent,
                entities=entities,
                meta_data={
                    'recommendations': recommendations,
                    'collected_info': collected_info
                } if (recommendations or collected_info) else None,
                model_name=self.model,
                tokens_used=tokens_used
            )
            db.session.add(assistant_message)
            db.session.commit()

            return {
                'success': True,
                'session_id': session_id,
                'message': assistant_content,
                'intent': intent,
                'entities': entities,
                'recommendations': recommendations,
                'collected_info': collected_info,  # 新增：收集到的信息
                'created_at': datetime.utcnow().isoformat()
            }

        except Exception as e:
            db.session.rollback()
            current_app.logger.error(f'AI Agent error: {str(e)}')
            return {
                'success': False,
                'error': '抱歉，AI助手暂时无法响应，请稍后再试',
                'detail': str(e)
            }

    def _get_conversation_history(self, user_id: int, session_id: str, limit: int = 10) -> List[AIChatHistory]:
        """
        获取对话历史记录

        Args:
            user_id: 用户ID
            session_id: 会话ID
            limit: 获取最近N条记录

        Returns:
            对话历史列表
        """
        return AIChatHistory.query.filter_by(
            user_id=user_id,
            session_id=session_id
        ).order_by(
            AIChatHistory.created_at.desc()
        ).limit(limit).all()[::-1]  # 反转列表，按时间正序

    def _build_messages(self, history: List[AIChatHistory], current_message: str) -> List[Dict]:
        """
        构建发送给AI的消息列表

        Args:
            history: 对话历史
            current_message: 当前用户消息

        Returns:
            消息列表
        """
        messages = [
            {
                'role': 'system',
                'content': self._get_system_prompt()
            }
        ]

        # 添加历史消息
        for msg in history:
            messages.append({
                'role': msg.role,
                'content': msg.content
            })

        # 添加当前消息
        messages.append({
            'role': 'user',
            'content': current_message
        })

        return messages

    def _get_system_prompt(self) -> str:
        """
        获取系统提示词

        Returns:
            系统提示词字符串
        """
        return """你是「会照护」平台的AI助手，专门为需要陪诊服务的用户提供帮助。

你的主要职责：
1. 收集用户的陪诊需求信息（必须收集完整才能推荐）
2. 使用提供的工具搜索和推荐合适的陪诊师或陪诊机构
3. 解答用户关于陪诊服务的疑问
4. 引导用户完成预约流程

预约必需信息收集流程（非常重要）：
在推荐陪诊师之前，你必须按顺序收集以下信息：

1. 【服务地点】您需要在哪个城市、哪家医院就诊？
   - 示例："北京协和医院"、"上海第一人民医院"

2. 【就诊时间】您预约的就诊日期和时间是？
   - 示例："明天上午9点"、"下周五下午2点"、"7月28日上午10:00"

3. 【是否需要接送】您需要陪诊师提供接送服务吗？
   - 选项：只接、只送、接送、不需要

4. 【其他需求】（可选）
   - 是否需要有车的陪诊师？
   - 有没有特殊要求？

信息收集规则：
- 每次只询问缺失的信息，不要重复询问已知信息
- 如果用户一次性提供多个信息，记录所有信息并只询问缺失的部分
- 使用自然对话方式询问，避免生硬的表单式提问
- 在收集到所有必需信息（地点、时间、是否接送）后，才能调用工具推荐陪诊师

对话规则：
- 保持友好、专业、有同理心的语气
- 简洁明了，每次回复控制在2-3句话以内
- 如果用户询问平台之外的问题，礼貌地引导回陪诊服务话题

工具使用指南：
- **重要**: 只有在收集到【服务地点（城市+医院）】、【就诊时间】、【是否接送】这三个必需信息后，才能调用搜索工具
- **绝对禁止**: 在没有调用 search_companions 或 search_institutions 工具的情况下，直接说"为您推荐以下陪诊师"或类似的推荐语句
- 当用户需要找陪诊师时，必须调用 search_companions 工具
- 当用户需要找陪诊机构时，必须调用 search_institutions 工具
- 从对话历史中提取已收集的信息作为工具参数
- 如果信息不完整，继续询问缺失的信息，不要推荐
- 获得工具结果后的回复规则：
  * 如果找到了陪诊师/机构，只需回复："为您推荐以下陪诊师（或机构），您可以查看详情并选择预约。"
  * 绝对不要在文字中列出任何陪诊师/机构的详细信息（姓名、评分、经验、订单数等），这些信息会以卡片形式单独展示
  * 如果没找到结果，需要向用户解释原因并提供建议

对话示例：

用户："我需要陪诊服务"
助手："好的，很高兴为您服务。请问您需要在哪个城市、哪家医院就诊？"

用户："北京协和医院"
助手："明白了，北京协和医院。请问您预约的就诊时间是什么时候？"

用户："明天上午9点半"
助手："收到，明天上午9:30。请问您需要陪诊师提供接送服务吗？（只接/只送/接送/不需要）"

用户："需要接送"
助手：【此时收集完所有必需信息，调用 search_companions 工具】"为您推荐以下陪诊师，您可以查看详情并选择预约。"

意图识别：
- find_companion: 寻找陪诊师
- find_institution: 寻找陪诊机构
- booking: 预约陪诊服务
- inquiry: 咨询服务详情
- other: 其他问题
"""

    def _execute_tool(self, function_name: str, function_args: Dict) -> Any:
        """
        执行工具函数

        Args:
            function_name: 函数名称
            function_args: 函数参数

        Returns:
            工具执行结果
        """
        try:
            if function_name == 'search_companions':
                return self._tool_search_companions(**function_args)
            elif function_name == 'search_institutions':
                return self._tool_search_institutions(**function_args)
            elif function_name == 'get_companion_detail':
                return self._tool_get_companion_detail(**function_args)
            elif function_name == 'get_institution_detail':
                return self._tool_get_institution_detail(**function_args)
            else:
                return {"error": f"Unknown function: {function_name}"}
        except Exception as e:
            current_app.logger.error(f'Tool execution error ({function_name}): {str(e)}')
            return {"error": str(e)}

    def _tool_search_companions(
        self,
        city: Optional[str] = None,
        hospital: Optional[str] = None,
        has_car: Optional[bool] = None,
        min_rating: float = 4.0,
        limit: int = 5
    ) -> List[Dict]:
        """
        工具：搜索陪诊师

        Args:
            city: 城市
            hospital: 医院
            has_car: 是否需要有车
            min_rating: 最低评分
            limit: 返回数量

        Returns:
            陪诊师列表
        """
        # 打印工具调用参数到日志
        current_app.logger.info('=' * 60)
        current_app.logger.info('AI工具调用: search_companions')
        current_app.logger.info(f'从对话中收集到的参数:')
        current_app.logger.info(f'  - city (城市): {city}')
        current_app.logger.info(f'  - hospital (医院): {hospital}')
        current_app.logger.info(f'  - has_car (是否有车): {has_car}')
        current_app.logger.info(f'  - min_rating (最低评分): {min_rating}')
        current_app.logger.info(f'  - limit (返回数量): {limit}')
        current_app.logger.info('=' * 60)

        companions = recommendation_service.recommend_companions(
            city=city,
            hospital=hospital,
            has_car=has_car,
            min_rating=min_rating,
            limit=limit
        )

        # 返回给AI的数据：只包含数量和类型，不包含详细信息
        # 详细信息会存储在recommendations中返回给前端
        if companions:
            return {
                'success': True,
                'count': len(companions),
                'type': 'companion',
                'message': f'找到了 {len(companions)} 位陪诊师'
            }
        else:
            return {
                'success': False,
                'count': 0,
                'type': 'companion',
                'message': '未找到符合条件的陪诊师'
            }

    def _tool_search_institutions(
        self,
        city: Optional[str] = None,
        min_rating: float = 4.0,
        limit: int = 5
    ) -> List[Dict]:
        """
        工具：搜索陪诊机构

        Args:
            city: 城市
            min_rating: 最低评分
            limit: 返回数量

        Returns:
            机构列表
        """
        institutions = recommendation_service.recommend_institutions(
            city=city,
            min_rating=min_rating,
            limit=limit
        )

        # 返回给AI的数据：只包含数量和类型，不包含详细信息
        if institutions:
            return {
                'success': True,
                'count': len(institutions),
                'type': 'institution',
                'message': f'找到了 {len(institutions)} 家陪诊机构'
            }
        else:
            return {
                'success': False,
                'count': 0,
                'type': 'institution',
                'message': '未找到符合条件的陪诊机构'
            }

    def _tool_get_companion_detail(self, companion_id: int) -> Optional[Dict]:
        """
        工具：获取陪诊师详情

        Args:
            companion_id: 陪诊师ID

        Returns:
            陪诊师详情
        """
        companion = Companion.query.filter_by(
            id=companion_id,
            is_deleted=False
        ).first()

        if not companion:
            return {"error": "陪诊师不存在"}

        data = companion.to_dict()
        return {
            'type': 'companion',
            **data
        }

    def _tool_get_institution_detail(self, institution_id: int) -> Optional[Dict]:
        """
        工具：获取机构详情

        Args:
            institution_id: 机构ID

        Returns:
            机构详情
        """
        institution = Institution.query.filter_by(
            id=institution_id,
            is_deleted=False
        ).first()

        if not institution:
            return {"error": "机构不存在"}

        data = institution.to_dict()
        return {
            'type': 'institution',
            **data
        }

    def _extract_intent_and_entities(self, assistant_content: str, user_message: str) -> Tuple[Optional[str], Optional[Dict]]:
        """
        从对话中提取意图和实体

        Args:
            assistant_content: AI助手响应
            user_message: 用户消息

        Returns:
            (意图, 实体字典)
        """
        # 简单的关键词匹配（后续可以用更复杂的NLP或单独的AI调用）
        intent = None
        entities = {}

        # 意图识别
        if any(keyword in user_message for keyword in ['陪诊师', '陪护', '找人', '推荐']):
            intent = 'find_companion'
        elif any(keyword in user_message for keyword in ['机构', '公司', '专业']):
            intent = 'find_institution'
        elif any(keyword in user_message for keyword in ['预约', '订单', '下单', '安排']):
            intent = 'booking'
        elif any(keyword in user_message for keyword in ['价格', '费用', '多少钱', '怎么收费']):
            intent = 'inquiry'
        else:
            intent = 'other'

        # 实体抽取（简单示例，实际应该使用NER）
        # 这里只是占位实现，后续可以用正则、NER模型等改进
        entities = {
            'extracted': False,
            'message': '实体抽取功能待完善'
        }

        return intent, entities

    def _get_recommendations(self, intent: Optional[str], entities: Optional[Dict]) -> Optional[List[Dict]]:
        """
        根据意图和实体获取推荐结果

        Args:
            intent: 识别的意图
            entities: 提取的实体

        Returns:
            推荐列表
        """
        recommendations = []

        try:
            if intent == 'find_companion':
                # 推荐陪诊师（简单版本：取评分最高的前3个）
                companions = Companion.query.filter_by(
                    is_verified=True,
                    is_active=True,
                    is_deleted=False
                ).order_by(Companion.rating.desc()).limit(3).all()

                recommendations = [
                    {
                        'type': 'companion',
                        'id': c.id,
                        'name': c.name,
                        'avatar': c.avatar,
                        'rating': float(c.rating),
                        'experience': c.experience,
                        'hourly_rate': float(c.hourly_rate)
                    }
                    for c in companions
                ]

            elif intent == 'find_institution':
                # 推荐机构（简单版本：取评分最高的前3个）
                institutions = Institution.query.filter_by(
                    is_verified=True,
                    is_active=True,
                    is_deleted=False
                ).order_by(Institution.rating.desc()).limit(3).all()

                recommendations = [
                    {
                        'type': 'institution',
                        'id': i.id,
                        'name': i.name,
                        'logo': i.logo,
                        'rating': float(i.rating),
                        'service_count': i.service_count,
                        'address': i.address
                    }
                    for i in institutions
                ]

        except Exception as e:
            current_app.logger.error(f'Get recommendations error: {str(e)}')

        return recommendations if recommendations else None

    def _extract_collected_info(self, history: List[AIChatHistory], current_message: str) -> Dict:
        """
        从对话历史中提取已收集的预约信息

        Args:
            history: 对话历史
            current_message: 当前用户消息

        Returns:
            收集到的信息字典
        """
        import re
        from datetime import datetime, timedelta

        collected = {
            'hospital': None,
            'city': None,
            'date': None,
            'time': None,
            'pickup': None,
            'has_car': None
        }

        # 合并所有用户消息和当前消息
        all_messages = [msg.content for msg in history if msg.role == 'user'] + [current_message]
        conversation_text = ' '.join(all_messages)

        # 打印对话内容用于调试
        current_app.logger.info(f'提取信息 - 对话内容: {conversation_text}')

        # 提取医院信息（多种模式）
        # 1. 带后缀的医院名称
        hospital_pattern = r'([\u4e00-\u9fa5]+(?:医院|医疗中心|卫生院|诊所|门诊部|健康中心))'
        hospital_match = re.search(hospital_pattern, conversation_text)
        if hospital_match:
            collected['hospital'] = hospital_match.group(1)
        else:
            # 2. X院 简称模式（如"六院"、"九院"、"一院"）
            short_hospital_pattern = r'(?:的|去|到|在)?([一二三四五六七八九十百\d]+院)'
            short_match = re.search(short_hospital_pattern, conversation_text)
            if short_match:
                hospital_name = short_match.group(1)
                # 根据城市补充完整名称
                city_pattern_temp = r'(北京|上海|广州|深圳|杭州|成都|重庆|武汉|西安|南京|天津|苏州|长沙|郑州|沈阳|青岛|宁波|无锡|佛山|东莞|合肥)'
                city_match_temp = re.search(city_pattern_temp, conversation_text)
                if city_match_temp:
                    city = city_match_temp.group(1)
                    collected['hospital'] = f'{city}市第{hospital_name}'
                else:
                    collected['hospital'] = f'第{hospital_name}'
            else:
                # 3. 去/到+地点 模式（如"去协和"、"到人民医院"）
                go_hospital_pattern = r'(?:去|到|在)([^\s,，。\d]{2,10}?)(?:看病|就诊|检查|挂号|复查|做|体检|陪诊)'
                go_match = re.search(go_hospital_pattern, conversation_text)
                if go_match:
                    hospital_name = go_match.group(1).strip()
                    # 如果提取的名称不包含"医院"，自动补充
                    if not any(suffix in hospital_name for suffix in ['医院', '诊所', '中心']):
                        hospital_name = hospital_name + '医院'
                    collected['hospital'] = hospital_name
                else:
                    # 4. 常见知名医院的简称
                    known_hospitals = {
                        '协和': '北京协和医院',
                        '同仁': '北京同仁医院',
                        '积水潭': '北京积水潭医院',
                        '朝阳': '北京朝阳医院',
                        '安贞': '北京安贞医院',
                        '宣武': '首都医科大学宣武医院',
                        '友谊': '北京友谊医院',
                        '中日': '中日友好医院',
                        '301': '中国人民解放军总医院',
                        '三零一': '中国人民解放军总医院',
                        '华山': '复旦大学附属华山医院',
                        '瑞金': '上海交通大学医学院附属瑞金医院',
                        '中山': '中山大学附属第一医院',
                        '西南': '西南医院',
                        '湘雅': '中南大学湘雅医院',
                        '华西': '四川大学华西医院',
                    }
                    for short_name, full_name in known_hospitals.items():
                        if short_name in conversation_text:
                            collected['hospital'] = full_name
                            break

        # 提取城市信息（常见城市名称）
        city_pattern = r'(北京|上海|广州|深圳|杭州|成都|重庆|武汉|西安|南京|天津|苏州|长沙|郑州|沈阳|青岛|宁波|无锡|佛山|东莞|合肥)'
        city_match = re.search(city_pattern, conversation_text)
        if city_match:
            collected['city'] = city_match.group(1)
        elif collected['hospital']:
            # 如果提到了医院但没有明确城市，可能医院名包含城市信息
            for city in ['北京', '上海', '广州', '深圳', '杭州', '成都', '重庆', '武汉', '西安', '南京']:
                if city in collected['hospital']:
                    collected['city'] = city
                    break

        # 提取日期信息
        today = datetime.now().date()

        # 相对日期：明天、后天、下周等
        if '明天' in conversation_text:
            collected['date'] = (today + timedelta(days=1)).isoformat()
        elif '后天' in conversation_text:
            collected['date'] = (today + timedelta(days=2)).isoformat()
        elif '大后天' in conversation_text:
            collected['date'] = (today + timedelta(days=3)).isoformat()
        elif '下周' in conversation_text:
            collected['date'] = (today + timedelta(days=7)).isoformat()
        else:
            # 绝对日期：X月X日、X号
            date_patterns = [
                r'(\d{1,2})月(\d{1,2})[日号]',  # 7月28日、7月28号
                r'(\d{4})年(\d{1,2})月(\d{1,2})[日号]',  # 2024年7月28日
            ]
            for pattern in date_patterns:
                match = re.search(pattern, conversation_text)
                if match:
                    if len(match.groups()) == 2:
                        month, day = match.groups()
                        year = today.year
                        try:
                            date_obj = datetime(year, int(month), int(day)).date()
                            collected['date'] = date_obj.isoformat()
                        except ValueError:
                            pass
                    elif len(match.groups()) == 3:
                        year, month, day = match.groups()
                        try:
                            date_obj = datetime(int(year), int(month), int(day)).date()
                            collected['date'] = date_obj.isoformat()
                        except ValueError:
                            pass
                    break

        # 提取时间信息
        time_patterns = [
            r'(\d{1,2})[点:](\d{1,2})',  # 9点30、9:30
            r'(\d{1,2})点[钟半]?',  # 9点、9点半
            r'(上午|下午|早上|中午|晚上)(\d{1,2})[点:]?(\d{1,2})?',  # 上午9点30
        ]
        for pattern in time_patterns:
            match = re.search(pattern, conversation_text)
            if match:
                groups = match.groups()
                if len(groups) == 2 and groups[0].isdigit():
                    # 9:30 格式
                    hour, minute = int(groups[0]), int(groups[1])
                    collected['time'] = f'{hour:02d}:{minute:02d}'
                elif len(groups) == 1 and groups[0].isdigit():
                    # 9点 格式
                    hour = int(groups[0])
                    collected['time'] = f'{hour:02d}:00'
                elif len(groups) >= 2 and not groups[0].isdigit():
                    # 上午9点30 格式
                    period = groups[0]
                    hour = int(groups[1])
                    minute = int(groups[2]) if len(groups) > 2 and groups[2] else 0

                    # 处理上午/下午
                    if period in ['下午', '晚上'] and hour < 12:
                        hour += 12

                    collected['time'] = f'{hour:02d}:{minute:02d}'
                break

        # 提取接送需求
        if '只接' in conversation_text or '接不送' in conversation_text:
            collected['pickup'] = 'pickup_only'
        elif '只送' in conversation_text or '送不接' in conversation_text:
            collected['pickup'] = 'dropoff_only'
        elif '接送' in conversation_text and '不' not in conversation_text:
            collected['pickup'] = 'both'
        elif '需要接送' in conversation_text:
            collected['pickup'] = 'both'
        elif any(keyword in conversation_text for keyword in ['不需要接送', '不用接送', '自己去', '不需要', '不用', '否']):
            # 检查上下文是否是在回答接送问题
            # 如果对话中有"接送"相关问题的上下文，"不需要"就是指不需要接送
            if '接送' in conversation_text or '不需要' in conversation_text or '不用' in conversation_text or '否' in conversation_text:
                collected['pickup'] = 'none'

        # 提取是否需要车
        if '有车' in conversation_text or '需要车' in conversation_text or '开车' in conversation_text:
            collected['has_car'] = True
        elif '无车' in conversation_text or '没车' in conversation_text or '不需要车' in conversation_text:
            collected['has_car'] = False

        # 打印提取结果
        result = {k: v for k, v in collected.items() if v is not None}
        current_app.logger.info(f'提取信息 - 结果: {result}')

        # 过滤掉 None 值
        return result

    def get_chat_history(self, user_id: int, session_id: str, page: int = 1, page_size: int = 20) -> Dict:
        """
        获取聊天历史

        Args:
            user_id: 用户ID
            session_id: 会话ID
            page: 页码
            page_size: 每页数量

        Returns:
            聊天历史字典
        """
        # 确保已初始化
        self._ensure_initialized()

        try:
            query = AIChatHistory.query.filter_by(
                user_id=user_id,
                session_id=session_id
            ).order_by(AIChatHistory.created_at.desc())

            # 分页
            pagination = query.paginate(page=page, per_page=page_size, error_out=False)

            return {
                'success': True,
                'list': [msg.to_dict() for msg in pagination.items[::-1]],  # 反转，使最早的在前
                'total': pagination.total,
                'page': page,
                'page_size': page_size,
                'has_more': pagination.has_next
            }
        except Exception as e:
            current_app.logger.error(f'Get chat history error: {str(e)}')
            return {
                'success': False,
                'error': '获取聊天历史失败',
                'detail': str(e)
            }


# 创建全局实例
ai_agent = AIAgent()
