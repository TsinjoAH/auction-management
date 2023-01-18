import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StatDateComponent } from './stat-date.component';

describe('StatDateComponent', () => {
  let component: StatDateComponent;
  let fixture: ComponentFixture<StatDateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StatDateComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(StatDateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
