import {Component, Input} from '@angular/core';

export interface IncreaseRateData {
  title: string;
  data: any;
  getTotal: () => number;
  getRate: () => number;
}

@Component({
  selector: 'app-increase-rated',
  templateUrl: './increase-rated.component.html',
  styleUrls: ['./increase-rated.component.scss']
})
export class IncreaseRatedComponent {

  @Input() data!: IncreaseRateData[];

}
