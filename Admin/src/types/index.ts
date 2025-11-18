/**
 * 通用类型定义
 */

// 分页参数
export interface PageParams {
  page: number;
  pageSize: number;
}

// 分页响应
export interface PageResponse<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}

// 用户类型
export interface User {
  id: number;
  phone: string;
  nickname?: string;
  avatar?: string;
  wechatOpenid?: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

// 陪诊师类型
export interface Companion {
  id: number;
  name: string;
  phone: string;
  idCard: string;
  avatar?: string;
  gender: 'male' | 'female';
  age?: number;
  experience: string;
  introduction?: string;
  hourlyRate: number;
  rating: number;
  orderCount: number;
  isVerified: boolean;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

// 陪诊机构类型
export interface Institution {
  id: number;
  name: string;
  logo?: string;
  contactName: string;
  contactPhone: string;
  address: string;
  description?: string;
  businessLicense: string;
  rating: number;
  serviceCount: number;
  isVerified: boolean;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

// 订单类型
export interface Order {
  id: number;
  orderNo: string;
  userId: number;
  companionId?: number;
  institutionId?: number;
  serviceType: 'companion' | 'institution';
  patientName: string;
  patientPhone: string;
  hospitalName: string;
  appointmentTime: string;
  requirements?: string;
  amount: number;
  status: 'pending_payment' | 'paid' | 'in_progress' | 'completed' | 'cancelled' | 'refunded';
  createdAt: string;
  updatedAt: string;
}

// 管理员类型
export interface Admin {
  id: number;
  username: string;
  email?: string;
  role: 'super_admin' | 'admin' | 'operator';
  isActive: boolean;
  lastLogin?: string;
  createdAt: string;
  updatedAt: string;
}

// 登录表单
export interface LoginForm {
  username: string;
  password: string;
}

// 登录响应
export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  expires_in: number;
  admin: Admin;
}
