import {Component, Inject} from '@angular/core';
import {FormBuilder, FormControl, FormGroup, Validators} from "@angular/forms";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {Category, Product} from "../../../../../shared/shared.interfaces";
import {map, Observable, startWith} from "rxjs";

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

  filteredOptions!: Observable<Category[]>;



  constructor(
    public dialogRef: MatDialogRef<ProductFormModalComponent>,
    public formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: {data: ProductFormData}
  ) {
  }

  ngOnInit(): void {
    this.productForm = this.formBuilder.group({
      name: [this.data.data.product?.name, Validators.required],
      category: this.formBuilder.group({
        id: [this.data.data.product?.id, Validators.required]
      })
    });
    this.categoryControl = (this.productForm.get("category") as FormGroup).get("id") as FormControl;
    this.filteredOptions = this.categoryControl.valueChanges.pipe(
      startWith(''),
      map(value => this._filter(value || ''))
    );
  }

  cancel() {
    this.dialogRef.close('canceled');
  }

  add() {
    if (this.productForm.valid) {
      alert(JSON.stringify(this.productForm.value, null, 2));
    }
  }

  private _filter (value: string): Category[] {
    const val = value.toLowerCase();
    return this.categories.filter(cat => cat.name.toLowerCase().includes(val));
  }
}
