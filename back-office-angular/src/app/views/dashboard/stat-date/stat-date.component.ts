import {Component, EventEmitter, Input, Output, ViewChild} from '@angular/core';
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

  @Input() title!: string;

  @Input() set statInfo (data: StatWithDateData) {
    if (data) {
      this._statInfo = data;
      let infoDates = this.service.valuesByDates(this.statInfo);
      let infoMonths = this.service.valuesByMonths(this.statInfo);
      this.dayData = this.data(infoDates);
      this.monthData = this.data(infoMonths);
      let val = this.auctionCountForm?.value?.option === 'Day' ? this.dayData : this.monthData;
      this.select(val);
    }
  }

  selected: any;

  select (val: any){
    let max: number = Math.max(...val.datasets[0]?.data);
    this.options = getOptions(max * 1.2);
    this.selected = val;
  }

  @Output() dateParams: EventEmitter<any> = new EventEmitter<any>();

  get statInfo () {
    return this._statInfo;
  }

  data({data, labels}: StatData) {
    return {
      datasets: [
        {
          data: data,
          backgroundColor: brandInfoBg,
          borderColor: brandInfo,
          pointHoverBackgroundColor: brandInfo,
          borderWidth: 2,
          fill: true,
          label: `Nombre total des encheres`
        }
      ],
      labels: labels
    }
  }

  options !: any;

  constructor(
    private service: StatService,
    private formBuilder: FormBuilder,
    private pipe: DatePipe
  ) {}

  auctionCountForm !: FormGroup;
  auctionInterval!: FormGroup;

  dayData !: any;
  monthData !: any;

  @ViewChild("validateForm") btn !: MatButton;

  ngOnInit(): void {
    this.auctionCountForm = this.formBuilder.group({
      option: ['Day', Validators.required]
    });
    this.auctionInterval = this.formBuilder.group({
      min: ['2020-01-01', Validators.required],
      max: ['2023-01-21', Validators.required]
    })
  }

  setTrafficPeriod(value: string): void {
    if (value === 'Day') {
      if (this.dayData)
        this.select(this.dayData);
    }
    else {
      if (this.monthData)
        this.select(this.monthData);
    }
  }

  filter() {
    this.btn._elementRef.nativeElement.click();
    if (this.auctionInterval.valid) {
      this.dateParams.emit(this.auctionInterval.value);
    }
  }

}
