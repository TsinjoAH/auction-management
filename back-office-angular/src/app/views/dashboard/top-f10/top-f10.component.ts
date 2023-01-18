import {Component, Input} from '@angular/core';
export interface Top10Data {
  data: any[]
  headers: string[];
  columns: string[];
  getRate: (elt: any) => number
}

@Component({
  selector: 'app-top-f10',
  templateUrl: './top-f10.component.html',
  styleUrls: ['./top-f10.component.scss']
})
export class TopF10Component {

  @Input() data!: Top10Data;

  getColor(value: number ){
    let numbers: number[] = [0, 10, 10, 51, 68, 85, 100];
    let colors: string[] = ['danger', 'primary', 'success', 'warning', 'danger', 'dark'];
    for (let i = 0; i < numbers.length - 1; i++) {
      if (value >= numbers[i] && value <= numbers[i+1]) {
        return colors[i];
      }
    }
    return 'info';
  }

}
