import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DeliveryUnitsComponent } from './delivery-units.component';

describe('DeliveryUnitsComponent', () => {
  let component: DeliveryUnitsComponent;
  let fixture: ComponentFixture<DeliveryUnitsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DeliveryUnitsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DeliveryUnitsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
