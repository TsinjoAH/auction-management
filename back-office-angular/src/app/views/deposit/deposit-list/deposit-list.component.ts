import {Component, OnInit, ViewChild} from '@angular/core';
import {Deposit, Product} from "../../../../shared/shared.interfaces";
import {MatTableDataSource} from "@angular/material/table";
import {MatPaginator} from "@angular/material/paginator";
import {MatSort} from "@angular/material/sort";
import Swal, {SweetAlertIcon} from "sweetalert2";

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
  deposits: Deposit[] = [
    {
      id: 1,
      amount: 100,
      date: new Date(),
      user: {
        id: 1,
        name: 'John Doe'
      }
    },
    {
      id: 2,
      amount: 200,
      date: new Date(),
      user: {
        id: 2,
        name: 'Jane Doe'
      }
    },
    {
      id: 3,
      amount: 300,
      date: new Date(),
      user: {
        id: 3,
        name: 'John Patrick'
      }
    }
  ];

  displayedColumns: string[] = ["id", "user", "date", "amount", "actions"];

  dataSource!: MatTableDataSource<Deposit>;
  @ViewChild(MatPaginator) paginator !: MatPaginator;
  @ViewChild(MatSort) sort !: MatSort;

  ngOnInit(): void {
    this.dataSource = new MatTableDataSource<Deposit>(this.deposits);
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

  validate(element: Deposit) {
    this.popup({name: 'Validation', action: 'Valider', deposit: element}).then(
      (result) => {
      });
  }

  disapprove(element: Deposit) {
    this.popup({name: 'Rejet', action: 'Rejeter', deposit: element}).then((result) => {})
  }

}
