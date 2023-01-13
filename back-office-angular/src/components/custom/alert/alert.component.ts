import {Component, Inject} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";

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
