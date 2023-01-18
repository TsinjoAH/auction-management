import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProductEvolutionComponent } from './product-evolution.component';

describe('ProductEvolutionComponent', () => {
  let component: ProductEvolutionComponent;
  let fixture: ComponentFixture<ProductEvolutionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProductEvolutionComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ProductEvolutionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
