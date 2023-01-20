import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DepositListComponent } from './deposit-list/deposit-list.component';
import {CardModule} from "@coreui/angular";
import {MatInputModule} from "@angular/material/input";
import {MatIconModule} from "@angular/material/icon";
import {MatTableModule} from "@angular/material/table";
import {MatPaginatorModule} from "@angular/material/paginator";
import {MatButtonModule} from "@angular/material/button";
import {MatSortModule} from "@angular/material/sort";



@NgModule({
  declarations: [
    DepositListComponent
  ],
    imports: [
        CommonModule,
        CardModule,
        MatInputModule,
        MatIconModule,
        MatTableModule,
        MatPaginatorModule,
        MatButtonModule,
        MatSortModule
    ]
})
export class DepositModule { }
