import {Component, OnInit} from '@angular/core';
import {IntervalParam, StatService, StatWithDateData} from "../../service/stat/stat.service";
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

  constructor(private service: StatService) {}

  auctionStatInfo!: StatWithDateData;
  commissionStatInfo!: StatWithDateData;


  auctionTotal: any = {
    totalCount: 1569,
    increaseRate: 12.5
  }

  userTotal: any = {
    userCount: 152,
    increaseRate: 30
  }


  auctionTotalData: IncreaseRateData = {
    title: "Total des encheres",
    data: this.auctionTotal,
    getTotal: () => this.auctionTotal.total,
    getRate: () => Math.round(this.auctionTotal.increaserate * 10000)/100
  }

  commissionTotal = {
    totalCommission: 125000000,
    increaseRate: 25.78
  }

  userTotalData: IncreaseRateData = {
    title: "Utilisateurs",
    data: this.userTotal,
    getTotal: () => this.userTotal.userCount,
    getRate: () => this.userTotal.increaseRate
  }

  commission: IncreaseRateData = {
    title: "Commission",
    data: this.commissionTotal,
    getTotal: () => this.commissionTotal.totalCommission,
    getRate: () => this.commissionTotal.increaseRate
  }

  totalData = [
    this.auctionTotalData,
    this.userTotalData,
    this.commission
  ]

  userTopAuction!: Top10Data;
  userTopCommission!: Top10Data;
  productTopAuction!: Top10Data;
  categoryTopAuction!: Top10Data;


  ngOnInit(): void {
    this.loadAuctionCountData({
      min: "2020-01-01",
      max: "2023-01-01"
    });
    this.fetchIncreaseRated();
    this.fetchTop10();
  }

  loadAuctionCountData(data: IntervalParam) {
    this.service.fetchAuctionCount(data).subscribe({
      next: (res)=> {
        this.auctionStatInfo = {
          data: res.data,
          getCount: (elt: any) => elt.count,
          getDate: (elt: any) => new Date(elt.date),
          start: new Date(data.min),
          end: new Date(data.max)
        };
      },
      error: err => console.log(err)
    });
  }

  loadCommissionDayData(data: IntervalParam) {
    this.service.fetchCommissionByDate(data).subscribe({
      next: (res)=> {
        console.log(res);
        this.commissionStatInfo = {
          data: res.data,
          getCount: (elt: any) => elt.commission,
          getDate: (elt: any) => new Date(elt.date),
          start: new Date(data.min),
          end: new Date(data.max)
        };
      },
      error: err => console.log(err)
    });
  }

  private fetchIncreaseRated() {
    this.service.fetchTotalAuction().subscribe({
      next: res => {
        this.auctionTotal = res.data;
      },
      error: err => console.log(err)
    })
  }

  private fetchTop10() {
    this.service.fetchTopCreator().subscribe({
      next: res => {
        this.userTopAuction = {
          data: res.data,
          headers: ["Nom", "Enchere cree"],
          columns: [
            (elt:any) => elt.user.name,
            (elt:any) => elt.auctioncount
          ],
          getRate: (elt) => (elt.rate * 10000)/100
        }
      },
      error: err => console.log(err)
    });

    this.service.fetchTopSale().subscribe({
      next: res => {
        this.userTopCommission = {
          data: res.data,
          headers: ["Nom", "Vente reussi", "commission recolte"],
          columns: [
            (elt:any) => elt.user.name,
            (elt:any) => elt.sales,
            (elt:any) => elt.commission
          ],
          getRate: (elt) => (elt.rate*10000)/100
        }
      },
      error: err => console.log(err)
    });

    let headers = (name: string) => [
      name,
      "Nombre encheries",
      "Nombre vendues",
      "TotalCommission",
      "Nombre de proposition",
      "Moyenne ratio"
    ];

    this.service.fetchProductData().subscribe({
      next: res => {
        this.productTopAuction = {
          data: res.data,
          headers: headers("Produit"),
          columns: [
            (elt: any) => elt.product.name,
            (elt: any) => elt.salescount
          ],
          getRate: (elt) => ((elt.rate * 10000)/100)
        }
      },
      error: err => console.log(err)
    });

    this.service.fetchCategoryData().subscribe({
      next: (res) => {
        this.categoryTopAuction = {
          data: res.data,
          headers: headers("Categories"),
          columns: [
            (elt: any) => elt.category.name,
            (elt: any) => elt.salescount
          ],
          getRate: (elt) => (elt.rate * 10000)/100
        };
      },
      error: (err) => console.log(err)
    })
  }

}
