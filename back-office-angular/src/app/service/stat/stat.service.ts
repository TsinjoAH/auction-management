import { Injectable } from '@angular/core';
import {DatePipe} from "@angular/common";
import {getStyle, hexToRgba} from "@coreui/utils/src";
import {IChartProps, StatData} from "../../../shared/shared.interfaces";

export interface StatWithDateData {
  data: any[];
  getCount: (elt: any) => number;
  getDate: (elt: any) => Date;
  start: Date;
  end: Date;
}


@Injectable({
  providedIn: 'root'
})
export class StatService {

  constructor(private pipe: DatePipe) { }

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
    return new Date(date.getTime() + (1000 * 3600 * 24));
  }

  getMonthList(d1: Date, d2: Date) {
    let m1 = d1.getMonth(), m2 = d2.getMonth();
    let months: number[] = [];
    let str: string[] = []
    let _d1: Date = new Date(d1);
    while (_d1 < d2) {
      months.push(_d1.getMonth());
      str.push(this.pipe.transform(_d1, "MMMM yyyy") ?? "")
      _d1 = new Date(_d1.setMonth(_d1.getMonth() + 1));
    }
    return {
      months: months,
      labels: str
    };
  }

  valuesByDates({data, getDate, getCount, start, end}: StatWithDateData) : StatData {
    let {dates, labels} = this.getDateList(start, end);
    let counts: number[] = [];
    let i: number = 0;
    let j: number = 0;
    for (let d of dates) {
      counts.push(0)
      for (; i < data.length; i++) {
        if (getDate(data[i]).getDate() == d.getDate()) {
          counts[j] = counts[j] + getCount(data[i]);
        }
        else break;
      }
      j++;
    }
    return {data: counts, labels: labels, start: start, end: end};
  }

  valuesByMonths({data, getDate, getCount, start, end}: StatWithDateData): StatData {
    let {months, labels } = this.getMonthList(start, end);
    let counts: number[] = [];
    let i: number = 0;
    let j: number = 0;
    for (let m of months) {
      counts.push(0);
      for (; i < data.length; i++) {
        if (getDate(data[i]).getMonth() == m) {
          counts[j] = counts[j] + getCount(data[i]);
        }
        else break;
      }
      j++;
    }
    return {data: counts, labels: labels, start: start, end: end};
  }

}