/**
 * 仪表盘页面
 */
import { Card, Col, Row, Statistic } from 'antd';
import {
  UserOutlined,
  TeamOutlined,
  ShopOutlined,
  DollarOutlined,
} from '@ant-design/icons';

export default function Dashboard() {
  return (
    <div>
      <h1>数据概览</h1>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="总用户数"
              value={1234}
              prefix={<UserOutlined />}
              valueStyle={{ color: '#667eea' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="陪诊师数量"
              value={89}
              prefix={<TeamOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="陪诊机构"
              value={23}
              prefix={<ShopOutlined />}
              valueStyle={{ color: '#1890ff' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="总订单额"
              value={234567}
              prefix={<DollarOutlined />}
              precision={2}
              valueStyle={{ color: '#fa8c16' }}
            />
          </Card>
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 24 }}>
        <Col span={24}>
          <Card title="最近订单">
            <p>订单列表功能待实现...</p>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
