import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import Swal, {SweetAlertIcon} from "sweetalert2";
import {MatDialogRef} from "@angular/material/dialog";
import {CommissionService} from "../../../service/commission/commission.service";

@Component({
  selector: 'app-commission-form',
  templateUrl: './commission-form.component.html',
  styleUrls: ['./commission-form.component.scss']
})
export class CommissionFormComponent implements OnInit {

  form!: FormGroup;

  constructor(
    private formBuilder: FormBuilder,
    private dialogRef: MatDialogRef<CommissionFormComponent>,
    private service: CommissionService
  ) {}

  ngOnInit() {
    this.form = this.formBuilder.group({
      rate: ['', [Validators.required, Validators.min(0), Validators.max(100)]]
    });
  }
  changeCommission() {
    if (this.form.valid) {
      let data = this.form.value as {rate: number};
      data.rate = data.rate / 100;
      this.service.change(data).subscribe({
        next: res => {
          Swal.fire({
            title: "Ajout de nouveau commission",
            icon: 'success' as SweetAlertIcon,
            confirmButtonText: 'Ok',
            allowOutsideClick: true
          }).then(() => {
            this.dialogRef.close(res.data);
          });
        },
        error: res => {}
      })
    }
  }

  cancel() {
    this.dialogRef.close('cancel');
  }
}
