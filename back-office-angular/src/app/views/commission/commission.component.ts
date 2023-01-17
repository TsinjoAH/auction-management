import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {Commission} from "../../../shared/shared.interfaces";
import {CommissionService} from "../../service/commission/commission.service";
import {MatDialog} from "@angular/material/dialog";
import {CommissionFormComponent} from "./commission-form/commission-form.component";

@Component({
  selector: 'app-commission',
  templateUrl: './commission.component.html',
  styleUrls: ['./commission.component.scss']
})
export class CommissionComponent implements OnInit {

  rate!: Commission;

  constructor(
    private formBuilder: FormBuilder,
    private service: CommissionService,
    private dialog: MatDialog
  ) {
  }

  ngOnInit(): void {
    this.fetchCurrent();
  }

  private fetchCurrent() {
    this.service.fetchCurrent().subscribe({
      next: res => {
        this.rate = res.data;
      },
      error: err => {}
    })
  }

  openModal() {
    const ref = this.dialog.open(CommissionFormComponent);
    ref.afterClosed().subscribe(result => {
      if (result && result != 'cancel') {
        this.rate = result as Commission;
      }
    })
  }

}
