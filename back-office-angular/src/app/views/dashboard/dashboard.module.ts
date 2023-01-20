import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './dashboard.component';
import {
    ButtonGroupModule,
    ButtonModule,
    CardModule,
    FormModule,
    GridModule,
    ProgressModule, TableModule,
    WidgetModule
} from "@coreui/angular";
import {ReactiveFormsModule} from "@angular/forms";
import {ChartjsModule} from "@coreui/angular-chartjs";
import {IconModule} from "@coreui/icons-angular";
import {MatSelectModule} from "@angular/material/select";
import {MatInputModule} from "@angular/material/input";
import {MatDatepickerModule} from "@angular/material/datepicker";
import {MatNativeDateModule} from "@angular/material/core";
import {MatRadioModule} from "@angular/material/radio";
import {MatButtonModule} from "@angular/material/button";
import { StatDateComponent } from './stat-date/stat-date.component';
import { IncreaseRatedComponent } from './increase-rated/increase-rated.component';
import { TopF10Component } from './top-f10/top-f10.component';



@NgModule({
  declarations: [
    DashboardComponent,
    StatDateComponent,
    IncreaseRatedComponent,
    TopF10Component
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
        IconModule,
        MatInputModule,
        MatDatepickerModule,
        MatNativeDateModule,
        MatRadioModule,
        MatButtonModule,
        MatSelectModule,
        WidgetModule,
        ProgressModule,
        TableModule
    ]
})
export class DashboardModule { }
