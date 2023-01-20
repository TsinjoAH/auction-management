import {Component, OnInit, ViewChild} from '@angular/core';
import {Category, ErrorData} from "../../../../shared/shared.interfaces";
import {MatTableDataSource} from "@angular/material/table";
import {MatSort} from "@angular/material/sort";
import {MatPaginator} from "@angular/material/paginator";
import {MatDialog} from "@angular/material/dialog";
import {CategoryFormData, CategoryFormModalComponent} from "./category-form-modal/category-form-modal.component";
import Swal, {SweetAlertIcon} from "sweetalert2";
import {CategoryService} from "../../../service/category/category.service";

export interface CrudPopUpData {
  name: string;
  text: string;
  icon: string;
}

@Component({
  selector: 'app-category',
  templateUrl: './category.component.html',
  styleUrls: ['./category.component.scss']
})
export class CategoryComponent implements OnInit {


  constructor(
    private dialog: MatDialog,
    private service: CategoryService
  ) {
  }

  categories!: Category[];

  displayedColumns: string[] = ["id", "name", "actions"];

  dataSource!: MatTableDataSource<Category>;
  @ViewChild(MatPaginator) paginator !: MatPaginator;
  @ViewChild(MatSort) sort !: MatSort;

  ngOnInit(): void {
    this.fetchCategories()
  }


  fetchCategories () {
    this.service.fetchAll().subscribe({
      next: res => {
        this.categories = res.data;
        this.dataSource = new MatTableDataSource<Category>(this.categories);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
      },
      error: res => {}
    })
  }

  filter(event: KeyboardEvent) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  openDialog(title: string, actionBtn: string, category?: Category) {
    return this.dialog.open(CategoryFormModalComponent, {
      data: {
        data: {
          category: category,
          title: title,
          actionButton: actionBtn
        } as CategoryFormData
      }
    });
  }

  modify(category: Category) {
    const ref = this.openDialog('Modifier categorie', 'Modifier', category);
    ref.afterClosed().subscribe(result => {
      if (result) {
        this.service.update(category.id, result).subscribe({
          next: res => {
            this.popup({
              name: 'Success',
              text: 'La categorie a ete mis a jour',
              icon: 'success'
            }).then(() => {
              this.fetchCategories();
            })
          },
          error: err => {
            let error = err as ErrorData;
            this.popup({
              name: 'Erreur',
              text: error.message,
              icon: 'danger'
            });
          }
        })
      }
    });
  }

  async popup({name, text, icon}: CrudPopUpData) {
    return Swal.fire(
      {
        title: name,
        text: text,
        icon: icon as SweetAlertIcon,
        confirmButtonText: 'Ok',
        allowOutsideClick: true
      }
    )
  }

  add () {
    const ref = this.openDialog('Ajouter categorie', 'Ajouter');
    ref.afterClosed().subscribe(result => {
      if (result) {
        this.service.create(result).subscribe({
          next: res => {
            this.popup({
              name: 'Success',
              text: 'La categorie a ete ajoute',
              icon: 'success'
            }).then(() => {
              this.fetchCategories();
            })
          },
          error: err => {
            let error = err as ErrorData;
            this.popup({
              name: 'Erreur',
              text: error.message,
              icon: 'danger'
            });
          }
        })
      }
    });
  }

  delete(category: Category) {
    Swal.fire({
      title: 'Etes vous sur ?',
      text: 'Veuillez confirmer la suppression',
      icon: 'warning' as SweetAlertIcon,
      confirmButtonText: 'Ok',
      allowOutsideClick: true,
      showCancelButton: true
    }).then(result => {
      if (result.value) {

      }
      else if (result.dismiss === Swal.DismissReason.cancel) {

      }
    })
  }

}
