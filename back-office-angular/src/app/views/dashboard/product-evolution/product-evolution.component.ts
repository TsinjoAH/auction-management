import { Component, OnInit } from '@angular/core';
import {brandInfo, brandInfoBg, getOptions} from "../chart.config";

@Component({
  selector: 'app-product-evolution',
  templateUrl: './product-evolution.component.html',
  styleUrls: ['./product-evolution.component.scss']
})
export class ProductEvolutionComponent implements OnInit {
  options = getOptions(10);
  data: any;
  ngOnInit () {
    this.options.scales.y.max = 65
    this.data = {
      datasets: [
        {
          data: [1, 12, 14, 0, 17, 52, 63, 12],
          backgroundColor: brandInfoBg,
          borderColor: brandInfo,
          pointHoverBackgroundColor: brandInfo,
          borderWidth: 2,
          fill: true,
          label: `Evolution de ration`
        }
      ],
      labels: ["2023-01-01","2023-01-01","2023-01-01","2023-01-01","2023-01-01","2023-01-01","2023-01-01","2023-01-01"]
    }
  }

}
