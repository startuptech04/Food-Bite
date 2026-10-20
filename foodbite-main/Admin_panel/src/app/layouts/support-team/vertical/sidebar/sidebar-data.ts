import { NavItem } from './nav-item/nav-item';

export const navItems: NavItem[] = [
  {
    displayName: 'dashboard',
    iconName: 'tablerChartPie2',
    route: '/support-team',
    isPrivate: false,
    key: 'dashboard'
  },
  {
    displayName: 'customers',
    iconName: 'tablerUsers',
    route: '/support-team/u/customer',
    isPrivate: false,
    key: 'customer'
  },
  {
    displayName: 'restaurants',
    iconName: 'tablerBuildingStore',
    route: '/support-team/u/restaurants',
    isPrivate: false,
    key: 'restaurants'
  },
  {
    displayName: 'deliveryman',
    iconName: 'tablerRun',
    route: '/support-team/u/deliveryman',
    isPrivate: false,
    key: 'deliveryman'
  },
  {
    displayName: 'chat_list',
    iconName: 'tablerMessage',
    route: '/support-team/u/chat-list',
    isPrivate: false,
    key: 'chat-list'
  },
];
