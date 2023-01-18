import {Component, Input, ViewChild} from '@angular/core';
import {getStyle, hexToRgba} from "@coreui/utils/src";
import {StatData} from "../../../../shared/shared.interfaces";
import {StatService, StatWithDateData} from "../../../service/stat/stat.service";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {DatePipe} from "@angular/common";
import {MatButton} from "@angular/material/button";
import {max} from "rxjs";
import {brandInfo, brandInfoBg, getOptions} from "../chart.config";

@Component({
  selector: 'app-stat-date',
  templateUrl: './stat-date.component.html',
  styleUrls: ['./stat-date.component.scss']
})
export class StatDateComponent {

  private _statInfo!: StatWithDateData;

  @Input() set statInfo (data: StatWithDateData) {
    this._statInfo = data;
    let infoDates = this.service.valuesByDates(this.statInfo);
    let infoMonths = this.service.valuesByMonths(this.statInfo);
    this.dayData = this.data(infoDates);
    this.monthData = this.data(infoMonths);
    this.selected = this.dayData;
  }

  get statInfo () {
    return this._statInfo;
  }

  data({data, labels, start, end}: StatData) {
    let max: number = Math.max(...data);
    this.options.scales.y.max = max * 1.2;
    return {
      datasets: [
        {
          data: data,
          backgroundColor: brandInfoBg,
          borderColor: brandInfo,
          pointHoverBackgroundColor: brandInfo,
          borderWidth: 2,
          fill: true,
          label: `Entre ${this.pipe.transform(start)} et ${this.pipe.transform(end)}`
        }
      ],
      labels: labels
    }
  }

  options = getOptions();

  constructor(
    private service: StatService,
    private formBuilder: FormBuilder,
    private pipe: DatePipe
  ) {}

  auctionCountForm !: FormGroup;
  auctionInterval!: FormGroup;

  dayData !: any;
  monthData !: any;
  selected!: any;

  @ViewChild("validateForm") btn !: MatButton;

  ngOnInit(): void {
    this.auctionCountForm = this.formBuilder.group({
      option: ['Day', Validators.required]
    });
    this.auctionInterval = this.formBuilder.group({
      start: ['', Validators.required],
      end: ['', Validators.required]
    })
  }

  setTrafficPeriod(value: string): void {
    if (value === 'Day') {
      this.selected = this.dayData;
    }
    else {
      this.selected = this.monthData;
    }
  }

  filter() {
    this.btn._elementRef.nativeElement.click();
  }

}
