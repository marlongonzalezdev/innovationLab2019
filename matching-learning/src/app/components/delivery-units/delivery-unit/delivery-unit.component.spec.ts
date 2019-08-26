import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DeliveryUnitComponent } from './delivery-unit.component';

describe('DeliveryUnitComponent', () => {
  let component: DeliveryUnitComponent;
  let fixture: ComponentFixture<DeliveryUnitComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DeliveryUnitComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DeliveryUnitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
