import { INavData } from '@coreui/angular';

export const navItems: INavData[] = [
  {
    name: 'Dashboard',
    url: '/cat',
    iconComponent: { name: 'cil-speedometer' },
    badge: {
      color: 'info',
      text: 'NEW'
    }
  },
  {
    name: 'Categories',
    url: '/categories',
    iconComponent: { name: 'cil-list' },
  },
  {
    name: 'Produits',
    url: '/products',
    iconComponent: { name: 'cil-list' },
  },
  {
    name: 'Depot',
    url: '/deposits',
    iconComponent: { name: 'cil-credit-card' },
  },
  {
    name: 'Commission',
    url: '/commission',
    iconComponent: {name: 'cil-settings'}
  }
];
