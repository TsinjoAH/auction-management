import {Component, OnInit, ViewChild} from '@angular/core';
import {Deposit, Product} from "../../../../shared/shared.interfaces";
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import Swal, {SweetAlertIcon} from "sweetalert2";
import {DepositService} from "../../../service/deposit/deposit.service";

interface PopupData {
  name: string;
  action: string;
  deposit: Deposit;
}

@Component({
  selector: 'app-deposit-list',
  templateUrl: './deposit-list.component.html',
  styleUrls: ['./deposit-list.component.scss']
})
export class DepositListComponent implements OnInit {
  deposits!: Deposit[];

  displayedColumns: string[] = ["id", "user", "date", "amount", "actions"];

  dataSource!: MatTableDataSource<Deposit>;
  @ViewChild(MatPaginator) paginator !: MatPaginator;
  @ViewChild(MatSort) sort !: MatSort;

  constructor(private service: DepositService) {
  }

  ngOnInit(): void {
    this.fetchToEvaluate();
  }


  filter(event: KeyboardEvent) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  async popup({name, action, deposit}: PopupData) {
    return Swal.fire(
      {
        title: name,
        text: `${action} le depot pour ${deposit.amount} AR de ${deposit.user.name}`,
        icon: 'warning' as SweetAlertIcon,
        confirmButtonText: 'Ok',
        allowOutsideClick: true,
        showCancelButton: true
      }
    )
  }

  async showResultPopup (title: string) {
    return Swal.fire({
      title: `${title} effectue`,
      icon: 'success' as SweetAlertIcon,
      confirmButtonText: 'Ok',
      allowOutsideClick: true
    });
  }

  validate(element: Deposit) {
    this.popup({name: 'Validation', action: 'Valider', deposit: element}).then(
      (result) => {
        if (result.isConfirmed) {
          this.service.validate(element.id).subscribe({
            next: res => {
              this.showResultPopup("Validation").then(() => {
                this.fetchToEvaluate();
              })
            },
            error: err => {}
          })
        }
      });
  }

  disapprove(element: Deposit) {
    this.popup({name: 'Rejet', action: 'Rejeter', deposit: element}).then((result) => {
      if (result.isConfirmed) {
        this.service.reject(element.id).subscribe({
          next: res => {
            this.showResultPopup("Rejet").then(() => {
              this.fetchToEvaluate();
            })
          },
          error: err => {}
        })
      }
    })
  }

  private fetchToEvaluate() {
    this.service.fetchToEvaluate().subscribe({
      next: res => {
        this.deposits = res.data;
        this.dataSource = new MatTableDataSource<Deposit>(this.deposits);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
      },
      error: err => {}
    })
  }

}
