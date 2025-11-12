/**
 * 应用主组件
 */
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN';
import MainLayout from '@/layouts/MainLayout';
import Login from '@/pages/Login';
import Dashboard from '@/pages/Dashboard';
import './App.css';

// 主题配置
const theme = {
  token: {
    colorPrimary: '#667eea',
    borderRadius: 6,
  },
};

function App() {
  return (
    <ConfigProvider locale={zhCN} theme={theme}>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/" element={<MainLayout />}>
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard" element={<Dashboard />} />
            <Route path="users" element={<div>用户管理页面（待实现）</div>} />
            <Route path="companions" element={<div>陪诊师管理页面（待实现）</div>} />
            <Route path="institutions" element={<div>机构管理页面（待实现）</div>} />
            <Route path="orders" element={<div>订单管理页面（待实现）</div>} />
            <Route path="messages" element={<div>消息管理页面（待实现）</div>} />
            <Route path="settings" element={<div>系统设置页面（待实现）</div>} />
          </Route>
        </Routes>
      </BrowserRouter>
    </ConfigProvider>
  );
}

export default App;
