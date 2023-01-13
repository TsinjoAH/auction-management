import {Component, OnInit, ViewChild} from '@angular/core';
import {Category} from "../../../shared/shared.interfaces";
import {MatTableDataSource} from "@angular/material/table";
import {MatSort} from "@angular/material/sort";
import {MatPaginator} from "@angular/material/paginator";
import {MatDialog} from "@angular/material/dialog";
import {CategoryFormData, CategoryFormModalComponent} from "./category-form-modal/category-form-modal.component";
import {AlertComponent} from "@custom-components/custom/alert/alert.component";

@Component({
  selector: 'app-category',
  templateUrl: './category.component.html',
  styleUrls: ['./category.component.scss']
})
export class CategoryComponent implements OnInit {

  constructor(
    private dialog: MatDialog
  ) {
  }

  categories: Category[] = [
    {
      id: 1,
      name: "Chaussures"
    },
    {
      id: 2,
      name: "Sac a dos"
    }
  ];

  displayedColumns: string[] = ["id", "name", "actions"];

  dataSource!: MatTableDataSource<Category>;
  @ViewChild(MatPaginator) paginator !: MatPaginator;
  @ViewChild(MatSort) sort !: MatSort;

  ngOnInit(): void {
    this.dataSource = new MatTableDataSource<Category>(this.categories);
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  filter(event: KeyboardEvent) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  openDialog(title: string, actionBtn: string, category?: Category) {
    const ref = this.dialog.open(CategoryFormModalComponent, {
      data: {
        data: {
          category: category,
          title: title,
          actionButton: actionBtn
        } as CategoryFormData
      }
    });

    ref.afterClosed().subscribe(result => {});
  }

  modify(category: Category) {
    this.openDialog('Modifier categorie', 'Modifier', category);
  }

  add () {
    this.openDialog('Ajouter categorie', 'Ajouter');
  }

  delete(category: Category) {
    this.dialog.open(AlertComponent);
  }

}
