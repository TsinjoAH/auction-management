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

  auctionTotal!: any;
  userTotal!: any;
  commissionTotal!: any;


  auctionTotalData: IncreaseRateData = {
    title: "Total des encheres",
    data: this.auctionTotal,
    getTotal: () => this.auctionTotal?.total,
    getRate: () => Math.round(this.auctionTotal?.increaserate * 10000)/100
  }
  userTotalData: IncreaseRateData = {
    title: "Utilisateurs",
    data: this.userTotal,
    getTotal: () => this.userTotal?.usercount,
    getRate: () => (this.userTotal?.increaserate * 10000) / 100
  }

  commission: IncreaseRateData = {
    title: "Commission",
    data: this.commissionTotal,
    getTotal: () => this.commissionTotal?.totalcommission,
    getRate: () => (this.commissionTotal?.increaserate * 10000) / 100
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

  top10 = () => [
    {
      title: "Top des utilisateurs createurs",
      data: this.userTopAuction,
      ratePresent: true
    },
    {
      title:"Top Vendeur",
      data: this.userTopCommission,
      ratePresent: true
    },
    {
      title:"Analyse sur les produits",
      data: this.productTopAuction,
      ratePresent: false
    },
    {
      title:"Analyse des categories",
      data: this.categoryTopAuction,
      ratePresent: false
    }
  ]


  ngOnInit(): void {
    this.loadAuctionCountData({
      min: "2020-01-01",
      max: "2023-01-20"
    });
    this.loadCommissionDayData({
      min: "2020-01-01",
      max: "2023-01-20"
    })
    this.fetchIncreaseRated();
    this.fetchTables();
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
    });
    this.service.fetchUserCount().subscribe({
      next: res => {
        this.userTotal = res.data;
      },
      error: err => console.log(err)
    });
    this.service.fetchTotalCommission().subscribe({
      next: res=> {
        this.commissionTotal = res.data;
      },
      error: err => console.log(err)
    })
  }

  private fetchTables() {
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

    let columns = [
        (elt: any) => elt.name,
        (elt: any) => elt.auction,
        (elt: any) => elt.sold,
        (elt: any) => elt.commission,
        (elt: any) => elt.bid,
        (elt: any) => elt.ratio
      ];

    this.service.fetchProductData(0).subscribe({
      next: res => {
        this.productTopAuction = {
          data: res.data,
          headers: headers("Produit"),
          columns: columns,
          getRate: (elt) => ((elt.rate * 10000)/100)
        }
      },
      error: err => console.log(err)
    });

    this.service.fetchCategoryData(0).subscribe({
      next: (res) => {
        this.categoryTopAuction = {
          data: res.data,
          headers: headers("Categories"),
          columns: columns,
          getRate: (elt) => (elt.rate * 10000)/100
        };
      },
      error: (err) => console.log(err)
    })
  }

}
