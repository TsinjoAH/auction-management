import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {Category} from "../../../../shared/shared.interfaces";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";

export interface CategoryFormData {
  category?: Category;
  title: string;
  actionButton: string;
}

@Component({
  selector: 'app-category-form-modal',
  templateUrl: './category-form-modal.component.html',
  styleUrls: ['./category-form-modal.component.scss']
})
export class CategoryFormModalComponent implements OnInit {

  categoryForm!: FormGroup;

  constructor(
    public dialogRef: MatDialogRef<CategoryFormModalComponent>,
    public formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: {data: CategoryFormData}
  ) {
  }

  ngOnInit(): void {
    this.categoryForm = this.formBuilder.group({
      name: [this.data.data.category?.name, Validators.required]
    });
  }

  cancel() {
    this.dialogRef.close('canceled');
  }

  add() {
    if (this.categoryForm.valid) {
      alert(JSON.stringify(this.categoryForm.value, null, 2));
    }
  }

}
