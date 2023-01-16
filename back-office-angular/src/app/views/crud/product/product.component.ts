import {Component, ViewChild} from '@angular/core';
import {Category, Product} from "../../../../shared/shared.interfaces";
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import Swal, {SweetAlertIcon} from "sweetalert2";
import {ProductFormData, ProductFormModalComponent} from "./product-form-modal/product-form-modal.component";
import {MatDialog} from "@angular/material/dialog";
import {ProductService} from "../../../service/product/product.service";

@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export class ProductComponent {
  products !: Product[];
  displayedColumns: string[] = ["id", "name", "category", "actions"];

  dataSource!: MatTableDataSource<Product>;
  @ViewChild(MatPaginator) paginator !: MatPaginator;
  @ViewChild(MatSort) sort !: MatSort;

  constructor(
    private dialog: MatDialog,
    private service: ProductService
  ) {
  }

  ngOnInit(): void {
    this.fetchProducts()
  }

  fetchProducts() {
    this.service.fetchAll().subscribe({
      next: res => {
        this.products = res.data;
        this.dataSource = new MatTableDataSource<Product>(this.products);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
      },
      error: err => {}
    })
  }

  filter(event: KeyboardEvent) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  openDialog(title: string, actionBtn: string, product?: Product) {
    const ref = this.dialog.open(ProductFormModalComponent, {
      data: {
        data: {
          product: product,
          title: title,
          actionButton: actionBtn
        }
      }
    });

    ref.afterClosed().subscribe(result => {});
  }

  modify(product: Product) {
    this.openDialog('Modifier categorie', 'Modifier', product);
  }

  add () {
    this.openDialog('Ajouter categorie', 'Ajouter');
  }

  delete(product: Product) {
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
