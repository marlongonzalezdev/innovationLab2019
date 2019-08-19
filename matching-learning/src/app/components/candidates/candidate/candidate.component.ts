import { Component, OnInit } from '@angular/core';
import {CandidateService} from '../../../shared/candidate.service';
import {RelationTypeService} from '../../../shared/relation-type.service';
import { DeliveryUnitService } from 'src/app/shared/delivery-unit.service';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  private deliveryUnits  = [];
  private relationTypes  = [];
  constructor(private service: CandidateService, private  deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService) { }

/*  deliveryUnits = [{ id: 1, value: 'Dep 1' },
    { id: 2, value: 'Dep 2' },
    { id: 3, value: 'Dep 3' }];*/

  ngOnInit() {
     this.deliveryUnits =  this.deliveryUnitService.getDeliveryUnits();
     this.relationTypes =  this.relationTypeService.getRelationTpes();
  }

  onClear() {
    this.service.form.reset();
    this.service.InitializeFormGroup();
  }

  onSubmit() {
    if (this.service.form.valid) {
      this.onClear();
    }
  }
}
