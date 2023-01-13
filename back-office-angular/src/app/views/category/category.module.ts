import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CategoryComponent } from './category.component';
import {CardModule, GridModule} from "@coreui/angular";
import {MatInputModule} from "@angular/material/input";
import {MatIconModule} from "@angular/material/icon";
import {MatTableModule} from "@angular/material/table";
import {MatPaginatorModule} from "@angular/material/paginator";
import {MatButtonModule} from "@angular/material/button";
import { CategoryFormModalComponent } from './category-form-modal/category-form-modal.component';
import {MatDialogModule} from "@angular/material/dialog";
import {ReactiveFormsModule} from "@angular/forms";
import {MatDatepickerModule} from "@angular/material/datepicker";



@NgModule({
  declarations: [
    CategoryComponent,
    CategoryFormModalComponent
  ],
  imports: [
    CommonModule,
    CardModule,
    MatInputModule,
    MatIconModule,
    MatTableModule,
    MatPaginatorModule,
    MatButtonModule,
    MatDialogModule,
    ReactiveFormsModule,
    GridModule,
    MatDatepickerModule
  ]
})
export class CategoryModule { }
