import {Component, OnInit, ViewChild} from '@angular/core';
import {FormBuilder, FormGroup, UntypedFormControl, UntypedFormGroup, Validators} from "@angular/forms";
import {StatService, StatWithDateData} from "../../service/stat/stat.service";
import {getStyle, hexToRgba} from "@coreui/utils/src";
import {StatData} from "../../../shared/shared.interfaces";
import {DatePipe} from "@angular/common";
import {MatButton} from "@angular/material/button";
import {IncreaseRateData} from "./increase-rated/increase-rated.component";
import {Top10Data} from "./top-f10/top-f10.component";

interface Total {
  totalCount: number;
  increaseRate: number;
}

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  constructor() {}

  auctionStatInfo: StatWithDateData = {
    data: [
      {
        count: 7,
        date: new Date(Date.parse("2023-01-15"))
      },
      {
        count: 10,
        date: new Date()
      },
      {
        count: 15,
        date: new Date()
      },
      {
        count: 30,
        date: new Date(new Date(Date.parse("2023-02-15")))
      }
    ],
    getCount: (elt) => elt.count,
    getDate: (elt) => elt.date,
    start: new Date(Date.parse("2023-01-01")),
    end: new Date(Date.parse("2023-02-28"))
  };
  commissionStatInfo: StatWithDateData = {
    data: [
      {
        commission: 7000,
        date: new Date(Date.parse("2022-10-15"))
      },
      {
        commission: 1000,
        date: new Date(Date.parse("2022-11-20"))
      },
      {
        commission: 5400,
        date: new Date(Date.parse("2022-12-01"))
      },
      {
        commission: 30,
        date: new Date(new Date(Date.parse("2023-02-15")))
      }
    ],
    getCount: (elt) => elt.commission,
    getDate: (elt) => elt.date,
    start: new Date(Date.parse("2022-10-15")),
    end: new Date(Date.parse("2023-02-28"))
  }


  auctionTotal: any = {
    totalCount: 1569,
    increaseRate: 12.5
  }

  userTotal: any = {
    userCount: 152,
    increaseRate: 30
  }


  auctionTotalData: IncreaseRateData = {
    data: this.auctionTotal,
    getTotal: () => this.auctionTotal.totalCount,
    getRate: () => this.auctionTotal.increaseRate
  }

  commissionTotal = {
    totalCommission: 125000000,
    increaseRate: 25.78
  }

  userTotalData: IncreaseRateData = {
    data: this.userTotal,
    getTotal: () => this.userTotal.userCount,
    getRate: () => this.userTotal.increaseRate
  }

  commission: IncreaseRateData = {
    data: this.commissionTotal,
    getTotal: () => this.commissionTotal.totalCommission,
    getRate: () => this.commissionTotal.increaseRate
  }

  totalData = [
    this.auctionTotalData,
    this.userTotalData,
    this.commission
  ]

  userTopAuction: Top10Data = {
    data: [
      {
        name: "Kenny",
        auctionCount: 12
      },
      {
        name: "Tsinjo",
        auctionCount: 15
      },
      {
        name: "Lars",
        auctionCount: 13
      },
      {
        name: "Lahatra",
        auctionCount: 18
      },
      {
        name: "Rova",
        auctionCount: 11
      }
    ],
    headers: ["Nom", "Enchere(s)", "Taux"],
    columns: ["name", "auctionCount"],
    getRate: (elt) => (elt.auctionCount/75)*100
  };
  userTopCommission: Top10Data = {
    data: [
      {
        name: "Kenny",
        sales: 12000,
        commission: 500
      },
      {
        name: "Tsinjo",
        sales: 15000,
        commission: 100
      },
      {
        name: "Lars",
        sales: 13000,
        commission: 350
      },
      {
        name: "Lahatra",
        sales: 18000,
        commission: 1250
      },
      {
        name: "Rova",
        sales: 11000,
        commission: 2350
      }
    ],
    headers: ["Nom", "Ventes realisez", "commission recolte", "Taux"],
    columns: ["name", "sales", "commission"],
    getRate: (elt) => (elt.commission/12000)*100
  };

  productTopAuction: Top10Data = {
    data: [
      {
        name: "Kenny",
        salesCount: 12
      },
      {
        name: "Tsinjo",
        salesCount: 15
      },
      {
        name: "Lars",
        salesCount: 13
      },
      {
        name: "Lahatra",
        salesCount: 18
      },
      {
        name: "Rova",
        salesCount: 11
      }
    ],
    headers: ["Produit", "Quantite Encherie(s)", "Taux"],
    columns: ["name", "salesCount"],
    getRate: (elt) => (elt.salesCount/75)*100
  };
  productTopSales: Top10Data = {
    data: [
      {
        name: "Kenny",
        sales: 12000,
        commission: 110
      },
      {
        name: "Tsinjo",
        sales: 15000,
        commission: 102
      },
      {
        name: "Lars",
        sales: 13000,
        commission: 130
      },
      {
        name: "Lahatra",
        sales: 18000,
        commission: 500
      },
      {
        name: "Rova",
        sales: 11000,
        commission: 185
      }
    ],
    headers: ["Produit", "Total vente", "total commission", "Taux"],
    columns: ["name", "sales", "commission"],
    getRate: (elt) => (elt.commission/100)*2.2
  };
  categoryTopAuction: Top10Data = {
    data: [
      {
        name: "Kenny",
        salesCount: 12
      },
      {
        name: "Tsinjo",
        salesCount: 15
      },
      {
        name: "Lars",
        salesCount: 13
      },
      {
        name: "Lahatra",
        salesCount: 18
      },
      {
        name: "Rova",
        salesCount: 11
      }
    ],
    headers: ["Categorie", "Quantite de produit Encherie(s)", "Taux"],
    columns: ["name", "salesCount"],
    getRate: (elt) => (elt.salesCount/75)*100
  };
  categoryTopSales: Top10Data = {
    data: [
      {
        name: "Kenny",
        sales: 12000,
        commission: 110
      },
      {
        name: "Tsinjo",
        sales: 12000,
        commission: 110
      },
      {
        name: "Lars",
        sales: 12000,
        commission: 110
      },
      {
        name: "Lahatra",
        sales: 12000,
        commission: 110
      },
      {
        name: "Rova",
        sales: 12000,
        commission: 110
      }
    ],
    headers: ["Category", "Total vente", "total commission", "Taux"],
    columns: ["name", "sales", "commission"],
    getRate: (elt) => (elt.commission/100)*2.2
  };


  ngOnInit(): void {
  }

}
