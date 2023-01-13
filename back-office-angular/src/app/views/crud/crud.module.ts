import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {CategoryComponent} from "./category/category.component";
import {CategoryFormModalComponent} from "./category/category-form-modal/category-form-modal.component";
import {MatIconModule} from "@angular/material/icon";
import {MatPaginatorModule} from "@angular/material/paginator";
import {MatLegacyTableModule} from "@angular/material/legacy-table";
import {CardModule, GridModule} from "@coreui/angular";
import {MatInputModule} from "@angular/material/input";
import {MatButtonModule} from "@angular/material/button";
import {ReactiveFormsModule} from "@angular/forms";
import {MatDialogModule} from "@angular/material/dialog";
import {CustomModule} from "@custom-components/custom/custom.module";
import {MatTableModule} from "@angular/material/table";
import {SweetAlert2Module} from "@sweetalert2/ngx-sweetalert2";



@NgModule({
  declarations: [CategoryComponent, CategoryFormModalComponent],
  imports: [
    CommonModule,
    MatIconModule,
    MatPaginatorModule,
    CardModule,
    MatInputModule,
    MatButtonModule,
    ReactiveFormsModule,
    GridModule,
    MatDialogModule,
    CustomModule,
    MatTableModule,
    SweetAlert2Module
  ]
})
export class CrudModule { }
