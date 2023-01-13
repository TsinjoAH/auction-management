import {Component, Inject} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {FormBuilder} from "@angular/forms";
import {CategoryFormData} from "../../../app/views/category/category-form-modal/category-form-modal.component";

@Component({
  selector: 'app-alert',
  templateUrl: './alert.component.html',
  styleUrls: ['./alert.component.scss']
})
export class AlertComponent {

  constructor(
    public dialogRef: MatDialogRef<AlertComponent>
  ) {}

  confirm() {
    this.dialogRef.close(true);
  }

  cancel () {
    this.dialogRef.close(false);
  }
}
