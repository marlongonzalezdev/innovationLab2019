import { Component, OnInit } from '@angular/core';

import { Observable } from 'rxjs';
import { RelationType } from 'src/app/shared/relationType';
import { Candidate } from 'src/app/shared/candidate';
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
      const candidate: Candidate = {
        id: this.service.form.controls.$key.value,
        name: this.service.form.controls.name.value,
        lastName: this.service.form.controls.lastName.value,
        du: this.service.form.controls.du.value,
        relationType: this.service.form.controls.relationType.value,
        email: this.service.form.controls.email.value,
        isInternal: this.service.form.controls.isInternal.value,
        isInBench: this.service.form.controls.isInBench.value
    };
      this.service.addCandidateWithObservable(candidate);
    }
  }
}
