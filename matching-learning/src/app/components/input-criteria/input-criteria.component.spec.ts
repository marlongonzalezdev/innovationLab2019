import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InputCriteriaComponent } from './input-criteria.component';

describe('InputCriteriaComponent', () => {
  let component: InputCriteriaComponent;
  let fixture: ComponentFixture<InputCriteriaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InputCriteriaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InputCriteriaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
