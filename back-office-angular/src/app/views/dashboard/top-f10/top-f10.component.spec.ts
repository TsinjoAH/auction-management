import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TopF10Component } from './top-f10.component';

describe('TopF10Component', () => {
  let component: TopF10Component;
  let fixture: ComponentFixture<TopF10Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TopF10Component ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TopF10Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
