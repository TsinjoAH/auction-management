import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './dashboard.component';
import {ButtonGroupModule, ButtonModule, CardModule, FormModule, GridModule} from "@coreui/angular";
import {ReactiveFormsModule} from "@angular/forms";
import {ChartjsModule} from "@coreui/angular-chartjs";
import {IconModule} from "@coreui/icons-angular";



@NgModule({
  declarations: [
    DashboardComponent
  ],
    imports: [
        CommonModule,
        CardModule,
        GridModule,
        ReactiveFormsModule,
        ButtonGroupModule,
        ButtonModule,
        FormModule,
        ChartjsModule,
        IconModule
    ]
})
export class DashboardModule { }
