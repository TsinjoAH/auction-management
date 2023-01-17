import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { DefaultLayoutComponent } from './containers';
import {LoginComponent} from "./views/login/login.component";
import {CategoryComponent} from "./views/crud/category/category.component";
import {ProductComponent} from "./views/crud/product/product.component";
import {DepositListComponent} from "./views/deposit/deposit-list/deposit-list.component";
import {CommissionComponent} from "./views/commission/commission.component";
import {DashboardComponent} from "./views/dashboard/dashboard.component";

const routes: Routes = [
  {
    path: '',
    component: DefaultLayoutComponent,
    children: [
      {
        path: 'categories',
        component: CategoryComponent,
        pathMatch: "full"
      },
      {
        path: 'products',
        component: ProductComponent,
        pathMatch: 'full'
      },
      {
        path: 'deposits',
        component: DepositListComponent,
        pathMatch: 'full'
      },
      {
        path: 'commission',
        component: CommissionComponent,
        pathMatch: 'full'
      },
      {
        path: 'dashboard',
        component: DashboardComponent,
        pathMatch: 'full'
      }
    ]
  },
  {
    path: 'login',
    component: LoginComponent,
    pathMatch: 'full'
  }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, {
      scrollPositionRestoration: 'top',
      anchorScrolling: 'enabled',
      initialNavigation: 'enabledBlocking'
      // relativeLinkResolution: 'legacy'
    })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
