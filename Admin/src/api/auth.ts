/**
 * 认证相关 API
 */
import request from '@/utils/request';
import { LoginForm, LoginResponse } from '@/types';

// 管理员登录
export const login = (data: LoginForm): Promise<LoginResponse> => {
  return request.post('/admin/auth/login', data);
};

// 获取当前管理员信息
export const getCurrentAdmin = () => {
  return request.get('/admin/auth/current');
};

// 退出登录
export const logout = () => {
  return request.post('/admin/auth/logout');
};
