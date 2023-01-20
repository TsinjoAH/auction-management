import {Component, Inject} from '@angular/core';
import {FormBuilder, FormControl, FormGroup, Validators} from "@angular/forms";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {Category, Product} from "../../../../../shared/shared.interfaces";
import {map, Observable, startWith} from "rxjs";
import {CategoryService} from "../../../../service/category/category.service";

export interface ProductFormData {
  product?: Product;
  title: string;
  actionButton: string;
}

@Component({
  selector: 'app-product-form-modal',
  templateUrl: './product-form-modal.component.html',
  styleUrls: ['./product-form-modal.component.scss']
})
export class ProductFormModalComponent {

  productForm!: FormGroup;
  categoryControl!: FormControl;

  categories!: Category[];


  constructor(
    public dialogRef: MatDialogRef<ProductFormModalComponent>,
    public formBuilder: FormBuilder,
    private categoryService: CategoryService,
    @Inject(MAT_DIALOG_DATA) public data: {data: ProductFormData}
  ) {
  }

  ngOnInit(): void {
    this.productForm = this.formBuilder.group({
      name: [this.data.data.product?.name, Validators.required],
      category: this.formBuilder.group({
        id: [this.data.data.product?.category.id, Validators.required]
      })
    });
    this.categoryControl = (this.productForm.get("category") as FormGroup).get("id") as FormControl;
    this.categoryControl.setValue(this.data.data.product?.id);
    this.categoryService.fetchAll().subscribe({
      next: res => {
        this.categories = res.data;
      },
      error: err => console.log(err)
    })
  }

  cancel() {
    this.dialogRef.close(false);
  }

  add() {
    if (this.productForm.valid) {
      this.dialogRef.close(this.productForm.value)
    }
  }

}
