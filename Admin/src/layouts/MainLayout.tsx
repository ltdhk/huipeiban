/**
 * 主布局组件
 */
import { useState } from 'react';
import { Layout, Menu, Button, Dropdown, Avatar, Space } from 'antd';
import {
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  DashboardOutlined,
  UserOutlined,
  TeamOutlined,
  ShopOutlined,
  FileTextOutlined,
  MessageOutlined,
  SettingOutlined,
  LogoutOutlined,
} from '@ant-design/icons';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import type { MenuProps } from 'antd';
import './MainLayout.css';

const { Header, Sider, Content } = Layout;

export default function MainLayout() {
  const [collapsed, setCollapsed] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  const menuItems: MenuProps['items'] = [
    {
      key: '/dashboard',
      icon: <DashboardOutlined />,
      label: '数据概览',
    },
    {
      key: '/users',
      icon: <UserOutlined />,
      label: '用户管理',
    },
    {
      key: '/companions',
      icon: <TeamOutlined />,
      label: '陪诊师管理',
    },
    {
      key: '/institutions',
      icon: <ShopOutlined />,
      label: '机构管理',
    },
    {
      key: '/orders',
      icon: <FileTextOutlined />,
      label: '订单管理',
    },
    {
      key: '/messages',
      icon: <MessageOutlined />,
      label: '消息管理',
    },
    {
      key: '/settings',
      icon: <SettingOutlined />,
      label: '系统设置',
    },
  ];

  const handleMenuClick: MenuProps['onClick'] = ({ key }) => {
    navigate(key);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('admin');
    navigate('/login');
  };

  const userMenuItems: MenuProps['items'] = [
    {
      key: 'logout',
      icon: <LogoutOutlined />,
      label: '退出登录',
      onClick: handleLogout,
    },
  ];

  return (
    <Layout className="main-layout">
      <Sider trigger={null} collapsible collapsed={collapsed}>
        <div className="logo">
          <h2>{collapsed ? '会' : '会照护'}</h2>
        </div>
        <Menu
          theme="dark"
          mode="inline"
          selectedKeys={[location.pathname]}
          items={menuItems}
          onClick={handleMenuClick}
        />
      </Sider>
      <Layout style={{ marginLeft: collapsed ? 80 : 200 }}>
        <Header className="site-layout-header">
          <Button
            type="text"
            icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
            onClick={() => setCollapsed(!collapsed)}
            className="trigger"
          />
          <Dropdown menu={{ items: userMenuItems }} placement="bottomRight">
            <Space className="user-info">
              <Avatar icon={<UserOutlined />} />
              <span>管理员</span>
            </Space>
          </Dropdown>
        </Header>
        <Content className="site-layout-content">
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
