import { ComponentFixture, TestBed } from '@angular/core/testing';

import { IncreaseRatedComponent } from './increase-rated.component';

describe('IncreaseRatedComponent', () => {
  let component: IncreaseRatedComponent;
  let fixture: ComponentFixture<IncreaseRatedComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ IncreaseRatedComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(IncreaseRatedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
