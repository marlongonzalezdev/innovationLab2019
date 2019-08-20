import { Component, OnInit } from '@angular/core';

import { Observable } from 'rxjs';
import { RelationType } from 'src/app/shared/relationType';
import { DeliveryUnit } from 'src/app/shared/deliveryUnit';
import { CandidateService } from 'src/app/shared/services/candidate.service';
import { DeliveryUnitService } from 'src/app/shared/services/delivery-unit.service';
import { RelationTypeService } from 'src/app/shared/services/relation-type.service';

@Component({
  selector: 'app-candidate',
  templateUrl: './candidate.component.html',
  styleUrls: ['./candidate.component.css']
})
export class CandidateComponent implements OnInit {

  deliveryUnits: Observable<RelationType[]>;
  relationTypes: Observable<DeliveryUnit[]>;

  constructor(private service: CandidateService, private  deliveryUnitService: DeliveryUnitService,
              private relationTypeService: RelationTypeService) { }

  ngOnInit() {
    this.deliveryUnits = this.deliveryUnitService.getDeliveryUnits();
    this.relationTypes =  this.relationTypeService.getRelationTypes();
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
