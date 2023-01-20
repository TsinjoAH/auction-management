import { Injectable } from '@angular/core';
import {DatePipe} from "@angular/common";
import {getStyle, hexToRgba} from "@coreui/utils/src";
import {IChartProps, StatData} from "../../../shared/shared.interfaces";
import {HttpClient} from "@angular/common/http";
import {baseUrl, Response} from "../server.config";
import {AdminService} from "../login/admin/admin.service";

export interface StatWithDateData {
  data: any[];
  getCount: (elt: any) => number;
  getDate: (elt: any) => Date;
  start: Date;
  end: Date;
}

export interface IntervalParam {
  min: string;
  max: string;
}

export interface AuctionNumberStat {
  date: Date,
  count: number
}


@Injectable({
  providedIn: 'root'
})
export class StatService {

  constructor(
    private pipe: DatePipe,
    private http: HttpClient,
    private authService: AdminService
  ){}

  fetchCommissionByDate ({min, max}: IntervalParam) {
    return this.http.get<Response<AuctionNumberStat[]>>(baseUrl(`stats/commissionperday`), {
      params: {
        min: this.pipe.transform(min, "YYYY-MM-dd") ?? "",
        max: this.pipe.transform(max, "YYYY-MM-dd") ?? ""
      },
      headers: this.authService.headers()
    })
  }

  fetchAuctionCount({min, max}: IntervalParam) {
    return this.http.get<Response<AuctionNumberStat[]>>(baseUrl(`stats/perday`), {
      params: {
        min: this.pipe.transform(min, "YYYY-MM-dd") ?? "",
        max: this.pipe.transform(max, "YYYY-MM-dd") ?? ""
      },
      headers: this.authService.headers()
    })
  }

  fetchTotalAuction () {
    return this.http.get<Response<any>>(baseUrl("stats/totalIncrease"), {
      headers: this.authService.headers()
    });
  }

  fetchTotalCommission () {
    return this.http.get<Response<any>>(baseUrl("stats/commissiontotalIncrease"), {
      headers: this.authService.headers()
    })
  }

  fetchUserCount () {
    return this.http.get<Response<any>>(baseUrl("stats/usertotalIncrease"), {
      headers: this.authService.headers()
    });
  }

  getDateList (d1: Date, d2: Date) {
    let dateList:Date[] = [d1];
    let str: string[] = [this.pipe.transform(d1, "dd-MM-YYYY") ?? ""];
    let d = this.addOneDay(d1);
    while (d < d2) {
      dateList.push(d);
      str.push(this.pipe.transform(d, "dd-MM-YYYY") ?? "")
      d = this.addOneDay(d);
    }
    return {
      dates: dateList,
      labels: str
    };
  }

  private addOneDay(date: Date) {
    return new Date(new Date(date).getTime() + (1000 * 3600 * 24));
  }

  getMonthList(d1: Date, d2: Date) {
    let months: Date[] = [];
    let str: string[] = []
    let _d1: Date = new Date(d1);
    while (this.compareMonthAndYear(_d1 , d2) <= 0) {
      months.push(_d1);
      str.push(this.pipe.transform(_d1, "MMMM yyyy") ?? "")
      _d1 = new Date(_d1);
      _d1.setMonth(_d1.getMonth() + 1);
    }
    return {
      months: months,
      labels: str
    };
  }

  private copyDate(d: Date) {
    return new Date(Date.parse(this.pipe.transform(d, "YYYY-MM-dd") ?? ""));
  }

  valuesByDates({data, getDate, getCount, start, end}: StatWithDateData) : StatData {
    let {dates, labels} = this.getDateList(start, end);
    let counts: number[] = [];
    let i: number = 0;
    let j: number = 0;
    for (let d of dates) {
      d = this.copyDate(d);
      counts.push(0);
      for (; i < data.length;) {
        if (getDate(data[i]).getTime() === d.getTime()) {
          counts[j] = counts[j] + getCount(data[i]);
          i++;
        }
        else break;
      }
      j++;
    }
    return {data: counts, labels: labels, start: start, end: end};
  }

  compareMonthAndYear(d1: Date, d2: Date) {
    d1 = new Date(d1);
    d2 = new Date(d2);
    let mDif = d1.getMonth() - d2.getMonth();
    let yDif = d1.getFullYear() - d2.getFullYear();
    if (yDif != 0) return yDif;
    return mDif;
  }

  compareDate (d1: Date, d2: Date) {
    d1 = new Date(d1);
    d2 = new Date(d2);
    return d1.getTime() === d2.getTime();
  }

  valuesByMonths({data, getDate, getCount, start, end}: StatWithDateData): StatData {
    let {months, labels } = this.getMonthList(start, end);
    let counts: number[] = [];
    let i: number = 0;
    let j: number = 0;
    for (let m of months) {
      counts.push(0);
      for (; i < data.length; i++) {
        if (this.compareMonthAndYear(getDate(data[i]), m) == 0) {
          counts[j] = counts[j] + getCount(data[i]);
        }
        else break;
      }
      j++;
    }
    return {data: counts, labels: labels, start: start, end: end};
  }

  fetchTopCreator() {
    return this.http.get<Response<any[]>>(baseUrl("stats/userauction"), {
      headers: this.authService.headers()
    });
  }

  fetchTopSale () {
    return this.http.get<Response<any[]>>(baseUrl("stats/usersale"), {
      headers: this.authService.headers()
    });
  }

  fetchProductData(page: number) {
    return this.http.get<Response<any[]>>(baseUrl("stats/product/"+page), {
      headers: this.authService.headers()
    });
  }

  fetchCategoryData (page: number) {
    return this.http.get<Response<any[]>>(baseUrl("stats/category/"+page), {
      headers: this.authService.headers()
    });
  }

}
