import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CommissionFormComponent } from './commission-form.component';

describe('CommissionFormComponent', () => {
  let component: CommissionFormComponent;
  let fixture: ComponentFixture<CommissionFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CommissionFormComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CommissionFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
